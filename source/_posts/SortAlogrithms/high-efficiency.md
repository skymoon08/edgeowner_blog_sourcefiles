---
title: 排序算法之高效排序
tags: [Algorithms, Sort]
copyright: true
date: 2015-03-16 18:02:31
updated: 2015-03-16 20:29:00
categories: Algorithms
---
## 高效排序
***快速排序 ***、***堆排序 ***、***希尔排序 ***

<!-- more -->
---------------------
### 快速排序：
> 快速排序是由东尼·霍尔所发展的一种排序算法。在平均状况下，排序 n 个项目要 Ο(nlogn) 次比较。在最坏状况下则需要 Ο(n2) 次比较，但这种状况并不常见。事实上，快速排序通常明显比其他 Ο(nlogn) 算法更快，因为它的内部循环（inner loop）可以在大部分的架构上很有效率地被实现出来。
> ***快速排序使用分治法（Divide and conquer）策略来把一个串行（list）分为两个子串行（sub-lists）。 ***     
> 快速排序又是一种分而治之思想在排序算法上的典型应用。本质上来看，快速排序应该算是在冒泡排序基础上的递归分治法。     
快速排序的名字起的是简单粗暴，因为听到这个名字你就知道它存在的意义，就是快而且效率高！它是处理大数据最快的排序算法之一了。虽然 Worst Case 的时间复杂度达到了 O(n²)，但是人家就是优秀，在大多数情况下都比平均时间复杂度为 O(n logn) 的排序算法表现要更好。

`基本思想`
1. 从数列中挑出一个元素，称为 “基准”(pivot);
2. 重新排序数列，所有元素比基准值小的摆放在基准前面，所有元素比基准值大的摆在基准的后面(相同的数可以到任一边)。在这个分区退出之后，该基准就处于数列的中间位置。这个称为分区(partition)操作()；
3. 递归地(recursive)把小于基准值元素的子数列和大于基准值元素的子数列排序；
>  递归的最底部情形，是数列的大小是零或一，也就是永远都已经被排序好了。虽然一直递归下去，但是这个算法总会退出，因为在每次的迭代（iteration）中，它至少会把一个元素摆到它最后的位置去。

