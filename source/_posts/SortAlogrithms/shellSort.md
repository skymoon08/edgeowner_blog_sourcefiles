---
title: 希尔排序（Shell Sort）
tags: [Algorithms, Sort]
copyright: true
date: 2015-03-25 09:15:31
updated: 2015-03-25 20:17:23
categories: Algorithms
mathjax: true
---

### 希尔排序
希尔排序也称为递减增量排序算法，是插入排序的一种更高效的改进版本。希尔排序是非稳定排序算法。希尔排序是基于插入排序的一下两点性质而提出改进方法的：
* 插入排序在对几乎已经安排好序的数据操作时，效率高，即可达到线性排序的效率
* 插入排序一般来说是抵消的，因为插入排序每次只能将数据移动一位
从专业的角度上讲，将一个序列分成好几个序列，用一个数来表示：那个数称为增量。显然的是，增量是不断递减的(直到增量为$1$)

希尔排序的平均复杂度是$O(N*logN)~O(N^2)$，最好的情况$O(N^1.3)$，最坏的情况$O(N^2)$；空间复杂度$O(1)$;不稳定算法

-------
<!-- more -->
#### 算法思路
In this sorting algorithm we compare elements that are distant apart rather than adjacent. Shell sort is like insertion sort.
1. We start by comparing elements that are at a certain distance apart.So if there are **N** elements then we start with a value **gap < N**
2. In each pass we keep reducing the value of gap till we reach the last pass when gap is 1
3. **Note!**, when gap = 1,shell sort is like insertion sort and we will have sorted elements at the end of this pass;

算法动态展示
 1. [YouTube视频源地址](https://www.youtube.com/watch?v=SHcPqUe2GZM) ;
 2. [Shell Sort - step by step guide](https://www.youtube.com/watch?v=SCBf7aqKQEY&t=36s);
 3. [开课老师视频源](https://www.youtube.com/watch?v=ddeLSDsYVp8);
 4. {% dplayer "url=http://p5vswdxl9.bkt.clouddn.com/QQ20180328-201843-HD.mp4"   "loop=yes" "theme=#FADFA3" "autoplay=false" "token=quickDemo1" %}


-------

#### 代码实现方式
```java
/**
     * 希尔排序
     *
     * @param arrs
     */
    public static void shellSort(int[] arrs) {
        if (arrs == null || arrs.length == 0) {
            return;
        }
        //增量 每次都 gap/2   gap为每次外循环的步长
        //当 步长为 1 即增量为1 时， 希尔排序蜕化为 简单插入排序
        int counterFrequency = 0;
        for (int gap = (int) Math.floor(arrs.length / 2); gap > 0; gap /= 2) {
            counterFrequency++;
            System.out.println("------------------1.Outerloop  start---------------------");
            System.out.println(MessageFormat.format("--------1.Increment:{0}, outerloop frequency:{1}---------", gap, counterFrequency));

            for (int i = gap; i < arrs.length; i++) {
                int j = i;
                int temp = arrs[j];

                // j - step 就是代表与它同组隔壁的元素 内层增量 gap通过 j-gap确定左边
                int counterSwapJGap = 0;
                while (j - gap >= 0 && arrs[j - gap] > temp) {
                    arrs[j] = arrs[j - gap];
                    j = j - gap;
                    counterSwapJGap++;
                    printArr("--------------1. arrs:{0}---------------",arrs);
                }
                printArr("--------------2. arrs:{0}---------------",arrs);
                System.out.println(MessageFormat.format("------------------3.Whileloop counter:{0}---------------------", counterSwapJGap));
                arrs[j] = temp;
                System.out.println(MessageFormat.format("--------2.Innerloop: i:{0}, j:{1} , temp:{2} ---------", i, j, temp));
            }
            System.out.println("------------------1.Outerloop  over---------------------");

        }
    }
    //对比简单插入排序

    /**
     * 简单插入排序
     *
     * @param arrs
     */
    public static void insertSortDemo(int arrs[]) {
        int len = arrs.length;
        for (int i = 1; i < len; i++) {
            for (int j = i; j < len - 1; j--) {
                if (arrs[j] < arrs[j - 1]) {
                    int temp = arrs[j];
                    arrs[j] = arrs[j - 1];
                    arrs[j - 1] = temp;
                }
            }
        }

    }
    
    /
    
    
    /**
     * 打印数组
     *
     * @param str
     * @param arrs
     */
    private static void printArr(String str, int[] arrs) {
        String result = "";
        StringBuilder sb = new StringBuilder();
        if (str != null) {
            sb.append("[");
            for (int i = 0; i < arrs.length; i++) {
                sb.append("," + arrs[i]);
            }
            sb.append("]");
            result = sb.toString().replaceFirst(",", "");
            result = MessageFormat.format(str, result);
        } else {
            sb.append("[");
            for (int i = 0; i < arrs.length; i++) {
                sb.append("," + arrs[i]);
            }
            sb.append("]");
            result = sb.toString().replaceFirst(",", "");
        }
        System.out.println("result:" + result);
    }
    
```

-------

参考地址：[希尔排序](https://mp.weixin.qq.com/s?__biz=MzI4Njg5MDA5NA==&mid=2247484071&idx=1&sn=c372ab46daf1ccdf27398951172c4443&chksm=ebd743a6dca0cab03a55772a6f64be89f9dee504a9e00f96b36e685698722ade9855d8bd3c21#rd)
Demo代码地址：[Github](https://github.com/edgeowner/JS-Sorting-Algorithm)


