---
title: 线程池介绍
tags: [多线程, 线程池]
copyright: true
date: 2016-04-21 20:15:31
updated: 2016-04-21 21:17:23
categories: Java多线程
mathjax: true 
---

-------
#### 前言
&emsp;&emsp;很多人可能已经很熟悉操作系统中的多任务：就是同一时刻运行多个程序的能力。
&emsp;&emsp;多线程程序在较低层次上扩展了多任务的概念：一个程序同时执行多个任务。通常每一个任务称为一个线程，它是线程控制的简称。可以同时运行一个以上线程的程序成为多线程程序。
&emsp;&emsp;<font color=#EE4000>线程和进程的区别</font>：
1. 多个进程的内部数据和状态都是完全独立的，而多线程是共享一块内存空间和一组系统资源，有可能互相影响。　　
2. 线程本身的数据通常只有寄存器数据，以及一个程序执行时使用的堆栈，所以线程的切换负担比进程切换的负担要小。多线程程序比多进程程序需要更少的管理费用。　　
3. 进程是重量级的任务，需要分配给它们独立的地址空间，进程间通信是昂贵和受限的，进程间的转换也是很需要花费的。而线程是轻量级的选手，它们共享相同的地址空间并且共同分享同一个进程，线程间的通信是便宜的，线程间的转换也是低成本的。
    
-------

<!--more-->

