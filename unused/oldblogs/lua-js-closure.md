　　先看一段 js ：取名 addEventListener 是因为这种写法在为一组 DOM 对象添加事件时很常见，也就是，事件响应函数用到了该对象的序号，也就是这里的循环变量 i 。一个常见的场景是为一个 tab 控件的标签头添加鼠标点击事件。

#{= highlight([=[
function addEventListener() {
    var ret = [];
    for (var i = 1; i <= 10; i++) {
        ret.push(function() {
            return i;
        });
    }
    return ret;
}

var funcs = addEventListener();
for (var i = 0; i < funcs.length; i++) {
    console.log(funcs[i]());
}
]=], 'js', {lineno=true}) }#

　　结果是喜闻乐见的：10 个 11

　　为什么呢？因为在闭包中使用的 free variable i ，只保存了一个引用，而不是 i 在运行中的值。

　　再来看 lua 版：

#{= highlight([=[
function addEventListener()
    local ret = {}
    for i = 1, 10 do
        table.insert(ret, function()
            return i
        end)
    end
    return ret
end

local funcs = addEventListener()
for _, v in ipairs(funcs) do
    print(v())
end
]=], 'lua', {lineno=true}) }#

　　基本上是上面的 js 版的原样照抄。结果：1 2 3 4 5 6 7 8 9 10

　　为什么 lua 与 js 版的结果不同？为什么 lua 版的结果更符合直觉？

　　于是把 lua 版的 for 改成 while ：

#{= highlight([=[
function addEventListener()
    local ret = {}
    local i = 1
    while i <= 10 do
        table.insert(ret, function()
            return i
        end)
        i = i + 1
    end
    return ret
end

local funcs = addEventListener()
for _, v in ipairs(funcs) do
    print(v())
end
]=], 'lua', {lineno=true}) }#

　　结果：10 个 11

　　改成 while 了之后跟 js 一样，难道是 lua 对 for 做了什么特殊处理？

　　我们把 lua 的 while 改成下面的样子：

#{= highlight([=[
function addEventListener()
    local ret = {}
    local j = 1
    while j <= 10 do
        local i = j
        table.insert(ret, function()
            return i
        end)
        j = j + 1
    end
    return ret
end

local funcs = addEventListener()
for _, v in ipairs(funcs) do
    print(v())
end
]=], 'lua', {lineno=true}) }#

　　创建了一个局部变量，结果：1 2 3 4 5 6 7 8 9 10

　　可见，lua 的 for 就相当于 while ，只不过，对于循环计数器，lua 会每次都创建一个新的局部变量。

　　那么，把上面的 lua 的 trick 运用到 js 中，是不是就可以解决 js 的问题了呢：

#{= highlight([=[
function addEventListener() {
    var ret = [];
    for (var i = 1; i <= 10; i++) {
        var j = i;
        ret.push(function() {
            return j;
        });
    }
    return ret;
}

var funcs = addEventListener();
for (var i = 0; i < funcs.length; i++) {
    console.log(funcs[i]());
}
]=], 'js', {lineno=true}) }#

　　结果：10 个 10

　　这是由于 js 没有块级作用域，只有函数级作用域，var j 相当于在函数的最开头声明了一个变量 j ，所以这个 trick 在 js 中没用。

　　最终，我只能添加函数，创建一个作用域：

#{= highlight([=[
function addEventListener() {
    var ret = [];
    for (var i = 1; i <= 10; i++) {
        (function() {
            var j = i;
            ret.push(function() {
                return j;
            });
        })();
    }
    return ret;
}

var funcs = addEventListener();
for (var i = 0; i < funcs.length; i++) {
    console.log(funcs[i]());
}
]=], 'js', {lineno=true}) }#

　　结果：1 2 3 4 5 6 7 8 9 10

　　至此，终于把 lua 和 js 的闭包实现理清楚了，其实 js 和 lua 的闭包并没有太大的区别，区别只在 js 没有块级作用域上。

　　P.S. 后来我才发现，python、php 和 js 一样，都只有函数级作用域，没有块级作用域。lua 可算是脚本语言中的一朵奇葩了。
