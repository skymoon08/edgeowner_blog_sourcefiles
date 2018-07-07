---
title: JVM内存结构(4)
tags: [JVM]
copyright: true
date: 2016-04-27 17:00:00
updated: 2016-04-27 19:29:00
categories: JVM
mathjax: true 
---

### JVM内存结构
&emsp;&emsp;JVM内存结构主要有三大块：***堆内存*** 、***方法法区*** 和 ***栈***。
&emsp;&emsp;***堆内存*** 是JVM中最大的一块由 **年轻代**和 **老年代** 组成，而年轻代内存又被分为三部分， **Eden空间** 、**From Survivo空间** 、**To Survivor空间** ，默认情况下年轻代按照$8:1:1$的比例来分配；<font color=#FF3030>方法区存储类信息、常量、静态变量等数据，是线程共享的区域</font> ，为与**Java堆**区分，方法区还有一个别名NonHeap(非堆)；栈又分为 **Java虚拟机栈** 和 **本地方法栈** 主要用于方法的执行。     
&emsp;&emsp;<font color=#FF0000>JAVA的JVM的内存可分为3个区</font>： **堆(Heap)**、 **栈(Stack)**  、 **方法区(Method Area)** 。实际IDEA开发Tomcat启动项配置示例：  
> <font face="微软雅黑" color=#9900ff size=2>-Xms1024m -Xmx1024m  -XX:PermSize=512M -XX:MaxPermSize=1024m  -Dfile.encoding=utf-8 </font>   



<!--more-->

-------

### Java堆(Java Heap)
#### 参数设置
Java堆可通过参数 <font color=#EE7942>-Xms</font> 和  <font color=#EE7942>-Xmx</font>设置；

#### 存储内容
Java堆是存放对象的实例，几乎所有的<font color=#EE6A50>对象实例</font>和<font color=#EE6A50>数组</font>都存储于此区域，是被所有线程共享，是JVM虚拟机管理的内存中最大的一块，在虚拟机启动时创建；

#### 内存分配
为了便于更好的回收和分配内存，堆可细分为：**新生代**和**老年代**，**新生代** 在细致一些就是<font color=#EE3B3B>Eden空间、From Survivor空间、To Survivor区</font>。

 1. 新生代：包括Eden区、From Survivor区、To Survivor区，系统默认大小 $Eden:Survivor= 8:1$
 2. 老年代：在年轻代中经历了N次垃圾回收后仍然存活的对象，就会被放到老年代中。因此可认为老年代中存放的都是一些生命周期较长的对象

Survivor空间等Java堆可以处理在物理内存不连续的空间，只要逻辑上是连续即可。

-------

### Java虚拟机栈(Stack)
#### 参数设置
可通过参数 栈帧是方法运行期的基础数据结构栈容量可由-Xss设置；
#### 存储内容
Java虚拟机栈是线程私有的，它的生命周期与线程相同

1. 每个方法被调用直至执行完成的过程，就对应一个栈帧在虚拟机栈中从入栈到出栈的过程
2. 虚拟机栈是执行Java方法的内存模型(也就是字节码)服务：**每个方法在执行的同时都会创建一个栈帧，用于存储局部变量表、操作数栈、动态链接、方法出口等信息。
    1. <font color=#FF0000>局部变量表</font>：32位变量槽，存放了编译期可知的 **各种基本数据类型**、**对象引用**、**returnAddress类型**
    2. <font color=#FF0000>操作数栈</font>：基于栈的执行引擎，虚拟机把操作数栈作为它的工作区，大多数指令都要从这里弹出数据、执行运算，然后把结果压回操作数栈。
    3. <font color=#FF0000>动态链接</font>：**每个栈帧都包含一个指向运行时常量池(方法区的一部分)中该栈帧所属方法的引用**。持有这个引用是为了支持方法调用过程中的动态连接。Class文件的常量池中有大量的符号引用，字节码中的方法调用指令就以常量池中指向方法的符号引用为参数。这些符号引用一部分会在类加载阶段或第一次使用的时候转化为直接引用，这种转化称为**静态解析**。另一部分将在每次的运行期间转化为直接应用，这部分称为**动态链接**
    4. <font color=#FF0000>方法出口</font>：返回方法被调用的位置，恢复上层方法的局部变量和操作数栈，如果无返回值，则把它压入调用者的操作数栈。
    
