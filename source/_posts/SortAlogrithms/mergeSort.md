---
title: 归并排序（Merge Sort）
tags: [Algorithms, Sort]
copyright: true
date: 2015-03-28 19:35:31
updated: 2015-03-28 20:17:23
categories: Algorithms 
mathjax: true
---

### 归并排序
归并排序（Merge Sort）是建立在归并操作上的一种有效的排序算法,该算法是采用分治法（Divide and Conquer）的一个非常典型的应用。将已有序的子序列合并，得到完全有序的序列；即先使每个子序列有序，再使子序列段间有序。若将两个有序表合并成一个有序表，称为二路归并。

归并过程为：比较$a[i]$和$b[j]$的大小，若$a[i]≤b[j]$，则将第一个有序表中的元素$a[i]$复制到$r[k]$中，并令$i$和$k$分别加上$1$；否则将第二个有序表中的元素$b[j]$复制到$r[k]$中，并令$j$和$k$分别加上$1$，如此循环下去，直到其中一个有序表取完，然后再将另一个有序表中剩余的元素复制到$r$中从下标$k$到下标$t$的单元。归并排序的算法我们通常用递归实现，先把待排序区间$[s,t]$以中点二分，接着把左边子区间排序，再把右边子区间排序，最后把左区间和右区间用一次归并操作合并成有序的区间$[s,t]$。
  
-------

<!-- more -->

#### 算法思路
Selection Sort、Bubble Sort、Insertion Sort is $O(n^2)$ in average case , Merge Sort $O(n log(n))$ in worst case.
1. In this sorting algorithm we use the idea of divide and conquer. We divide the array into two parts, sort them and then merge them to get the elements in ascending or descending order. Merge sorting is done recursively.
2. We take an array and keep dividing from the middle till we get only one element in each halves(sub-array).
3. The we sort the sub-arrays and join (merge) them back to get the final sorted array.

> 1. 申请空间，使其大小为两个已经排序序列之和，该空间用来存放合并后的序列；
> 2. 设定两个指针，最初位置分别为两个已经排序序列的起始位置；
> 3. 比较两个指针所指向的元素，选择相对小的元素放入到合并空间，并移动指针到下一位置；
> 4. 重复步骤3直到某一指针超出序列尾；
> 5. 将另一序列剩下的所有元素直接复制到合并序列尾

**总结**：
* 将两个已排好序的数组合并成一个有序的数组,称之为归并排序；
* 步骤：遍历两个数组，比较它们的值。谁比较小，谁先放入大数组中，直到数组遍历完成；

算法动态展示
1. [YouTube视频源地址](https://www.youtube.com/watch?v=7zuGmKfUt7s&t=15s) ;
2. [Merge Sort - step by step guide](https://www.youtube.com/watch?v=e5ik2UGjHBk);     
***In this video beg and end are pointing at array index not the value at the array index.﻿ ***
3. [开课老师视频源](https://www.youtube.com/watch?v=qdv3i6X0PiQ); 
4. [MycodeSchool](https://www.youtube.com/watch?v=TzeBrDU-JaY&t=319s) 
5. {% dplayer "url=http://p5vswdxl9.bkt.clouddn.com/mergeSort.mp4"   "loop=yes" "theme=#FADFA3" "autoplay=false" "token=quickDemo1" %}
 
-------

#### 代码实现方式
```java
  /**
     * 归并排序
     *
     * @param arrs
     */
    public static void mergeSort(int[] arrs) {
        if (arrs == null || arrs.length == 0 || arrs.length == 0) {
            return;
        }
        mergeSort(arrs, 0, arrs.length - 1);
    }

    /**
     * 归并排序核心部分(递归调用)
     *
     * @param arrs
     * @param left
     * @param right
     */
    private static void mergeSort(int[] arrs, int left, int right) {
        //如果只有一个元素就不用排序
        if (left == right) {
            return;
        } else {
            //取消中间数，进行拆分
            int middle = (left + right) / 2;
            //左边的数不断进行拆分
            mergeSort(arrs, left, middle);
            //右边的数不断进行拆分
            mergeSort(arrs, middle + 1, right);
            //合并
            merge(arrs, left, middle + 1, right);
        }
    }

    /**
     * 合并数组
     *
     * @param arrs
     * @param left   指向数组第一个元素
     * @param middle 指向数组分隔的元素
     * @param right  指向数组最后的元素
     */
    private static void merge(int[] arrs, int left, int middle, int right) {

        //左边的数组大小
        int[] leftArrs = new int[middle - left];

        //右边的数组大小
        int[] rightArrs = new int[right - middle + 1];

        //往这两个数组填充数据
        for (int i = left; i < middle; i++) {
            leftArrs[i - left] = arrs[i];
        }
        for (int i = middle; i <= right; i++) {
            rightArrs[i - middle] = arrs[i];
        }

        int i = 0, j = 0;
        //arrs数组的第一个元素
        int k = left;
        //比较两个数组的值，哪个小，就往数组上放
        while (i < leftArrs.length && j < rightArrs.length) {
            //谁比较小，谁将元素放入大数组中，移动指针，继续比较下一个
            if (leftArrs[i] < rightArrs[j]) {
                arrs[k] = leftArrs[i];
                i++;
                k++;
            } else {
                arrs[k] = rightArrs[j];
                j++;
                k++;
            }
        }

        //如果左边的数组还没比较完，右边的数都已经完了，那么将左边的数抄到大数组中(剩下的都是大数字)
        while (i < leftArrs.length) {
            arrs[k] = leftArrs[i];
            i++;
            k++;
        }
        //如果右边的数组还没比较晚，左边的数都已经完了，那么将右边的数抄到大数组中(剩下的都是大数字)
        while (j < rightArrs.length) {
            arrs[k] = rightArrs[j];
            k++;
            j++;
        }
    }
```

参考地址：[归并排序](https://mp.weixin.qq.com/s?__biz=MzI4Njg5MDA5NA==&mid=2247484058&idx=1&sn=432c2dd8e4bda662ce066c09f8e22bda&chksm=ebd7439bdca0ca8ded40d0f431db411928936db9b4b5f5595027c8acd2efdef5ba35348641d2&scene=21#wechat_redirect)
Demo代码地址：[Github](https://github.com/edgeowner/JavaCoreDemo)


