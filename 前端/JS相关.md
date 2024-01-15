## JavaScript

#### **1.说说JavaScript 中的数据类型？存储上的差别？**

基本数据类型：number, string, boolean, bigInt, symbol, null, undefined 存储在栈上

引用数据类型： Object 存储在堆上

#### **2. 解释下什么是事件代理？**

通俗的讲就是把一个元素的响应事件(click, onMouse)委托到另一个元素上。

事件代理就是利用事件冒泡，只指定一个事件处理程序，就可以管理某一类型的所有事件。

事件： 事件捕获 - 目标阶段 - 冒泡阶段

捕获阶段从下到上 body -> div -> button 目标阶段 button 冒泡阶段从上到下 button -> div -> body

通常我们不考虑捕获阶段， 如果要指定捕获阶段执行, 设置capture为true

```
btn.addEventListener('click', () => {}, {
    capture: true
})
```

假如我们有一个ul，想为每一个li添加事件，我们可以循环添加事件，例如

```
<ul id="ul">
    <li>a</li>
    <li>b</li>
    <li>c</li>
    <li>d</li>
</ul>
let ul = document.getElementById('ul');
let lis = ul.getElementsByTagName('li');
for (let i = 0; i < lis.length; i++) {
    lis[i].addEventListener('click', function () {
       alert('123')
    })
}
```

但是这样我们每次都要先找到ul，遍历li，操作Dom，添加事件，这样会浪费性能。

我们可以利用时间委托，把所有的时间委托到ul上, 通过事件冒泡，从上到下 li -> ul, 在通过e.target.tagName区分当前点击的元素是li来实现同意的效果。

```
document.getElementById('ul').addEventListener('click', function (e) { 
    if (e.target.tagName.toLowerCase() === 'li') {
        alert('123')
    }
})
```

事件委托的好处： 1：减少界面所需要的内存，提升性能。 2：动态绑定，减少重复代码。

#### **3. 谈谈this对象的理解?**

在javaScript中，this是一个关键字，它表示一个对象，运行时绑定，this表示的对象取决于它的调用方式。

默认绑定， 显示绑定， new绑定， 隐私绑定。

箭头函数中this是静态的在编译时确定。

#### **4. 什么是堆，什么是栈，他们之间的有什么区别和联系？**

栈： 先进后出，可以想象一下储物箱，先放进去后拿出来 堆：申请/释放有优先级

栈：编译器自动分配释放 堆：由程序员手动管理

#### **5. null 和 undefined 的区别？**

首先null和undefined都是基本数锯类型， null表示空对象, undefined表示未定义

一般定义一个变量，未初始化会返回undefined， eg:

```
let  b
console.log(b)
```

null一般用于可以可以返回对象的变量作为初始化。

⚠️undefined不是一个保留字，不要定义let undefined = x

Typeof null == object

#### **6. 如何获取安全的 undefined 值？**

void 0 或者 void xxx

#### **7. JavaScript 类数组对象的定义？**

具有length属性的可迭代对象，但是不能调用数组的方法。常见的类数组对象有arguments， dom返回eg:
document.getElementsByTagName('div')

有哪些方法将类数组对象转成数组

1: 通过for循环

2: Array.form(obj)

3: Array.prototype.slice.call(obj)

4: 扩展运算符[...obj]

#### **8. 数组有哪些常见的操作？**

...

#### **9. 谈谈你对闭包的理解**
闭包是什么，首先闭包是一个函数。这个函数访问了上层作用域的变量。
正常函数在调用完成后，编译器会进行垃圾回收。 由于闭包捕获了上层作用的域的变量，保存对该环境中变量的引用，导致变量未被垃圾回收。可以继续访问。
利用这一特性，我们可以实现私有属性，柯里化函数等。

#### **10. 你可以手写一个柯里化函数吗？**
柯里化函数在数学或计算机科学中的应用是指
将一个使用多个参数的函数转换成一系列使用一个参数的函数
```
function curry(fn, args) {
   let length = fn.length;
   return function (...params) {
      let newArgs = [...args, ...params];
      // 收集剩余参数
      if (newArgs.length < length) {
         curry.call(this, fn, ...newArgs)
      }
      // 调用原函数
      fn.apply(this, newArgs);
   }
}
```
#### **11. 你能讲讲call， band, apply的区别吗?!**
首先call,band, apply都是一个方法，用于改变this的指向。
- 参数的区别
call 和 bind 可以传入多个参数，透过逗号分隔
apply 传入的是一个数组
- 执行的区别
call和apply 会调用函数
bind 会返回一个新的函数

#### **12. 你能手写call， band, apply方法吗？**
```
Function.prototype.myCall = function (context) {
   if (context === null || context === undefined) {
       context = window;
   } else {
       context = Object(context)
   }
   let fn = Symbol('uniqueFn')
   context[fn] = this
   // 获取参数
   let args = Array.prototype.slice.call(arguments, 1)
   let res = context[fn](...args)
   delete context[fn]
   return res
}

Function.prototype.myApply = function(context) {
   if (context === null || context === undefined) {
       context = window;
   } else {
       context = Object(context)
   }
   let fn = Symbol('uniqueFn')
   context[fn] = this
   // 获取参数
   let args = arguments[1]
    if (Array.isArray(args) || (args === null || args === undefined)) {
        let res = context[fn](...args || [])
        delete context[fn]
        return res
    } else {
        throw new TypeError('参数必须是数组')
    }
}

Function.prototype.bind = function(context) {
    if (typeof this !== "function") {
        throw new Error("必须是函数");
    }
    let self = this;
    let args = Array.prototype.slice.call(arguments, 1);
    let bind = function () {
        let bindArgs = Array.prototype.slice.call(arguments);
        const isNew = this instanceof bind;
        return self.apply(isNew ? this : context, args.concat(bindArgs));
    }
    if (self.prototype) {
        bind.prototype = Object.create(this.prototype);
    }
    return bind;
}

```