3. **局部变量表所需的内存空间在编译期间完成分配**，当进入一个方法时，这个方法需要在帧中分配多大的局部变量空间是完全确定的。
4. **在方法运行期间不会改变局部变量表的大小。主要存放了编译之后可知的各种基本数据类型、对象引用。**<font color=#33ccff>（[reference类型、returnAddress类型](http://www.runoob.com/java/java-basic-datatypes.html)）</font>

-------

###  本地方法栈(Local Method Stack)
#### 参数设置
可通过参数 栈容量可由-Xss设置。
#### 存储内容
1. 虚拟机栈为虚拟机执行Java方法（也就是字节码）服务。
2. 本地方法栈则是为虚拟机使用到的Native方法服务。有的虚拟机（譬如Sun HotSpot虚拟机）直接就把本地方法栈和虚拟机栈合二为一。

-------

### 方法区(Method Area)
#### 参数设置
可通过参数-XX:MaxPermSize设置
#### 存储内容
1. **线程共享内存区域，用于储存已被虚拟机加载的类信息、常量、静态变量，即编译器编译后的代码，方法区也称持久代（Permanent Generation）**。
2. 虽然Java虚拟机规范把方法区描述为堆的一个逻辑部分，但是它却有一个别名叫做<font color=#DC143C>Non-Heap（非堆）</font>，目的应该是与Java堆区分开来。
3. 如何实现方法区，属于虚拟机的实现细节，不受虚拟机规范的约束。
4. 方法区主要存放java类定义信息，与垃圾回收关系不大，方法区可以选择不实现垃圾回收，<font color=#EE2C2C	>但不是没有垃圾回收</font>。
5. **方法区域的内存回收目标主要针对常量池的回收和对类型的卸载。**
6. **<font color=#EE2C2C>运行时常量池</font>，也是方法区的一部分，虚拟机加载Class后把常量池中的数据放入运行时常量池**。

-------

### 运行时常量池(Runtime Constant Pool)
#### 参数设置
可通过参数-XX:PermSize和-XX:MaxPermSize设置
#### 存储内容
1. <font color=#EE4000>常量池(Constant Pool)</font>：**常量池数据编辑之后被确定，是Class文件中的一部分。存储了类、方法、接口等中的常量，也包括字符串常量。**
2. <font color=#EE4000>字符串池/字符串常量池(String  Pool/ String Constant Pool)</font>：是常量池中的一部分，存储编译期类中产生的<font color=#EE0000>字符串类型数据。</font>
3. <font color=#EE4000>运行时常量池(Runtime Constant Pool)</font>：**方法区的一部分，所有线程共享。虚拟机加载Class后把常量池中的数据放入到运行时常量池**。<font color=#EE3B3B>常量池</font>：可以理解为Class文件中的资源仓库，它是Class文件结构中与其他项目资源关联最多的数据类型。
    1. 常量池中主要存放两大类常量：<font color=#EE4000>字面量</font>(Literal)和<font color=#EE4000>符号引用</font>(Symbolic Reference)。
    2. **字面量**：文本字符串、声明为final的常量值等。
    3. **符号引用**：<font color=#EE4000>类和接口的完全限定名</font>(Fully Qualified Name)、<font color=#EE4000>字段的名称</font>和<font color=#EE4000>描述符</font>(Descriptor)、<font color=#EE4000>方法的名称</font>和<font color=#EE4000>描述符号</font>
    
    
-------

### 直接内存(Direct Memory)
#### 参数设置
可通过-XX:MaxDirectMemorySize指定，如果不指定，则默认与Java堆的最大值（-Xmx指定）一样。
#### 存储内容
**直接内存（Direct Memory）并不是虚拟机运行时数据区的一部分，也不是Java虚拟机规范中定义的内存区域，但是这部分内存也被频繁地使用，而且也可能导致OutOfMemoryError异常出现。**


### 参考资料
* [50个多线程面试题](https://juejin.im/post/5aae4e8f6fb9a028e52d9e8c)