`遍历流程图例`
![](http://p5vswdxl9.bkt.clouddn.com/quickSort.gif)

`代码实现`
```java
   public static void quickSort(int[] arr) {
        if (null == arr || arr.length == 0) {
            return;
        }
        quickSort(arr, 0, arr.length - 1);
    }

    private static int[] quickSort(int[] arr, int left, int right) {
        if (left < right) {
            int partitionIndex = partition(arr, left, right);
            quickSort(arr, left, partitionIndex - 1);
            quickSort(arr, partitionIndex + 1, right);
        }
        return arr;
    }

    private static int partition(int[] arr, int left, int right) {
        //设定基准值(pivot)
        int pivot = left;
        int index = pivot + 1;
        for (int i = index; i <= right; i++) {
            if (arr[i] < arr[pivot]) {
                SwapUtils.swap(arr, i, index);
                index++;
            }
        }
        SwapUtils.swap(arr, pivot, index - 1);
        return index - 1;
    }
```

** 快速排序的最坏运行情况是 O(n²)，比如说顺序数列的快排。但它的平摊期望时间是 O(nlogn)，且 O(nlogn) 记号中隐含的常数因子很小，比复杂度稳定等于 O(nlogn) 的归并排序要小很多。所以，对绝大多数顺序性较弱的随机数列而言，快速排序总是优于归并排序。 **

--------------

### 堆排序：
> 堆排序（Heapsort）是指利用堆这种数据结构所设计的一种排序算法。堆积是一个近似完全二叉树的结构，并同时满足堆积的性质：即子结点的键值或索引总是小于（或者大于）它的父节点。堆排序可以说是一种利用堆的概念来排序的选择排序。分为两种方法：
>> 大顶堆：每个节点的值都大于或等于其子节点的值，在堆排序算法中用于升序排列；
>> 小顶堆：每个节点的值都小于或等于其子节点的值，在堆排序算法中用于降序排列；
> 将待排序序列构造成一个大顶堆，此时，整个序列的最大值就是堆顶的根节点。将其与末尾元素进行交换，此时末尾就为最大值。然后将剩余n-1个元素重新构造成一个堆，这样会得到n个元素的次小值。如此反复执行，便能得到一个有序序列了。

`基本思想`
1. 创建一个堆 H[0……n-1]；
2. 把堆首（最大值）和堆尾互换；
3. 把堆的尺寸缩小 1，并调用 shift_down(0)，目的是把新的数组顶端数据调整到相应位置；
4. 重复步骤2，直到堆的尺寸为 1。

`遍历流程图例`
![](http://p5vswdxl9.bkt.clouddn.com/heapSort.gif)

`代码实现`
```java
public static void heapSort(int[] arr) {
        if (null == arr || arr.length == 0) {
            return;
        }
        
        int len = arr.length;

        buildMaxHeap(arr, len);

        for (int i = len - 1; i > 0; i--) {
            SwapUtils.swap(arr, 0, i);
            len--;
            heapify(arr, 0, len);
        }
    }

    private static void buildMaxHeap(int[] arr, int len) {
        for (int i = (int) Math.floor(len / 2); i >= 0; i--) {
            heapify(arr, i, len);
        }
    }

    private static void heapify(int[] arr, int i, int len) {

        int left = 2 * i + 1;
        int right = 2 * i + 2;
        int largest = i;

        if (left < len && arr[left] > arr[largest]) {
            largest = left;
        }

        if (right < len && arr[right] > arr[largest]) {
            largest = right;
        }

        if (largest != i) {
            SwapUtils.swap(arr, i, largest);
            heapify(arr, largest, len);
        }

    }
```

** 堆排序的平均时间复杂度为 Ο(nlogn)。 **

--------------

### 希尔排序：
> 希尔排序，也称递减增量排序算法，是插入排序的一种更高效的改进版本。但希尔排序是非稳定排序算法。
> 希尔排序是基于插入排序的以下两点性质而提出改进方法的：
插入排序在对几乎已经排好序的数据操作时，效率高，即可以达到线性排序的效率；但插入排序一般来说是低效的，因为插入排序每次只能将数据移动一位；
> 希尔排序的基本思想是：先将整个待排序的记录序列分割成为若干子序列分别进行直接插入排序，待整个序列中的记录“基本有序”时，再对全体记录进行依次直接插入排序。随着增量逐渐减少，每组包含的关键词越来越多，当增量减至1时，整个文件恰被分成一组，算法便终止。

`基本思想`
1. 选择一个增量序列t1，t2，……，tk，其中ti > tj,tk = 1；
2. 按增量序列个数 k，对序列进行 k 趟排序；
3. 每趟排序，根据对应的增量 ti，将待排序列分割成若干长度为 m 的子序列，分别对各子表进行直接插入排序。仅增量因子为 1 时，整个序列作为一个表来处理，表长度即为整个序列的长度。
> 算法先将要排序的一组数按某个增量d（n/2,n为要排序数的个数）分成若干组，每组中记录的下标相差d.对每组中全部元素进行直接插入排序，然后再用一个较小的增量（d/2）对它进行分组，在每组中再进行直接插入排序。当增量减到1时，进行直接插入排序后，排序完成。

`遍历流程图例`
![](http://p5vswdxl9.bkt.clouddn.com/shellSort.png)
`代码实现`
```java
  /**
     * 希尔排序 针对有序序列在插入时采用交换法
     *
     * @param arr
     */
    private static void shellSort(int[] arr) {
        if (null == arr || arr.length == 0) {
            return;
        }
        //增量gap，并逐步缩小增量
        for (int gap = arr.length / 2; gap > 0; gap /= 2) {
            //从第gap个元素，逐个对其所在组进行直接插入排序操作
            for (int i = gap; i < arr.length; i++) {
                int j = i;
                while (j - gap >= 0 && arr[j] < arr[j - gap]) {
                    SwapUtils.swap(arr, j, j - gap);
                    j -= gap;
                }
            }
        }
    }

    /**
     * 希尔排序 针对有序序列在插入时采用移动法。
     *
     * @param arr
     */
    private static void shellSort2(int[] arr) {
        if (null == arr || arr.length == 0) {
            return;
        }
        //增量gap，并逐步缩小增量
        for (int gap = arr.length / 2; gap > 0; gap /= 2) {
            //从第gap个元素，逐个对其所在组进行直接插入排序操作
            for (int i = gap; i < arr.length; i++) {
                int j = i;
                int temp = arr[j];

                while (j - gap >= 0 && arr[j] < arr[j - gap]) {
                    //移动法
                    arr[j] = arr[j - gap];
                    j -= gap;
                }
                arr[j] = temp;
            }
        }
    }
```

**希尔排序中对于增量序列的选择十分重要，直接影响到希尔排序的性能。我们上面选择的增量序列{n/2,(n/2)/2...1}(希尔增量)，其最坏时间复杂度依然为O(n2)，一些经过优化的增量序列如Hibbard经过复杂证明可使得最坏时间复杂度为O(n3/2)。**

