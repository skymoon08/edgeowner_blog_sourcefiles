---
title: 排序算法
tags: [Algorithms, Sort]
copyright: true
date: 2015-03-13 21:02:31
updated: 2015-03-14 20:29:00
categories: Algorithms
---
## 排序算法分类
##### &emsp;&emsp;&emsp;排序算法从排序的效率上分类，主要分四类：
>   1. `简单排序`：***冒泡排序 ***、***(直接)选择排序 ***、***(直接)插入排序 ***；
>   2. `高效排序`：***快速排序 ***、***堆排序 ***、***希尔排序 ***；
>   3. `分治递归思想实现的排序`：***递归排序 ***；
>   4. `线性排序`：***计数排序 ***、***桶排序 ***、***基数排序 ***；
##### &emsp;&emsp;&emsp;排序算法从排序的方式分类，主要分为五类：
>   1. `插入排序`：***直接插入排序 ***、***希尔排序 ***；
>   2. `选择排序`：***直接选择排序 ***、***堆排序 ***；
>   3. `交换排序`：***冒泡排序 ***、***快速排序 ***；
>   4. `线性排序`：***计数排序 ***、***基数排序 ***、***桶排序 ***；
>   5. `递归排序`：***归并排序 ***；
<!-- more -->
-------

> **关于时间复杂度：**
1. 平方阶 (O(n2)) 排序 各类简单排序：直接插入、直接选择和冒泡排序。
2. 线性对数阶 (O(nlog2n)) 排序 快速排序、堆排序和归并排序；
3. O(n1+§)) 排序，§ 是介于 0 和 1 之间的常数。 希尔排序
4. 线性阶 (O(n)) 排序 基数排序，此外还有桶、箱排序。

> ***关于稳定性 ***：
1. 稳定的排序算法：冒泡排序、插入排序、归并排序和基数排序。
2. 不是稳定的排序算法：选择排序、快速排序、希尔排序、堆排序。

> ***名词解释 ***：
1. n：数据规模
2. k：“桶”的个数
3. In-place：占用常数内存，不占用额外内存
4. Out-place：占用额外内存
5. 稳定性：排序后 2 个相等键值的顺序和排序之前它们的顺序相同


`排序的10种算法如下图例`：
![](http://p5vswdxl9.bkt.clouddn.com/all_sort_sumary.png)

> &emsp;&emsp;&emsp;后续有关博文主要从排序效率上讲解以上4类排序中共10种排序算法思以及使用Java语言的算法实现。
1. [简单排序](http://edgeowner.com/2015/03/14/simple-sort/)
2. [高效排序](http://edgeowner.com/2015/03/16/high-efficiency/)
3. [归并排序](http://edgeowner.com/2015/03/18/division-recursion/)
4. [线性排序](http://edgeowner.com/2015/03/22/linear/)

---------------------
参考：
1. [八大基础排序总结](https://mp.weixin.qq.com/s?__biz=MzI4Njg5MDA5NA==&mid=2247484058&idx=1&sn=432c2dd8e4bda662ce066c09f8e22bda&chksm=ebd7439bdca0ca8ded40d0f431db411928936db9b4b5f5595027c8acd2efdef5ba35348641d2&scene=21#wechat_redirect)
2. [十大经典排序算法](https://github.com/hustcc/JS-Sorting-Algorithm)
3. [Demo代码地址](https://github.com/edgeowner/JS-Sorting-Algorithm)

 
   



