---
title: 排序算法之简单排序
tags: [Algorithms, Sort]
copyright: true
date: 2015-03-14 20:10:31
updated: 2015-03-15 20:29:00
categories: Algorithms
---

## 简单排序
***冒泡排序 ***、***选择排序 ***、***插入排序 ***
```java  公共代码部分
public class SwapUtils {

    public static void swap(int[] arr, int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;

    }

    public static void printArrays(int[] arrs) {
        StringBuilder sb = new StringBuilder();
        if (null == arrs || arrs.length == 0) {
            System.out.println("Is Empty!");
            return;
        }
        for (int i = 0; i < arrs.length; i++) {
            sb.append("," + arrs[i]);
        }
        String toPring = sb.append(" ]").toString().replaceFirst(",", "");
        System.out.println(toPring);

    }
}
```
<!-- more -->

---------------------
### 冒泡排序：
冒泡排序（Bubble Sort）是一种简单直观的排序算法。它重复地走访过要排序的数列，一次比较两个元素，如果他们的顺序错误就把他们交换过来。走访数列的工作是重复地进行直到没有再需要交换，也就是说该数列已经排序完成。这个算法的名字由来是因为越小的元素会经由交换慢慢“浮”到数列的顶端。
`基本思想`
1. 比较相邻的元素。如果第一个比第二个大，就交换他们两个；
2. 对每一对相邻元素作同样的工作，从开始第一对到结尾的最后一对进行循环遍历。最后的元素会是最大的数；
3. 针对所有的元素重复以上的步骤，除了最后一个；
4. 持续每次对越来越少的元素重复上面的步骤，直到没有任何一对数字需要比较。

`遍历流程图例`
![](http://p5vswdxl9.bkt.clouddn.com/bubbleSort.gif)

`代码实现`
``` java
    public static void bubbleSort(int[] arr) {
        if (null == arr || arr.length == 0) {
            return;
        }
        //i控制外循环即总共需要将多少个数字进行排序，
        //j控制内循环即每次循环都会将最大的数排到右边
        for (int i = 0; i < arr.length - 1; i++) {
            for (int j = 0; j < arr.length - i - 1; j++) {
                //如果前面的数字大于后面的数字就将前面的数字和后面的数字进行交换，直接最大的数字被排到最右侧
                if (arr[j] > arr[j + 1]) {
                    SwapUtils.swap(arr, j + 1, j);
                }
            }
        }
    }
   ```
   
 ** 冒泡排序的时间复杂度为O(n²) **
> 最快：当输入的数据已经是正序时（都已经是正序了，冒泡排序有何用）。
> 最慢：当输入的数据是反序时（写一个 for 循环反序输出数据不就行了，干嘛要用你冒泡排序呢，我是闲的吗）。
 
--------------

### 选择排序：
选择排序是一种简单直观的排序算法，无论什么数据进去都是 O(n²) 的时间复杂度。所以用到它的时候，数据规模越小越好。唯一的好处不占用额外的内存空间。
`基本思想`
1. 首先在未排序序列中找到最小（大）元素，存放到排序序列的起始位置；
2. 再从剩余未排序元素中继续寻找最小（大）元素，然后放到已排序序列的末尾；
3. 重复第二步，直到遍历完所有元素，且均排序完毕为止。

`遍历流程图例`
![](http://p5vswdxl9.bkt.clouddn.com/selectionSort.gif)

`代码实现`
```java
  public static void selectSort(int[] arr) {

        if (null == arr || arr.length == 0) {
            return;
        }
        // 每一趟循环比较时，min用于存放较小元素的数组下标，
        // 这样当前批次比较完毕最终存放的就是此趟内最小的元素的下标，避免每次遇到较小元素都要进行交换。
        for (int i = 0; i < arr.length - 1; i++) {
            int min = i;
            for (int j = i + 1; j < arr.length; j++) {
                if (arr[j] < arr[min]) {
                    min = j;
                }
            }
            if (min != i) {
                SwapUtils.swap(arr, min, i);
            }

        }
    }

```

**选择排序是一种简单直观的排序算法，无论什么数据进去都是 O(n²) 的时间复杂度。所以用到它的时候，数据规模越小越好。唯一的好处可能就是不占用额外的内存空间。 **

--------------

### 插入排序：
插入排序的代码实现虽然没有冒泡排序和选择排序那么简单粗暴，但它的原理应该是最容易理解的，因为只要打过扑克牌的人都应该能够秒懂。插入排序是一种最简单直观的排序算法，它的工作原理是通过构建有序序列，对于**未排序数据**，在已排序序列中从后向前扫描，找到相应位置并插入。     
`基本思想`
1. 将第一待排序序列的第一个元素作为一个有序序列，把第二个元素到最后一个元素当成是未排序序列；
2. 从头到尾依次扫描未排序序列，将扫描到的每个元素插入有序序列的适当位置。（如果待插入的元素与有序序列中的某个元素相等，则将待插入元素插入到相等元素的后面）

`遍历流程图例`
![](http://p5vswdxl9.bkt.clouddn.com/insertionSort.gif)

`代码实现`
```java
public static void insertSort(int[] arr) {
        if (null == arr || arr.length == 0) {
            return;
        }
        // 从下标为1的元素开始选择合适的位置插入，
        // 因为下标为0的只有一个元素，默认是有序的
        for (int i = 1; i < arr.length; i++) {
            // 记录要插入的数据
            int tmp = arr[i];
            int j = i;
            // 从已经排序的序列最右边的开始比较，找到比其小的数
            while (j > 0 && tmp < arr[j - 1]) {
                arr[j] = arr[j - 1];
                j--;
            }
            // 存在比其小的数，插入
            if (j != i) {
                arr[j] = tmp;
            }
        }
    }
```
** 插入排序和冒泡排序一样，也有一种优化算法，叫做拆半插入。时间复杂度为O(n²)，是稳定的排序。 **

-------

Demo代码地址：[Github](https://github.com/edgeowner/JS-Sorting-Algorithm)

