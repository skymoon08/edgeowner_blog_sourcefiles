---
title: 堆排序（Heap Sort）
tags: [Algorithms, Sort]
copyright: true
date: 2015-03-24 10:12:31
updated: 2015-03-24 22:19:00
categories: Algorithms
---

### 堆排序
堆排序是利用堆这种数据结构而设计的一种排序算法，堆排序是一种选择排序，它的最坏，最好，平均时间复杂度均为O(nlogn)，它也是不稳定排序。
堆是具有以下性质的完全二叉树：每个结点的值都大于或等于其左右孩子结点的值，称为大顶堆；或者每个结点的值都小于或等于其左右孩子结点的值，称为小顶堆。
大堆小堆图例：
![](http://p5vswdxl9.bkt.clouddn.com/%E5%A4%A7%E5%A0%86%E5%B0%8F%E5%A0%86.png)
简单来说：堆排序是将数据看成是完全二叉树、根据完全二叉树的特性来进行排序的一种算法。
最大堆要求节点的元素都要不小于其孩子，最小堆要求节点元素都不大于其左右孩子。那么处于最大堆的根节点的元素一定是这个堆中的最大值。
完全二叉树有个特性：左边子节点位置 = 当前父节点的两倍 + 1，右边子节点位置 = 当前父节点的两倍 + 2
[点击参考文章](https://mp.weixin.qq.com/s?__biz=MzI4Njg5MDA5NA==&mid=2247484064&idx=2&sn=d308d573df43e8e3b0633d0dc1147c3b&chksm=ebd743a1dca0cab774e7df348401039dda0765923efde0b9cf8e3589c4ceab25c5ec0cea5f7d#rd)

<!-- more -->
-------

#### 算法思路

这里我们讨论最大堆：当前每个父节点都大于子节点。
In this Algorithm we first build the heap using the given elements, We create a Max Heap to sort the elements in ascending order , Once the heap is 
created we swap the root node with the last node an delete the last node from the heap。
1. Build a heap we need transform it into to a max  heap ;
2. Create a Max heap (this Max heap parent node is always greater than or equal to child nodes);
3. Remove the node ,in anther way :Swap first and last node and delete the last node from heap;
4. Repeat the 1,2,3 step ,always build the max heap;

算法动态展示：
1.  [YouTube视频源地址](https://www.youtube.com/watch?v=MtQL_ll5KhQ&t=26s)
2. [Heap Sort - step by step guide](https://www.youtube.com/watch?v=51JGP4VVlDc&t=276s);
3. {% dplayer "url=http://p5vswdxl9.bkt.clouddn.com/QQ20180328-140208-HD.mp4"   "loop=yes" "theme=#FADFA3" "autoplay=false" "token=quickDemo1" %}

-------

#### 代码实现方式
(关键节点添加输出标注，可自行追踪执行过程)
```java
 /**
     * 堆排序
     *
     * @param arrs
     */
    public static void heapSort(int[] arrs) {
        if (arrs == null || arrs.length == 0) {
            return;
        }
        int len = arrs.length;
        //循环建立最大堆
        for (int i = 0; i < len; i++) {
            System.out.println(MessageFormat.format("1. heapSort: i,{0}  j,{1}", i, len - 1));
            System.out.println("--------------1. buildMaxHeap start--------------");
            buildMaxHeap(arrs, len - i);
            //交换堆顶和最后一个元素
            int temp = arrs[0];
            arrs[0] = arrs[len - 1 - i];
            arrs[len - 1 - i] = temp;
            System.out.println("--------------1. buildMaxHeap over--------------");
        }
        
    }

    /**
     * 完成最大堆建立
     *
     * @param arrs
     * @param len
     */
    private static void buildMaxHeap(int[] arrs, int len) {
        System.out.println("--------------2. buildMaxHeap method start--------------");
        System.out.println(MessageFormat.format("--------------2. params:{0}--------------",len));
        for (int j = (int) Math.floor(len / 2); j >= 0; j--) {
            heapify(arrs, j, len);
        }
    }

    /**
     * 建立堆 (大顶堆方式)
     *
     * @param arrs           完全二叉树
     * @param currentRooNode 当前父节点位置
     * @param length         节点总数
     */
    private static void heapify(int[] arrs, int currentRooNode, int length) {
        System.out.println("--------------3. heapify method start--------------");
        System.out.println(MessageFormat.format("--------------3. params:{0},{1}-------------", currentRooNode, length));
        if (currentRooNode < length) {
            //左叶子结点 位置
            int left = 2 * currentRooNode + 1;
            //右叶子结点 位置
            int right = 2 * currentRooNode + 2;
            int max = currentRooNode;

            if (left < length) {
                //如果当前根节点的 左叶子节点元素值较大，记录它的位置
                if (arrs[max] < arrs[left]) {
                    max = left;
                }
            }

            if (right < length) {
                //如果当前根节点的 右叶子节点元素值较大，记录它的位置
                if (arrs[max] < arrs[right]) {
                    max = right;
                }
            }

            //如果最大的不是根元素位置，那么就交换
            if (max != currentRooNode) {
                int temp = arrs[max];
                arrs[max] = arrs[currentRooNode];
                arrs[currentRooNode] = temp;
                //继续比较，直到完成一次建堆
                heapify(arrs, max, length);
            }

        }
        System.out.println("--------------3. heapify method over--------------");
    }
```
参考地址：[堆排序](https://mp.weixin.qq.com/s?__biz=MzI4Njg5MDA5NA==&mid=2247484064&idx=2&sn=d308d573df43e8e3b0633d0dc1147c3b&chksm=ebd743a1dca0cab774e7df348401039dda0765923efde0b9cf8e3589c4ceab25c5ec0cea5f7d#rd)
Demo代码地址：[Github](https://github.com/edgeowner/JavaCoreDemo)




