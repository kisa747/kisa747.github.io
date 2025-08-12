# 类和对象

类的成员与下划线总结：

- `_name`、`_name_`、`_name__`:建议性的私有成员，不要在外部访问。
- `__name`、 `__name_` :强制的私有成员，但是你依然可以蛮横地在外部危险访问。无法继承至子类。
- `__name__`:特殊成员，与私有性质无关，例如`__doc__`。
- `name_`、`name__`:没有任何特殊性，普通的标识符，但最好不要这么起名。

## 成员保护和访问限制

在 Python 中，如果要让内部成员不被外部访问，有以下两个方法

- `_name` ：建议性的私有成员，不要在外部访问。在编辑器里不会提示此属性。
- 在成员的名字前加上两个下划线`__`，变成强制私有成员，只能在类的内部访问，外部无法访问，但无法继承至子类。

如果使用 `_age` 隐藏了此属性，但是我们又确实像让别人按照我们的要求访问、修改 `age` 属性，可以使用内置的 `@property` 装饰器把类的方法伪装成属性调用的方式。

```python
class People:

    def __init__(self, name, age):
        self._name = name
        self._age = age

    @property
    def age(self):
        return self._age

    @age.setter
    def age(self, age):
        if isinstance(age, int):
            self._age = age
        else:
            raise ValueError

    @age.deleter
    def age(self):
        print("删除年龄数据！")

jack = People("jack", 18)
print(jack.age)
jack.age = 19
print("jack.age:  ", obj.age)
del jack.age

---------------------------
打印结果：
18
jack.age:   19
删除年龄数据！
```

将一个方法伪装成为属性后，就不再使用圆括号的调用方式了。而是类似变量的赋值、获取和删除方法了。当然，每个动作内部的代码细节还是需要你自己根据需求去实现的。

那么如何将一个普通的方法转换为一个“伪装”的属性呢？

- 首先，在普通方法的基础上添加`@property`装饰器，例如上面的 age() 方法。这相当于一个 get 方法，用于获取值，决定类似`"result = obj.age"`执行什么代码。该方法仅有一个 self 参数。
- 写一个同名的方法，添加`@xxx.setter`装饰器（xxx 表示和上面方法一样的名字），比如例子中的第二个方法。这相当于编写了一个 set 方法，提供赋值功能，决定类似`"obj.age = ...."`的语句执行什么代码。
- 再写一个同名的方法，并添加`@xxx.delete`装饰器，比如例子中的第三个方法。用于删除功能，决定`"del obj.age "`这样的语句具体执行什么代码。

简而言之，就是分别将三个方法定义为对同一个属性的获取、修改和删除。还可以定义只读属性，也就是只定义 getter 方法，不定义 setter 方法就是一个只读属性。

## 特殊成员和魔法方法

比如：

```python
__init__ :      构造函数，在生成对象时调用
__del__ :       析构函数，释放对象时使用
__str__ :       实现类到字符串的转化，print()打印显示面向用户的内容
__repr__ :      打印，转换，面向程序显示的内容，可以使用eval()计算后显示面向用户的内容
__setitem__ :   按照索引赋值
__getitem__:    按照索引获取值
__len__:        获得长度
__cmp__:        比较运算
__call__:       调用
__add__:        加运算
__sub__:        减运算
__mul__:        乘运算
__div__:        除运算
__mod__:        求余运算
__pow__:        幂
```

区分 `__str__` 和 `__repr__` 的差别：

```python
import datetime
today = datetime.datetime.today()
print(str(today))
>>> 2022-10-27 11:03:47.157539

print(repr(today))
datetime.datetime(2022, 10, 27, 11, 3, 47, 157539)

print(eval(repr(today)))
>>> 2022-10-27 11:03:47.157539
```

## 类的继承

参考：<https://docs.python.org/zh-cn/3/library/functions.html#super>

<https://rhettinger.wordpress.com/2011/05/26/super-considered-super/>

<https://blog.csdn.net/brucewong0516/article/details/79121179>

<http://learncv.cn/archives/749>

<https://python3-cookbook.readthedocs.io/zh_CN/latest/c08/p07_calling_method_on_parent_class.html>

- Python 3  中默认都是新式类，也没有旧式类，不必显式的继承 object；Python 2.x 中默认都是经典类，只有显式继承了 object 才是新式类。

  参考自：<https://www.jianshu.com/p/6f9d99f7ad54> ， <https://www.zhihu.com/question/22475395>

- 当在 Python 中出现继承的情况时，强烈建议显式地调用父类的初始化函数：

- 如果子类没有定义自己的初始化函数，父类的初始化函数会被默认调用；但是如果要实例化子类的对象，则只能传入父类的初始化函数对应的参数，否则会出错。

- 如果子类定义了自己的初始化函数，而在子类中没有显式调用父类的初始化函数，则父类的属性不会被初始化。

- 如果子类定义了自己的初始化函数，在子类中显式调用父类，子类和父类的属性都会被初始化。

注意，python3 中可以使用以下方法调用：

```python
class Root:
    def draw(self):
        # the delegation chain stops here
        assert not hasattr(super(), 'draw')

class Shape(Root):
    def __init__(self, shapename, **kwds):
        self.shapename = shapename
        super().__init__(**kwds)
    def draw(self):
        print('Drawing.  Setting shape to:', self.shapename)
        super().draw()

class ColoredShape(Shape):
    def __init__(self, color, **kwds):
        self.color = color
        super().__init__(**kwds)
    def draw(self):
        print('Drawing.  Setting color to:', self.color)
        super().draw()
```

当没有参数传入时，最简单的调用方法：

```python
# 其实有点像执行了 self = Root()，表明是父类的一个子类，并继承其所有的方法和属性。
super().__init__()
```
