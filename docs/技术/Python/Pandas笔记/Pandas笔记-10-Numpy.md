# Numpy 笔记

## Numpy 库

还是之前的例子，一个很常见的 Excel 表格：

|  班级  | 姓名 | 性别 | 分数 |
| :----: | :--: | :--: | :--: |
| 三年级 |  甲  |  女  |  86  |
| 二年级 |  乙  |  女  |  75  |
| 三年级 |  丙  |  男  |  93  |

```python
import numpy as np
lb = [['班级','姓名','性别','分数'],['三年级','甲','女','86'],['二年级','乙','女','75'],['三年级','丙','男','93']]
arr = np.array(lb)
```

找出三年级的所有人的姓名：

```python
col1 = arr[:,0]  #第一列
row1 = arr[0,:]  #第一行

输出：r值:['甲', '丙']

```

找出第一个符合三年级条件的姓名：

TODO：学习 Numpy 库

## N 维数组 ndarray

## darray 结构图

`ndarray`中的每个元素在内存中使用相同大小的块。 `ndarray`中的每个元素是数据类型对象的对象 (称为 `dtype`)。

从`ndarray`对象提取的任何元素 (通过切片) 由一个数组标量类型的 Python 对象表示。下图显示了`ndarray`，数据类型对象 (`dtype`) 和数组标量类型之间的关系。

## 构建 ndarray

打开 Python 终端

```python
import numpy as np
a = np.array([0, 1, 2, 3]) # 构建 1 维数组
>>> a
array([0, 1, 2, 3])
>>>
b = np.array([[0, 1, 2], [3, 4, 5]]) # 构建二维数组，2 row x 3 col
>>> b
array([[0, 1, 2],
 [3, 4, 5]])
```

上面的方式是最基本的方法，也是最笨的方法，下面看一些非常“鸡贼”的方法。

使用一些跟数值范围相关的函数来创建。

```python
>>> a = np.arange(10) # 生成 0-5 数组
>>> a
array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
>>>
>>> b = np.arange(1, 6, 2) # 生成开始为 1，结束为 5（6-1），步长为 2 数组
>>> b
array([1, 3, 5])
```

常用的数组

```python
>>> a = np.ones((3, 3)) # reminder: (3, 3) is a tuple
>>> a
array([[ 1., 1., 1.],
 [ 1., 1., 1.],
 [ 1., 1., 1.]])
>>> b = np.zeros((2, 2))
>>> b
array([[ 0., 0.],
 [ 0., 0.]])
>>> c = np.eye(3) # 单位矩阵
>>> c
array([[ 1., 0., 0.],
 [ 0., 1., 0.],
 [ 0., 0., 1.]])
>>> d = np.diag(np.array([1, 2, 3, 4])) # 对角矩阵
>>> d
array([[1, 0, 0, 0],
 [0, 2, 0, 0],
 [0, 0, 3, 0],
 [0, 0, 0, 4]])
```

随机数组

```python
>>> a = np.random.rand(2, 3)       # uniform in [0, 1]
>>> a
array([[ 0.6713131 ,  0.36077404,  0.13295515],
       [ 0.21052194,  0.39054944,  0.24861006]])
>>> b = np.random.randn(2, 3)      # Gaussian
>>> b
array([[-1.25166408, -0.61573192, -0.41214682],
       [-0.25353635,  1.04938271,  0.02308834]])
```

Python

## nddaray 常用属性

|       名称       | 作用                                             |
| :--------------: | ------------------------------------------------ |
|  ndarray.flags   | 有关数组的内存布局的信息。                       |
|  ndarray.shape   | 数组维数组。                                     |
| ndarray.strides  | 遍历数组时，在每个维度中步进的字节数组。         |
|   ndarray.ndim   | 数组维数，在 Python 世界中，维度的数量被称为 rank。 |
|   ndarray.data   | Python 缓冲区对象指向数组的数据的开始。           |
|   ndarray.size   | 数组中的元素总个数。                             |
| ndarray.itemsize | 一个数组元素的长度（以字节为单位）。             |
|  ndarray.nbytes  | 数组的元素消耗的总字节数。                       |
|   ndarray.base   | 如果内存是来自某个其他对象的基本对象。           |
|  ndarray.dtype   | 数组元素的数据类型。                             |
|    ndarray.T     | 数组的转置。                                     |

```python
>>> a = np.array([(2,3,4), (5,6,7)])
>>> a.flags
  C_CONTIGUOUS : True
  F_CONTIGUOUS : False
  OWNDATA : True
  WRITEABLE : True
  ALIGNED : True
  UPDATEIFCOPY : False
>>> a.shape
(2L, 3L)
>>> a.ndim
2
>>> a.strides
(12L, 4L)
>>> a.data
<read-write buffer for 0x00000000099EA2B0, size 24, offset 0 at 0x0000000009953B20>
>>> a.size
6
>>> a.itemsize
4
>>> a.nbytes
24
>>> a.dtype
dtype('int32')
>>> a.T
array([[2, 5],
       [3, 6],
       [4, 7]])
```
