---
title: 基数排序（Radix Sort）
tags: [Algorithms, Sort]
copyright: true
date: 2015-03-27 10:35:31
updated: 2015-03-27 20:17:23
categories: Algorithms 
mathjax: true
---

### 基数排序
基数排序(radix sort)属于"分配式排序"(distribution sort)，又称"桶子法"(bucket sort)或bin sort，将要排序的元素分配至某些"桶"中，藉以达到排序的作用，基数排序法是属于稳定性的排序，其时间复杂度为$O(n log(r)m)$，其中$r$为所采取的基数，而$m$为堆数，空间复杂度$O(N)$，在某些时候，基数排序法的效率高于其它的稳定性排序法。
``基数排序是按照分配，回收（分配到不同的位置上，然后回收）...不断分配...回收来进行排序，直到有序...。``

-------

<!-- more -->

#### 算法思路
It is a sorting algorithm that is used to sort numbers. We sort the numbers from least significant digit to the most significant digit.

1. When we are sorting the numbers we will first find the number of digits in the biggest number.
2. If there are N digits in the biggest number then we will need to perform N number of pass.
3. We will pad the remaining numbers with leading zeros so they all have N digits.
4. Then we will take 10 buckets labeled 0 to 9 and sort the numbers.
5. After the sorting is complete we will remove the leading zeros.

基数排序的要点就两个：
> 1. 分配：按照元素的大小来放入不同的桶子里；
> 2. 回收：将桶子里的元素按桶子顺序重新放到数组中；
> 3. 重复…..两个步骤；
*** 基数排序对有负数和0的数列难以进行排序 ***


算法动态展示
1. [YouTube视频源地址](https://www.youtube.com/watch?v=nu4gDuFabIM) ;
2. [Radix Sort - step by step guide](https://www.youtube.com/watch?v=YXFI4osELGU);
3. [开课老师视频源](https://www.youtube.com/watch?v=xhr26ia4k38); 
4. {% dplayer "url=http://p5vswdxl9.bkt.clouddn.com/QQ20180403-113850-HD.mp4
"   "loop=yes" "theme=#FADFA3" "autoplay=false" "token=quickDemo1" %}

-------

#### 代码实现方式
```java
   /**
     * 基数排序
     *
     * @param arrs
     */
    public static void radixSort(int[] arrs) {
        int max = findMax(arrs, 0, arrs.length - 1);
        //需要遍历的次数由数组最大的位数来决定
        for (int i = 1; max / i > 0; i = i * 10) {
            int[][] buckets = new int[arrs.length][10];
            //获取每一个数字（个、十、百、千位...分配到桶子里）
            for (int j = 0; j < arrs.length; j++) {
                int num = (arrs[j] / i) % 10;
                //将其放入桶子里
                buckets[j][num] = arrs[j];
            }
            //回收桶子里的元素
            int k = 0;
            //有10个桶子
            for (int j = 0; j < 10; j++) {
                //对每个桶子里的元素进行回收
                for (int l = 0; l < arrs.length; l++) {
                    //如果桶子里有元素就回收(数据会初始化为0)
                    if (buckets[l][j] != 0) {
                        arrs[k++] = buckets[l][j];
                    }
                }
            }
        }
    }

    /**
     * 递归找出数组最大值
     *
     * @param arrs  数组
     * @param left  左边界，第一个数
     * @param right 右边界，数组长度
     * @return
     */
    public static int findMax(int[] arrs, int left, int right) {
        //若该数组只有一个数，那么最大的就是该数组第一个值
        if (left == right) {
            return arrs[left];
        } else {

            int leftValue = arrs[left];
            //找出所有元素中的最大值
            int rightvalue = findMax(arrs, left + 1, right);

            if (leftValue > rightvalue) {
                return leftValue;
            } else {
                return rightvalue;
            }
        }
    }
```

-------

参考地址：[基数排序](https://mp.weixin.qq.com/s?__biz=MzI4Njg5MDA5NA==&mid=2247484071&idx=2&sn=5195363e7a5c5e3e7cac2a733c2695e9&chksm=ebd743a6dca0cab0b79aec38ff835116af9079114c9266ef673c6c1009b32b2abf262bf35e0c&scene=21#wechat_redirect)
Demo代码地址：[Github](https://github.com/edgeowner/JS-Sorting-Algorithm)

