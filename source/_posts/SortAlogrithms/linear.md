---
title: 排序算法之线性排序
tags: [Algorithms, Sort]
copyright: true
date: 2015-03-22 19:20:31
updated: 2015-03-23 21:29:00
categories: Algorithms
---
## 线性排序：
***计数排序 ***、***桶排序 ***、***基数排序 ***
这三种排序算法都利用了桶的概念，但对桶的使用方法上有明显差异：
> 基数排序：根据键值的每位数字来分配桶；
> 计数排序：每个桶只存储单一键值；
> 桶排序：每个桶存储一定范围的数值； 

<!-- more -->
---------------------
### 计数排序：
计数排序的核心在于将输入的数据值转化为键存储在额外开辟的数组空间中。作为一种线性时间复杂度的排序，计数排序要求输入的数据必须是有确定范围的整数。
`基本思想`

`遍历流程图例`
![](http://p5vswdxl9.bkt.clouddn.com/countingSort.gif)

`代码实现`
```java
 private static int[] counterSort(int[] arr) {
        if (null == arr || arr.length == 0) {
            return arr;
        }
        int maxValue = getMaxValue(arr);
        return countingSort(arr, maxValue);
    }

    private static int[] countingSort(int[] arr, int maxValue) {
        int bucketLen = maxValue + 1;
        int[] bucket = new int[bucketLen];

        for (int value : arr) {
            bucket[value]++;
        }
        int sortedIndex = 0;
        for (int j = 0; j < bucketLen; j++) {
            while (bucket[j] > 0) {
                arr[sortedIndex++] = j;
                bucket[j]--;
            }
        }
        return arr;
    }


    private static int getMaxValue(int[] arr) {
        int maxValue = arr[0];
        for (int value : arr) {
            if (maxValue < value) {
                maxValue = value;
            }
        }
        return maxValue;
    }
```

--------------

### 桶排序：
桶排序是计数排序的升级版。它利用了函数的映射关系，高效与否的关键就在于这个映射函数的确定。为了使桶排序更加高效，我们需要做到这两点：
> 1. 在额外空间充足的情况下，尽量增大桶的数量
> 2. 使用的映射函数能够将输入的 N 个数据均匀的分配到 K 个桶中
同时，对于桶中元素的排序，选择何种比较排序算法对于性能的影响至关重要。

`基本思想`
 类似计数排序

`遍历流程图例`

`代码实现`
```java
  //桶值大小
    private static int BUCKET_SIZE = 5;

    private static int[] bucketSort(int[] arr) {

        if (arr.length == 0) {
            return arr;
        }
        int minValue = arr[0];
        int maxValue = arr[0];
        for (int value : arr) {
            if (value < minValue) {
                minValue = value;
            } else if (value > maxValue) {
                maxValue = value;
            }
        }
        int bucketCount = (int) Math.floor((maxValue - minValue) / BUCKET_SIZE) + 1;
        int[][] buckets = new int[bucketCount][0];
        // 利用映射函数将数据分配到各个桶中
        for (int i = 0; i < arr.length; i++) {
            int index = (int) Math.floor((arr[i] - minValue) / BUCKET_SIZE);
            buckets[index] = arrAppend(buckets[index], arr[i]);
        }

        int arrIndex = 0;
        for (int[] bucket : buckets) {
            if (bucket.length <= 0) {
                continue;
            }
            // 对每个桶进行排序，这里使用了插入排序
            bucket = insertSort(bucket);
            for (int value : bucket) {
                arr[arrIndex++] = value;
            }
        }
        return arr;
    }

    /**
     * 自动扩容，并保存数据
     *
     * @param arr
     * @param value
     */
    private static int[] arrAppend(int[] arr, int value) {
        arr = Arrays.copyOf(arr, arr.length + 1);
        arr[arr.length - 1] = value;
        return arr;
    }


    /**
     * 插入排序
     *
     * @param arr
     * @return
     */
    public static int[] insertSort(int[] arr) {
        if (null == arr || arr.length == 0) {
            return arr;
        }
        // 从下标为1的元素开始选择合适的位置插入，因为下标为0的只有一个元素，默认是有序的
        for (int i = 1; i < arr.length; i++) {
            // 从已经排序的序列最右边的开始比较，找到比其小的数
            int j = i;
            // 记录要插入的数据
            int tmp = arr[i];
            while (j > 0 && tmp < arr[j - 1]) {
                arr[j] = arr[j - 1];
                j--;
            }
            // 存在比其小的数，插入
            if (j != i) {
                arr[j] = tmp;
            }

        }
        return arr;
    }
    
```

--------------
### 基数排序：
基数排序是一种非比较型整数排序算法，其原理是将整数按位数切割成不同的数字，然后按每个位数分别比较。由于整数也可以表达字符串（比如名字或日期）和特定格式的浮点数，所以基数排序也不是只能使用于整数。
`基本思想`
1. 基数排序：通过序列中各个元素的值，对排序的N个元素进行若干趟的“分配”与“收集”来实现排序；
2. 分配：我们将L[i]中的元素取出，首先确定其个位上的数字，根据该数字分配到与之序号相同的桶中；
3. 收集：当序列中所有的元素都分配到对应的桶中，再按照顺序依次将桶中的元素收集形成新的一个待排序列L[]；
对新形成的序列L[]重复执行分配和收集元素中的十位、百位...直到分配完该序列中的最高位，则排序结束；
4. 根据上述“基数排序”的展示，我们可以清楚的看到整个实现的过程

`LSD基数排序遍历流程图例`
![](http://p5vswdxl9.bkt.clouddn.com/radixSort.gif)

`代码实现`
```java
 private static int[] radixSort(int[] arr) {

        if (null == arr || arr.length == 0) {
            return arr;
        }

        int maxDigit = getMaxDigit(arr);

        return radixSort(arr, maxDigit);
    }
    /**
     * 获取最高位数
     */
    private static int getMaxDigit(int[] arr) {
        int maxValue = getMaxValue(arr);
        return getNumLenght(maxValue);
    }

    private static int getNumLenght(long num) {
        if (num == 0) {
            return 1;
        }
        int lenght = 0;
        for (long temp = num; temp != 0; temp /= 10) {
            lenght++;
        }
        return lenght;
    }


    private static int[] radixSort(int[] arr, int maxDigit) {
        int mod = 10;
        int dev = 1;

        for (int i = 0; i < maxDigit; i++, dev *= 10, mod *= 10) {
            // 考虑负数的情况，这里扩展一倍队列数，其中 [0-9]对应负数，[10-19]对应正数 (bucket + 10)
            int[][] counter = new int[mod * 2][0];

            for (int j = 0; j < arr.length; j++) {
                int bucket = ((arr[j] % mod) / dev) + mod;
                counter[bucket] = arrayAppend(counter[bucket], arr[j]);
            }

            int pos = 0;
            for (int[] bucket : counter) {
                for (int value : bucket) {
                    arr[pos++] = value;
                }
            }
        }
        return arr;
    }

    /**
     * 自动扩容，并保存数据
     *
     * @param arr
     * @param value
     */
    private static int[] arrayAppend(int[] arr, int value) {
        arr = Arrays.copyOf(arr, arr.length + 1);
        arr[arr.length - 1] = value;
        return arr;
    }


    private static int getMaxValue(int[] arr) {
        int maxValue = arr[0];
        for (int value : arr) {
            if (maxValue < value) {
                maxValue = value;
            }
        }
        return maxValue;
    }
    
```


--------------



