---
title:  乐观锁与悲观锁的实际应用
date: 2016-10-01 19:20:43
updated: 2016-10-01 20:19:21
categories: 并发控制相关知识点
tags: [并发控制, 锁]
copyright: true
mathjax: true
---

### 高并发场景
&emsp;&emsp;首先假设一个业务场景：数据库中有一条数据，需要获取到当前的值，在当前值的基础上$+10$，然后再更新回去。如果此时有两个线程同时并发处理，第一个线程拿到数据是$10，+10=20$更新回去。第二个线程原本是要在第一个线程的基础上再$+20=40$,结果由于并发访问取到更新前的数据为$10，+20=30$。
这就是典型的存在中间状态，导致数据不正确。来看以下的例子：
并发所带来的问题，和上文提到的类似，这里有一张price表，表结构如下：

```sql
CREATE TABLE `price` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `total` decimal(12,2) DEFAULT '0.00' COMMENT '总值',
  `front` decimal(12,2) DEFAULT '0.00' COMMENT '消费前',
  `end` decimal(12,2) DEFAULT '0.00' COMMENT '消费后',
  `add_time` timestamp NULL DEFAULT NULL COMMENT '添加时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP, COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8
```

<!--more-->

单测例子如下([Github代码地址]())：

```java
//就一个主线程，循环100次，每次把front的值减去10，再写入一次流水记录，正常情况是写入的每条记录都会每次减去10。
 @Test
    public void singleCounsumerTest() {

        for (int i = 0; i < 100; i++) {
            Price price = priceMapper.selectByPrimaryKey(1);
            int ron = 10;
            price.setFront(price.getFront().subtract(new BigDecimal(ron)));
            price.setEnd(price.getEnd().add(new BigDecimal(ron)));
            price.setTotal(price.getFront().add(price.getEnd()));

            priceMapper.updateByPrimaryKey(price);
            price.setId(null);
            priceMapper.insertSelective(price);
        }
    }
```
执行结果如下图：
![图（1）](http://p5vswdxl9.bkt.clouddn.com/result1.png)
可以看到确实是每次都递减10，但是如果是多线程的情况下会是如何呢？（[代码PriceController](https://github.com/edgeowner/saber)）
```java
 @Slf4j
@RestController
@RequestMapping("/price")
public class PriceController {

    @Autowired
    private PriceApplication priceApplication;

    @Autowired
    private PriceMapper priceMapper;
    @Autowired
    private ThreadPoolConfig config;


    /**
     * 多线程并发执行Demo ,无锁场景下的更新
     *
     * @param priceVO
     * @return message
     */
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public ResponseEntity<Map<String, Object>> updatePrice(@RequestBody PriceVO priceVO) {

        try {
            if (priceVO == null) {
                throw new BizException(BizException.NUM_VALIDATION, "priceVO is null");
            }

            for (int i = 0; i < 10; i++) {
                final int count = i;
                Thread thread = new Thread(new Runnable() {
                    @Override
                    public void run() {
                        toUpdatePrice(count);
                    }
                });
                config.submit(thread);
            }
            return WebUtil.success("price更新成功");
        } catch (BizException ex) {
            log.error("更新价格失败", ExceptionUtils.getFullStackTrace(ex));
            return WebUtil.error(ex.getErrorMessage());
        }

    }


    private void toUpdatePrice(int count) {
        log.info(MessageFormat.format("thread create start:{0} ", count));
        Price price = priceMapper.selectByPrimaryKey(1);
        int ron = 10;
        price.setFront(price.getFront().subtract(new BigDecimal(ron)));
        price.setEnd(price.getEnd().add(new BigDecimal(ron)));
        priceMapper.updateByPrimaryKey(price);
        price.setId(null);
        priceMapper.insertSelective(price);
        log.info(MessageFormat.format("thread create end:{0} ", count));
    }
}
```
关于线程池的使用今后会仔细探讨。这里就简单理解为有10个线程并发去处理上面单线程的逻辑，来看看结果怎么样？
![图（2）](http://p5vswdxl9.bkt.clouddn.com/result2.png)

会看到明显的数据错误，导致错误的原因自然就是有线程读取到了中间状态进行了错误的更新。
进而有了以下两种解决方案：***悲观锁 ***和***乐观锁 ***。

-------

### 悲观锁
&emsp;&emsp;简单理解下悲观锁：当一个事务锁定了一些数据之后，只有当当前锁提交了事务，释放了锁，其他事务才能获得锁并执行操作。
使用方式如下：
首先要关闭MySQL的自动提交：set autocommit = 0;
```sql
bigen --开启事务
select id, total, front, end from price where id=1 for update 

insert into price values(?,?,?,?,?)

commit --提交事务
```
这里使用**select for update**的方式利用数据库开启了悲观锁，锁定了id=1的这条数据(注意：**这里除非是使用了索引会启用行级锁，不然是会使用表锁，将整张表都锁住。**)。之后使用commit提交事务并释放锁，这样下一个线程过来拿到的就是正确的数据。
悲观锁一般是用于并发不是很高，并且不允许脏读等情况。但是对数据库资源消耗较大。

-------

### 乐观锁
&emsp;&emsp;乐观锁是首先假设数据冲突很少，只有在数据提交修改的时候才进行校验，如果冲突了则不会进行更新。
通常的实现方式增加一个version字段，为每一条数据加上版本。每次更新的时候version+1，并且更新时候带上版本号。实现方式如下：
新建了一张price_version表：
```sql
CREATE TABLE `price_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `total` decimal(12,2) DEFAULT '0.00' COMMENT '总值',
  `front` decimal(12,2) DEFAULT '0.00' COMMENT '消费前',
  `end` decimal(12,2) DEFAULT '0.00' COMMENT '消费后',
  `version` int(11) DEFAULT '0' COMMENT '并发版本控制',
  `add_time` timestamp NULL DEFAULT NULL  COMMENT '添加时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP  COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
```
``更新数据的SQL``：
```xml
<update id="updateByVersion" parameterType="com.demo.saber.infrastructure.po.PriceVersion">
        update price_version
        set front = #{front, jdbcType=DECIMAL},
            version = version + 1
        where id = #{id, jdbcType=INTEGER}
        and version = #{version, jdbcType=INTEGER}
    </update>
```
``调用方式``：
```java
@Slf4j
@RestController
@RequestMapping("/priceverion")
public class PriceVersionController {


    @Autowired
    private PriceVersionMapper priceVersionMapper;


    @Autowired
    private ThreadPoolConfig config;

    /**
     * 多线程并发执行Demo ,乐观锁场景下的更新
     *
     * @param priceVersionVO
     * @return message
     */
    @RequestMapping(value = "/threadPriceVersion", method = RequestMethod.POST)
    public ResponseEntity<Map<String, Object>> updatePrice(@RequestBody PriceVersionVO priceVersionVO) {

        try {
            if (priceVersionVO == null) {
                throw new BizException(BizException.NUM_VALIDATION, "priceVersionVO is null");
            }

            for (int i = 0; i < 10; i++) {
                final int count = i;
                Thread thread = new Thread(new Runnable() {
                    @Override
                    public void run() {
                        PriceVersion priceVersion = priceVersionMapper.selectByPrimaryKey(1);
                        int ron = 10;
                        //"本次消费=" + ron
                        log.info(MessageFormat.format("当前线程({0})本次消费={1}", count, ron));
                        priceVersion.setFront(new BigDecimal(ron));
                        int backflag = priceVersionMapper.updateByVersion(priceVersion);
                        if (backflag == 0) {
                            log.error(MessageFormat.format("当前线程({0})更新失败", count));
                        } else {
                            log.error(MessageFormat.format("当前线程({0})更新成功", count));
                        }

                    }
                });
                config.submit(thread);
            }
            return WebUtil.success("priceVersion更新成功");
        } catch (BizException ex) {
            log.error("更新priceVersion失败", ExceptionUtils.getFullStackTrace(ex));
            return WebUtil.error(ex.getErrorMessage());
        }

    }
}
```
**处理逻辑 **：开了三个线程生成了20以内的随机数更新到front字段。调用该接口时日志如下：
![更新日志](http://p5vswdxl9.bkt.clouddn.com/result3.jpg)
可以看到线程1、2、3、4都更新失败了，线程0更新成功了。

乐观锁在实际应用相对较多，它可以提供更好的并发访问，并且数据库开销较少，但是有可能存在脏读的情况。

-------

### 代码地址
[edgeowner](https://github.com/edgeowner/saber)

### 参考资源
[SSM (十五) 乐观锁与悲观锁的实际应用](https://juejin.im/post/5962e64c6fb9a06ba14b9cd9)





