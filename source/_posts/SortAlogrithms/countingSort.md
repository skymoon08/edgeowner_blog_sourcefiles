---
title: 计数排序（Counting Sort）
tags: [Algorithms, Sort]
copyright: true
date: 2015-03-27 10:30:31
updated: 2015-03-27 11:30:14
categories: Algorithms
mathjax: true
---
### 计数排序
计数排序是一种稳定的**线性时间排序算法**。计数排序使用一个额外的数组 $C$ ，其中第i个元素是待排序数组 $A$中值等于 $i$ 的元素的个数。然后根据数组 $C$ 来将 $A$ 中的元素排到正确的位置。
当输入的元素是 $n$ 个 $0$到 $k$ 之间的整数时，它的运行时间是 $\Theta (n+k)$ 。计数排序不是比较排序，排序的速度快于任何比较排序算法。
由于用来计数的数组$C$ 的长度取决于待排序数组中数据的范围（等于待排序数组的最大值与最小值的差加上 $1$），这使得计数排序对于数据范围很大的数组，需要大量时间和内存。例如：计数排序是用来排序$0$到 $100$ 之间的数字的最好的算法，但是它不适合按字母顺序排序人名。但是，计数排序可以用在基数排序算法中，能够更有效的排序数据范围很大的数组。
1. 计数排序(Counting Sort)是一种$O(n)$的排序算法，其思路是开一个长度为$maxValue-minValue+1$的数组，然后分配。扫描一遍原始数组，以当前值$-minValue$作为下标，将该下标的计数器增$1$。
2. 收集。扫描一遍计数器数组，按顺序把值收集起来。
3. 计数排序本质上是一种特殊的桶排序，当桶的个数最大的时候，就是计数排序。

<!-- more -->

-------

#### 算法思路
Counting sort is a sorting technique based on keys between a specific range, it works by counting the number of objects having distinct key values.Then doing some arithmetic to calculate the position of each object in the output sequence.

1. Create a count array to store the count of each unique object;
2. Initially the count of all elements is zero ;
3. Count each elements in the given array and  place the count at the appropriate index;
4. Modify the count array by adding the previous counts;
5. Corresponding values represent the places in the count array;
6. We place the objects in their correct positions and decrease the count by one;

*翻译*
> 1. 找出待排序的中最大元素和最小元素；
> 2. 统计数组中每个值为 $i$ 的元素出现的次数，存入数组 $C$的第$i$项；
> 3. 对所有的技术累加（ $C$ 中的第一个元素开始，每一项和前一项相加）；
> 4. 反向填充目标数组；将每个元素 $i$ i放在新数组的第$C[i]$项，每放一个元素就将 $C[i]$减去$1$ ；


算法动态展示
 1. [YouTube视频源地址](https://www.youtube.com/watch?v=7zuGmKfUt7s&t=15s) ;
 2. [Counting Sort - step by step guide](https://www.youtube.com/watch?v=TTnvXY82dtM);
 3. {% dplayer "url=http://p5vswdxl9.bkt.clouddn.com/QQ20180402-174913-HD.mp4"   "loop=yes" "theme=#FADFA3" "autoplay=false" "token=quickDemo1" %}
 
-------

#### 代码实现方式
```java
 /**
     * 计数排序 
     *
     * @param arrs
     */
    public static void countingSort(int[] arrs) {
        int[] copyData = Arrays.copyOf(arrs, arrs.length);
        int maxValue = arrs[0];
        int minValue = arrs[0];
        for (int i = 0; i < copyData.length; i++) {
            if (copyData[i] > maxValue) {
                maxValue = copyData[i];
            }
            if (copyData[i] < minValue) {
                minValue = copyData[i];
            }
        }

        int range = maxValue - minValue + 1;
        int[] counts = new int[range];
        Arrays.fill(counts, 0);
        //  计算数组中每个值和最小值的差，并计数
        for (int arr : copyData) {
            counts[arr - minValue]++;
        }
        // 得到数组中大于某个数的值一共有多少个
        for (int i = 1; i < counts.length; i++) {
            counts[i] = counts[i] + counts[i - 1];
        }
        // 根据数量放置值，每放置一个，对应的值的数量减一
        for (int i = 0; i < copyData.length; i++) {
            int index = copyData[i] - minValue;
            arrs[counts[index] - 1] = copyData[i];
            counts[index]--;
        }


    }

```

参考地址：[计数排序](https://github.com/hustcc/JS-Sorting-Algorithm/blob/master/8.countingSort.md)
Demo代码地址：[Github](https://github.com/edgeowner/JavaCoreDemo)

