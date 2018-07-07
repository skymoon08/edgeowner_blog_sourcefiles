---
title: Nginx基本简介
tags: [Nginx]
copyright: true
date: 2016-05-01 13:20:43
updated: 2016-05-01 20:19:21
categories: 负载均衡
mathjax: true 
---

### 前言
&emps;&emps;Nginx作为web服务器软件，具有高性能、高并发和低内存占用特点。此外其也提供反向代理功能。
#### Nginx特点
1. 支持高并发连接
2. 内存消耗少
3. 配置文件简单
4. 成本低廉
5. 支持Rewrite重写规则
6. 内置健康检查功能
7. 节省宽带
8. 稳定性高

#### Nginx架构
![nginx架构](http://p5vswdxl9.bkt.clouddn.com/nginx%E6%9E%B6%E6%9E%84%E5%9B%BE.jpg)
1. master进程主要用来管理worker进程，包含：接收来自外界的信号，向各worker进程发送信号，监控worker进程的运行状态，当worker进程退出后(异常情况下)，会自动重新启动新的worker进程。
2. worker进程则是处理基本的网络事件。多个worker进程之间是对等的，他们同等竞争来自客户端的请求，各进程互相之间是独立的。一个请求，只可能在一个worker进程中处理，一个worker进程，不可能处理其它进程的请求。
3. 开发模型：epoll和kqueue。
4. 支持的事件机制：kqueue、epoll、rt signals、/dev/poll 、event ports、select以及poll。
5. 支持的kqueue特性包括EV_CLEAR、EV_DISABLE、NOTE_LOWAT、EV_EOF，可用数据的数量，错误代码。
6. 支持sendfile、sendfile64和sendfilev;文件AIO；DIRECTIO;支持Accept-filters和TCP_DEFER_ACCEP。
<!--more-->
#### Nginx请求分发
Nginx启动后，会有一个**master进程**和多个**worker进程**。**master进程**主要用来管理**worker进程**，包含：接收来自外界信号，像各**worker进程**发送**信号**，监控**worker进程**的运行状态，当**worker进程**退出后（异常情况下），会自动重新启动新的**worker进程**。而基本的网络事件，则是放在**worker进程**中来处理了。多个**worker进程**之间是对等的，他们同等竞争来自客户端的请求，各进程互相之间是独立的。一个请求，只可能在一个**worker进程**中处理，一个**worker进程**，不可能处理其它进程的请求。**worker进程**的个数是可以设置的，一般我们会设置与机器**CPU核数**一致，这里面的原因与Nginx的进程模型以及事件处理模型是分不开的。
![客户端请求nginx-flow](http://p5vswdxl9.bkt.clouddn.com/request-nginx0-flow.png)
#### Nginx进程模型
![nginx进程模型](http://p5vswdxl9.bkt.clouddn.com/Nginx.jpg)
#### Nginx性能
Nginx的高并发，官方测试支持5万并发连接。实际生产环境能到2-3万并发连接数。10000个非活跃的HTTP keep-alive 连接仅占用约2.5MB内存。三万并发连接下，10个Nginx进程，消耗内存150M。淘宝tengine团队说测试结果是“24G内存机器上，处理并发请求可达200万”。

-------

### 负载均衡
* 负载均衡在服务端开发中算是一个比较重要的特性。Nginx除了作为常规的Web服务器外，还会被大规模的用于反向代理前端，因为Nginx的异步框架可以处理很大的并发请求，把这些并发请求hold住之后就可以分发给后台服务端(backend servers，也叫做服务池， 后面简称backend)来做复杂的计算、处理和响应，这种模式的好处是相当多的：隐藏业务主机更安全，节约了公网IP地址，并且在业务量增加的时候可以方便地扩容后台服务器。
* Nginx有一个特性，就是在<font color=#FF0000>反向代理</font>的时候，其默认会将前端所有请求都读取完毕后，再向后端upstream发送请求，这等于Nginx将前端的高并发、复杂的外网传输环境给hold住了，这也是Nginx被作为最流行的接入层的原因所在。

#### 什么是负载均衡
&emps;&emps;应用部署在不同的服务器上，但是通过统一的域名进入，Nginx则对请求进行分发，将请求分发到不同的服务器上去处理，这样就可以有效的减轻了单台服务器的压力。
&emps;&emps;在上面这两种情况下，Nginx服务器的作用都只是作为分发服务器，真正的内容，我们可以放在其他的服务器上，这样来，还能起到一层安全隔壁的作用，Nginx作为隔离层


### 推荐博文
1. [Nginx负载均衡](https://juejin.im/post/5821c24e570c350060bef4c3#heading-0)
2. [如何用Nginx搭建一个安全的、快速的微服务架构](https://juejin.im/post/5ad1b5f75188255c5668de81)
3. []()