#### 多线程技术背景
&emsp;&emsp;面向对象编程，创建和销毁对象是很浪费时间，因为创建一个对象要获取内存资源或者其它更多资源。在Java中亦是如此，虚拟机将试图跟踪每一个对象，以便能够在对象销毁后进行垃圾回收。
&emsp;&emsp;为了提高服务程序的效率，尽可能减少创建和销毁对象的次数，特别是一些很耗资源的对象创建和销毁。如何利用已有对象来服务就是一个需要解决的关键问题，其实这就是一些”池化资源”技术产生的原因。
&emsp;&emsp;线程池为我们做的，就是线程创建之后为我们保留，当我们需要的时候直接拿来用，省去了重复创建销毁的过程。
![线程](http://p5vswdxl9.bkt.clouddn.com/threadPool)

-------

#### 线程池的优点
* 重用线程中的线程，减少因对象创建、销毁所带来的性能开销；
* 能有效的控制线程的最大并发数，提高系统资源利用率，同时避免过多的资源竞争，避免堵塞；
* 能够多线程进行简单的管理，使线程的使用简单、高效；

-------

#### 线程池的处理逻辑
##### 线程池ThreadPoolExecutor构造函数
```java
//五个参数的构造函数
 public ThreadPoolExecutor(int corePoolSize,
                              int maximumPoolSize,
                              long keepAliveTime,
                              TimeUnit unit,
                              BlockingQueue<Runnable> workQueue) {
        this(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue,
             Executors.defaultThreadFactory(), defaultHandler);
    }

//六个参数的构造函数（1）
  public ThreadPoolExecutor(int corePoolSize,
                              int maximumPoolSize,
                              long keepAliveTime,
                              TimeUnit unit,
                              BlockingQueue<Runnable> workQueue,
                              ThreadFactory threadFactory) {
        this(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue,
             threadFactory, defaultHandler);
    }
    
    
//六个参数的构造函数（2） 
 public ThreadPoolExecutor(int corePoolSize,
                              int maximumPoolSize,
                              long keepAliveTime,
                              TimeUnit unit,
                              BlockingQueue<Runnable> workQueue,
                              RejectedExecutionHandler handler) {
        this(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue,
             Executors.defaultThreadFactory(), handler);
    }
    
//七个参数的构造函数 
public ThreadPoolExecutor(int corePoolSize,
                              int maximumPoolSize,
                              long keepAliveTime,
                              TimeUnit unit,
                              BlockingQueue<Runnable> workQueue,
                              ThreadFactory threadFactory,
                              RejectedExecutionHandler handler) {
        if (corePoolSize < 0 ||
            maximumPoolSize <= 0 ||
            maximumPoolSize < corePoolSize ||
            keepAliveTime < 0)
            throw new IllegalArgumentException();
        if (workQueue == null || threadFactory == null || handler == null)
            throw new NullPointerException();
        this.corePoolSize = corePoolSize;
        this.maximumPoolSize = maximumPoolSize;
        this.workQueue = workQueue;
        this.keepAliveTime = unit.toNanos(keepAliveTime);
        this.threadFactory = threadFactory;
        this.handler = handler;
    }
```

##### 构造函数参数介绍
1. **corePoolSize（核心线程， 该线程池中核心线程数最大值**：在创建完线程池之后，核心线程先不创建，在接到任务之后创建核心线程。并且会意一直存在于线程池中(即使这个线程什么多不做)，有任务要执行时，如果核心线程没有被占用，会优先用核心线程执行任务。数量一般情况下设置为CPU核数的二倍即可。
2. **maximumPoolSize （该线程池中线程总数最大值）**：线程总数 $=$ 核心线程数 $+$ 非核心线程数。（非核心线程：简单理解，即核心线程都被占用，但还有任务要做，就创建非核心线程）
3. **keepAliveTime（非核心线程闲置超时时长）**：这个参数可以理解为，任务少，但池中线程多，非核心线程不能白养着，超过这个时间不工作的就会被干掉，但是核心线程会保留。
4. **TimeUnit（keepAliveTime的单位）**：  
    TimeUnit是一个枚举类型，其包括:
    NANOSECONDS ： 1微毫秒 = 1微秒 / 1000
    MICROSECONDS ： 1微秒 = 1毫秒 / 1000
    MILLISECONDS ： 1毫秒 = 1秒 /1000
    SECONDS ： 秒
    MINUTES ： 分
    HOURS ： 小时
    DAYS ： 天
5. **BlockingQueue workQueue（线程池中的任务队列）**：默认情况下，任务进来之后先分配给核心线程执行，核心线程如果都被占用，并不会立刻开启非核心线程执行任务，而是将任务插入任务队列等待执行，核心线程会从任务队列取任务来执行，任务队列可以设置最大值，一旦插入的任务足够多，达到最大值，才会创建非核心线程执行任务。常见的workQueue有四种：
    *  **SynchronousQueue**：这个队列接收到任务的时候，会直接提交给线程处理，而不保留它，如果所有线程都在工作怎么办？那就新建一个线程来处理这个任务！所以为了保证不出现<线程数达到了maximumPoolSize而不能新建线程>的错误，使用这个类型队列的时候，maximumPoolSize一般指定成Integer.MAX_VALUE，即无限大；
    *  **LinkedBlockingQueue**：这个队列接收到任务的时候，如果当前已经创建的核心线程数小于线程池的核心线程数上限，则新建线程(核心线程)处理任务；如果当前已经创建的核心线程数等于核心线程数上限，则进入队列等待。由于这个队列没有最大值限制，即所有超过核心线程数的任务都将被添加到队列中，这也就导致了maximumPoolSize的设定失效，因为总线程数永远不会超过corePoolSize；
    *  **ArrayBlockingQueue**：可以限定队列的长度，接收到任务的时候，如果没有达到corePoolSize的值，则新建线程(核心线程)执行任务，如果达到了，则入队等候，如果队列已满，则新建线程(非核心线程)执行任务，又如果总线程数到了maximumPoolSize，并且队列也满了，则发生错误，或是执行实现定义好的饱和策略
    *  **DelayQueue**：队列内元素必须实现Delayed接口，这就意味着你传进去的任务必须先实现Delayed接口。这个队列接收到任务时，首先先入队，只有达到了指定的延时时间，才会执行任务；
    
6. **ThreadFactory threadFactory （创建线程的工厂）**：可以用线程工厂给每个创建出来的线程设置名字。一般情况下无须设置该参数。
7. **RejectedExecutionHandler handler（饱和策略）**：这是当任务队列和线程池都满了时所采取的应对策略，默认是***AbordPolicy ***， 表示无法处理新任务，并抛出 RejectedExecutionException 异常。此外还有3种策略，它们分别如下：
      *  **CallerRunsPolicy**：用调用者所在的线程来处理任务。此策略提供简单的反馈控制机制，能够减缓新任务的提交速度。     
      *  **DiscardPolicy**：不能执行的任务，并将该任务删除。
      *  **DiscardOldestPolicy**：丢弃队列最近的任务，并执行当前的任务。
      *  接下来上图，相信结合图你能大彻大悟~![](http://p5vswdxl9.bkt.clouddn.com/thpool)
    
-------

#### 线程池使用
java为我们提供了4种线程池FixedThreadPool、CachedThreadPool、SingleThreadExecutor、ScheduledThreadPool，几乎可以满足我们大部分的需要。

* ***FixedThreadPool ***可重用固定线程数的线程池，超出的线程会在队列中等待，在Executors类中我们可以找到创建方式：

   ```java
public static ExecutorService newFixedThreadPool(int nThreads) {
        return new ThreadPoolExecutor(nThreads, nThreads,
                                      0L, TimeUnit.MILLISECONDS,
                                      new LinkedBlockingQueue<Runnable>());
}
    ```

*  ***CachedThreadPool ***是一个根据需要创建线程的线程池。

   ```java
public static ExecutorService newCachedThreadPool() {
        return new ThreadPoolExecutor(0, Integer.MAX_VALUE,
                                      60L, TimeUnit.SECONDS,
                                      new SynchronousQueue<Runnable>());
 }
   ```
   
*   ***SingleThreadExecutor ***是使用单个线程工作的线程池。其创建源码如下：

   ```java
public static ExecutorService newSingleThreadExecutor() {
    return new FinalizableDelegatedExecutorService
        (new ThreadPoolExecutor(1, 1,
                                0L, TimeUnit.MILLISECONDS,
                                new LinkedBlockingQueue<Runnable>()));
}
   ```

* *** ScheduledThreadPool ***是一个能实现定时和周期性任务的线程池，它的创建源码如下：
  
   ```java
public static ScheduledExecutorService newScheduledThreadPool(int corePoolSize) {
        return new ScheduledThreadPoolExecutor(corePoolSize);
}


public ScheduledThreadPoolExecutor(int corePoolSize) {
        super(corePoolSize, Integer.MAX_VALUE,
              DEFAULT_KEEPALIVE_MILLIS, MILLISECONDS,
              new DelayedWorkQueue());
}
    ```

-------

#### 合理配置线程池的大小
&emsp;&emsp;一般需要根据任务的类型来配置线程池大小：
* 如果是CPU密集型任务（***线程CPU时间所占比例越高，需要越少线程，即CPU密集型任务。 *** ），就需要尽量压榨CPU，参考值可以设为 NCPU+1；
* 如果是IO密集型任务（***线程等待时间所占比例越高，需要越多线程，即IO密集型任务 *** ），参考值可以设置为2*NCPU；
* 具体的设置还需要根据实际情况进行调整，比如可以先将线程池大小设置为参考值，再观察任务运行情况和系统负载、资源利用率来进行适当调整；
* 最佳线程数目 = ((线程等待时间+线程CPU时间)/线程CPU时间)$*$CPU数目；
* 比如平均每个线程CPU运行时间为0.5s，而线程等待时间（非CPU运行时间，比如IO）为1.5s，CPU核心数为8，那么根据上面这个公式估算得到：((0.5+1.5)/0.5)$*$8=32；
* TODO


[参考链接]()


