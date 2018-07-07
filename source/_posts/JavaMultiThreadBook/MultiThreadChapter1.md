---
title: Chapter(1-1)
tags: [多线程]
copyright: true
date: 2016-05-01 12:20:43
updated: 2016-05-01 20:19:21
categories: Java Multi-thread Programming书籍
mathjax: true 
---

### Thread类中start()方法和run()方法的区别
1. Thread.java类中的start()方法通知“线程规划器”，此线程已经准备就绪，等待调用线程对象的run()方法。这个过程其实就是让系统安排一个时间来调用Thread中的run()方法，也就是使线程得到运行，启动线程，具有异步执行的效果。
2. 如果代码调用thread.run()方法就不是异步执行，而是同步，那么此线程对象并不交给“线程规划器”来进行处理，而是由main()主线程来调用run()方法，也就是必须等run()方法中的代码执行完后才可以执行后面的代码。
3. ([<font color=#ff6600>代码Demo地址</font>](https://github.com/edgeowner/JavaMulti-threadProgramming))：参见com.multithread.demo.chapter1.ThreaStartAndRun目录下代码。
<!--more-->
4. 运行结果：
    1. ***start()方法 ***：![start()方法](http://p5vswdxl9.bkt.clouddn.com/Thread-start.png)
    2. ***run()方法 ***：![run()方法](http://p5vswdxl9.bkt.clouddn.com/Thread-run.png)



-------


### 实例变量与线程安全
1. 自定义线程类中的实例变量针对其他线程可以有共享和不共享之分，这在多个线程之间进行交互时是很重要的一个技术点。
2. ([<font color=#ff6600>代码Demo地址</font>](https://github.com/edgeowner/JavaMulti-threadProgramming))：参见com.multithread.demo.chapter1.ThreadShareDemo目录下代码

#### 不共享数据
   ![不共享数据](http://p5vswdxl9.bkt.clouddn.com/ThreadNotShare.png)

1. **代码示例**：  
 
   ```java
   package com.multithread.demo.chapter1.ThreadShareDemo;

/**
 * @author zhangsunny
 * @desc 测试线程不共享Demo
 */
public class TestThread {

    public static void main(String[] args) {
        MyThread myThreadA = new MyThread("A");
        MyThread myThreadB = new MyThread("B");
        MyThread myThreadC = new MyThread("C");
        myThreadA.start();
        myThreadB.start();
        myThreadC.start();
    }
}
   ```

2. **运行结果**：
![NotShareResult.png](http://p5vswdxl9.bkt.clouddn.com/NotShareResult.png)
3. **代码解析**：以上步骤创建了三个线程，每个线程都有各自的count变量，自己减少自己的count变量的值。并不存在多个线程访问同一个实例变量的情况。

-------

#### 共享数据
  ![共享数据](http://p5vswdxl9.bkt.clouddn.com/ThreadShare.png)

1. **代码示例**
 
   ```java
package com.multithread.demo.chapter1.ThreadShareDemo;

/**
 * @author  zhangsunny
 * @desc    测试线程共享Demo（线程不安全）
 */
public class TestThread2 {

    public static void main(String[] args) {
        MyThread2 myThread2 = new MyThread2();
        Thread a = new Thread(myThread2, "A");
        Thread b = new Thread(myThread2, "B");
        Thread c = new Thread(myThread2, "C");
        Thread d = new Thread(myThread2, "D");
        Thread e = new Thread(myThread2, "E");
        a.start();
        b.start();
        c.start();
        d.start();
        e.start();
    }
}
```
   
2. **运行结果**： 
![shareResult](http://p5vswdxl9.bkt.clouddn.com/shareResult.png)
3. **代码解析**：以上步骤共享数据的情况就是多个线程可以访问同一个变量，实现了$5$个线程共同对一个count变量进行减法操作的目的。A和B的count值都为 $8$，说明A和B同时对count进行处理，产生“非线程安全”问题，JVM中 $i- -$ 操作分为三步：
    1. 取得原有 $i$ 值；
    2. 计算 $i-1$；
    3. 对 $i$ 进行赋值操作；
4. **如何避免**：对多个线程之间进行同步，也就是用按顺序排队的方式进行减 $1$ 操作。以下为同步方式实现。具体同步介绍参见[Chapter(1-2)](http://edgeowner.com/2016/05/01/JavaMultiThreadBook/MultiThreadChapter2/)
        
    ```java
package com.multithread.demo.chapter1.ThreadShareDemo;

/**
 * @author zhangsunny
 * @desc 线程共享操作 (线程同步)
 */
public class MyThread2_1 extends Thread {


    private int count = 10;

    @Override
    synchronized public void run() {
        super.run();
        count--;
        System.out.println("线程" + this.currentThread().getName() + "计算，count = " + count);
    }
}

```

5. **运行结果**：![线程同步](http://p5vswdxl9.bkt.clouddn.com/%E7%BA%BF%E7%A8%8B%E5%90%8C%E6%AD%A5.png)




