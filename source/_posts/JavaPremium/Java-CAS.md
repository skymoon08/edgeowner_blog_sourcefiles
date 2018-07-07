---
title: Java CAS
tags:  [并发控制, 锁]
date: 2016-10-02 08:40:20
updated: 2016-10-01 18:19:21
categories: 并发控制相关知识点
copyright: true
mathjax: true
---

### CAS介绍
&emps;&emps;***CAS ***是现代操作系统，解决并发问题的一个重要手段，本文从**eureka**源码入手，介绍Java中的***CAS ***。
&emps;&emps;<font color=#>CAS</font>(**Compare And Swap**)，字面理解就是“比较并交换”，一个**CAS**涉及到的操作如下：
假设内存中的原数据$V$，旧的预期值$A$，需要修改的新值$B$
1. 比较$A$与$V$是否相等。（比较）
2. 如果比较相等，将$B$写入$V$。（交换）
3. 返回操作是否成功。
&emps;&emps;当多个线程同时对某个资源进行CAS操作，只能有一个线程操作成功，但是并不会阻塞其他线程，其他线程只会收到操作失败的信号。其实CAS就是一个乐观锁。

### CAS实现
#### 解析AtomInteger


