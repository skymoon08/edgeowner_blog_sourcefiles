---
title: JVM内存结构(3)
tags: [JVM]
categories: JVM
copyright: true
date:  2016-04-26 18:00:00
updated: 2016-04-27 12:29:00
---

#### JVM具体参数和内存区域映射图例
 &emsp;&emsp;此文主要用图例方式描绘了JVM的结构，介绍了JVM内存结构对应的参数名。
* 在具体实现上，JVM将需要进行垃圾回收的区域分为3类：新生代（Young Generation）、老年代(Old Generation)、永久代(Permanent Generation)。其中新生代又分为eden和survival（S0、S1），具体结构如下图所示：
* ![图示1.0](http://p5vswdxl9.bkt.clouddn.com/jvm_and_params_map.png)
<!-- more -->
* 简单讲，新生代的eden、新生代的survival、老生代里的对象存活时间依次变长。

| **参数名称** | **含义**|
| :--------|---------|
| -Xmx| 初始堆大小 |
| -Xms| 最大堆大小 |
| -Xss| 每个线程的堆栈大小 |
| -XX:NewSize | 设置年轻代大小(for 1.3/1.4) |
| -XX:MaxNewSize| 年轻代最大值(for 1.3/1.4) |
| -XX:PermSize | 设置持久代(perm gen)初始值 |
| -XX:MaxPermSize | 设置持久代最大值 |
| -XX:NewRatio |  年轻代(包括Eden和两个Survivor区)与年老代的比值(除去持久代) |
| -XX:SurvivorRatio| Eden区与Survivor区的大小比值 |


--------------

####  JVM内存结构图例
![](http://p5vswdxl9.bkt.clouddn.com/JVM_Flow.jpg)
   &emsp;&emsp;方法区和堆是所有**线程共享的内存区域**；而java栈、本地方法栈和程序计数器是运行是**线程私有的内存区域**。

* Java堆（Heap）,是Java虚拟机所管理的内存中最大的一块。Java堆是被所有线程共享的一块内存区域，在虚拟机启动时创建。此内存区域的唯一目的就是存放对象实例，几乎所有的对象实例都在这里分配内存。

* 方法区（Method Area）,方法区（Method Area）与Java堆一样，是各个线程共享的内存区域，它用于存储已被虚拟机加载的类信息、常量、静态变量、即时编译器编译后的代码等数据。

* 程序计数器（Program Counter Register）,程序计数器（Program Counter Register）是一块较小的内存空间，它的作用可以看做是当前线程所执行的字节码的行号指示器。

* JVM栈（JVM Stacks）,与程序计数器一样，Java虚拟机栈（Java Virtual Machine Stacks）也是线程私有的，它的生命周期与线程相同。虚拟机栈描述的是Java方法执行的内存模型：每个方法被执行的时候都会同时创建一个栈帧（Stack Frame）用于存储局部变量表、操作栈、动态链接、方法出口等信息。每一个方法被调用直至执行完成的过程，就对应着一个栈帧在虚拟机栈中从入栈到出栈的过程。

* 本地方法栈（Native Method Stacks）,本地方法栈（Native Method Stacks）与虚拟机栈所发挥的作用是非常相似的，其区别不过是虚拟机栈为虚拟机执行Java方法（也就是字节码）服务，而本地方法栈则是为虚拟机使用到的Native方法服务。

* ClassLoader是负责加载class文件，class文件在文件开头有特定的文件标示，并且ClassLoader只负责class文件的加载，至于它是否可以运行，则由Execution Engine决定。

* Native Interface是负责调用本地接口的。他的作用是调用不同语言的接口给JAVA用，他会在Native Method Stack中记录对应的本地方法，然后调用该方法时就通过Execution Engine加载对应的本地lib。原本多于用一些专业领域，如JAVA驱动，地图制作引擎等，现在关于这种本地方法接口的调用已经被类似于Socket通信，WebService等方式取代。

* Execution Engine是执行引擎，也叫Interpreter。Class文件被加载后，会把指令和数据信息放入内存中，Execution Engine则负责把这些命令解释给操作系统。

* Runtime Data Area则是存放数据的，分为五部分：Stack，Heap，Method Area，PC Register，Native Method Stack。几乎所有的关于java内存方面的问题，都是集中在这块。下图是javapapers.com上关于Run-time Data Areas的描述：![](http://p5vswdxl9.bkt.clouddn.com/JVM_2.jpg)

--------------

#### 相关技术参考
1. [JVM原理分析](https://www.jianshu.com/p/be6f529160b6)
2. [JVM知识点总览](https://mp.weixin.qq.com/s/ebg0bT_xBahGV7OAKorBAw)
3. [JVM系列之GC](https://juejin.im/post/5a1cc3596fb9a04506715aad)
4. [重读 JVM](https://juejin.im/post/59ad4cd56fb9a02477075780#heading-5)
5. [JVM 的内存模型](https://mijack.github.io/2018/03/18/Garbage-Collection/)




