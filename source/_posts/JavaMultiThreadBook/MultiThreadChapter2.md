---
title: Chapter(1-2)
tags: [多线程]
copyright: true
date: 2016-05-01 13:20:43
updated: 2016-05-01 20:19:21
categories: Java Multi-thread Programming书籍
mathjax: true 
---


### 多线程同步
&emsp;&emsp;本文是对[Chapter(1-1)](http://edgeowner.com/2016/05/01/JavaMultiThreadBook/MultiThreadChapter1/)中结尾中``线程同步``的方法继续做介绍。
&emsp;&emsp;先来回顾下Chapter(1-1)文章结尾代码片段：
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

<!--more-->
&emsp;&emsp;以上代码通过在方法前加入synchronized关键字，使多个线程在执行**run()**时，以排队的方式进行处理。当一个线程调用**run()**前，先判断**run()**方法有没有被上锁，如果上锁，说明有其他线程正在调用**run()**方法，必须等其他线程对**run()**方法调用结束后才可以执行**run()**方法。这样就实现了排队调用**run()**方法，达到了按顺序对**count**变量减$1$的效果。<font color=#FF6A6A>synchronized</font>可以在任意对象及方法上加锁，<font color=#0000EE>这段加锁的代码</font>被称为“<font color=#FF6A6A>互斥区</font>”或“<font color=#FF6A6A>临界区</font>”。
&emsp;&emsp;一个线程要执行同步方法里的代码时，线程首先去获取这把锁，也就会有两种结果：
    1. ``获取锁成功``：那么这个线程可以执行sychronize里的代码。
    2. ``获取锁失败``：那么着个线程就会不断地尝试获取这把锁，直到能够拿到为止，而且是有多个线程同时去争抢这把锁。

-------

### 非线程安全
&emsp;&emsp;非线程安全主要是指***多个线程 ***对<font color=#FF6A6A>同一个对象</font>中的<font color=#FF6A6A>同一个实例变量</font>进行操作时会出现值被更改，值不同步的情况，影响程序的执行流程。

-------

#### 非线程安全环境
代码Demo例子详见[Github代码](https://github.com/edgeowner/JavaMulti-threadProgramming)

1. ***ALogin类 ***

   ```java
package com.multithread.demo.chapter1.ThreadIsNotSafe;

/**
 * @author zhangsunny
 * @desc   非线程安全ALogin
 */
public class ALogin extends Thread {

    @Override
    public void run() {
        LoginServlet.doPost("a","aa");
    }


}
```

2. ***BLogin类 ***

   ```java  
package com.multithread.demo.chapter1.ThreadIsNotSafe;


/**
 * @author zhangsunny
 * @desc   非线程安全BLogin
 */
public class BLogin extends Thread {

    @Override
    public void run() {

        LoginServlet.doPost("b","bb");

    }
}
```

3. ***LoginServlet类 ***

   ```java
package com.multithread.demo.chapter1.ThreadIsNotSafe;

import java.text.MessageFormat;

/**
 * @author zhangsunny
 * @desc   非线程安全LoginServlet
 */
public class LoginServlet {

    private static String username;
    private static String password;

    public static void doPost(String usernameParam, String passwordParam) {
        try {
            username = usernameParam;
            if (usernameParam.equals("a")) {
                Thread.sleep(5000);
            }
            password = passwordParam;

            System.out.println(MessageFormat.format("username = {0} , password = {1}",username,password));

        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
   ```
   
4. ***RunTest ***

   ```java
package com.multithread.demo.chapter1.ThreadIsNotSafe;


/**
 * @author zhangsunny
 * @desc   非线程安全Demo测试
 */
public class RunTest {

    public static void main(String[] args) {
        ALogin aLogin = new ALogin();
        aLogin.start();
        BLogin bLogin = new BLogin();
        bLogin.start();
    }
}
```

5. **运行结果**
   ![](http://p5vswdxl9.bkt.clouddn.com/unsafeThread.jpg)
   <font color=#FF6A6A>以上结果出现非线程安全问题</font>

6. **解决方法**：使用<font color=#FF6A6A>synchronized</font>关键字。
   
   ```java
package com.multithread.demo.chapter1.ThreadIsNotSafe;

import java.text.MessageFormat;

/**
 * @author zhangsunny
 * @desc 非线程安全LoginServlet
 */
public class LoginServlet {

    private static String username;
    private static String password;

    synchronized public static void doPost(String usernameParam, String passwordParam) {
        try {
            username = usernameParam;
            if (usernameParam.equals("a")) {
                Thread.sleep(5000);
            }
            password = passwordParam;

            System.out.println(MessageFormat.format("username = {0} , password = {1}", username, password));

        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }


}
   ```
   
  7. **运行结果**
   ![](http://p5vswdxl9.bkt.clouddn.com/safeThread.jpg)

-------

### 线程方法总结(部分)
1. **currentThread()**方法可返回代码段正在被那个线程调用的信息。
2. **isAlive()**方法是判断当前线程是否处于活动状态(就是线程已经启动且尚未种植，线程处于<font color=#FF6A6A>正在运行</font>或<font color=#FF6A6A>准备开始运行</font>的状态)。
3. **sleep()**方法作用是在指定毫秒数内让当前“正在执行的线程”休眠。这个“正在执行的线程”是指<font color=#EE0000	>this</font>.currentThread()返回的线程。
4. **getId()**方法作用是取得线程的唯一标识。


