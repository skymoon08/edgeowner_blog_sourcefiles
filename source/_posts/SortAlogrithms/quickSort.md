---
title: 快速排序（Quick Sort）
tags: [Algorithms, Sort]
copyright: true
date: 2015-03-24 10:10:31
updated: 2015-03-24 22:19:00
categories: Algorithms
---

### 快速排序
快速排序是冒泡排序的改进版，是最好的一种内排序，面试会经常被问到，是程序员必须掌握的。

-------
#### 算法思路
快速排一般基于递归实现：
1. 选定一个合适的值（理想情况中值最好。实现中一般使用数组第一个值），称为“枢轴”（pivot）。
2. 基于这个值，将数组分为两部分，较小的分在左边，较大的分在右边。
3. 一轮下来，这个枢轴的位置一定在最终位置上。
4. 对两个子数组分别重复上述过程，直到每个数组只有一个元素。
5. 排序完成。

<!-- more -->

-------
#### 快速排序示意图：
![](http://p5vswdxl9.bkt.clouddn.com/Sorting_quicksort_anim.gif)
图例过程演示（[中文原视频地址](https://www.bilibili.com/video/av12540893?from=search&seid=6178581465044594405)）：
1. {% dplayer "url=http://p5vswdxl9.bkt.clouddn.com/QQ20180327-124320-HD.mp4"   "loop=yes" "theme=#FADFA3" "autoplay=false" "token=quickDemo1" %}
2. {% dplayer "url=http://p5vswdxl9.bkt.clouddn.com/QQ20180327-124538-HD.mp4"   "loop=yes" "theme=#FADFA3" "autoplay=false" "token=quickDemo1" %}
3. [超有趣的快速排序视频](https://www.youtube.com/watch?v=ywWBy6J5gz8)

-------
#### 代码实现方式（为了更直观的反映整个排序过程添加了标记代码）：
```java
 private static void quickSort2(int arr[], int left, int right) {
        //如果left不小于right ，需要排序的部分只有一个元素，方法返回
        System.out.println("left:" + left + ",right:" + right);
        if (left == 0 && right == 0) {
            System.out.println("i=j=0");
        }
        System.out.println("1.-------------------");
        if (left >= right) {
            System.out.println(MessageFormat.format("return: left,{0}  | right,{1}", left, right));
            return;
        }
        //设置最左边元素为基准点：pivot
        int pivot = arr[left];
        System.out.println("pivot:" + pivot);
        int i = left;
        int j = right;
        //把要排序的序列中比p大的放到右边，比p小的放到左边，p的下标位置为i
        while (i < j) {
            System.out.println("2.-------start------------");
            while (i < j && arr[j] >= pivot) {
                j--;
                System.out.println("2.  j:" + j);
            }
            System.out.println("========[j-- over, i++ start ]==========");
            while (i < j && arr[i] <= pivot) {
                i++;
                System.out.println("2.  i:" + i);
            }
            System.out.println("2.-------end------------");

            if (i < j) {
                int temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }
        //交换基准点
        arr[left] = arr[i];
        arr[i] = pivot;
        //对序列中，i左边的元素实施快速排序
        System.out.println("左边开始前， right为" + right + "值");
        quickSort2(arr, left, i - 1);
        //对序列中，j右边边的元素实施快速排序
        System.out.println("右块遍历开始...... ");
        quickSort2(arr, i + 1, right);
        System.out.println("left =:" + (i + 1) + ",right = " + right);
        System.out.println("3.-------------------");
        System.out.println("4.---------all over----------");
```

```Java
 public static void quickSort(int[] arr) {
           //大数据量测试
        int[] arr = new int[100000];
        Random r = new Random();
        for (int i = 0; i < arr.length; i++) {
            arr[i] = r.nextInt(10000000);
        }
        long start = System.currentTimeMillis();
        quickSort(nums);
        long time = System.currentTimeMillis() - start;
        System.out.println("-----------大数据量测试结果-----------");
        System.out.println("all time:" + time + "毫秒");
    }
```

-------
### 参考地址
1. [快速排序就这么简单](https://mp.weixin.qq.com/s?__biz=MzI4Njg5MDA5NA==&mid=2247484039&idx=1&sn=15aa43a3865daca394abae379c7a5383&chksm=ebd74386dca0ca90e3c3067515de1c3b3da7e0ea44a26d8dd96e8d7424f4e10227d9edac9bcf#rd)
2. [Github代码Demo](https://github.com/edgeowner/JS-Sorting-Algorithm)



