　　在一般情况下，Lua 的随机数可以工作得很好。但我最近做的一个程序是这样的：程序会多次启动，每次随机选择一条记录。代码：

#{= highlight([=[
math.randomseed(os.time())
x = math.random()
]=], 'lua')}#

　　结果是：x 与时间呈完全的正相关。比如我隔一秒再运行这个程序，x 正好比上一次大 1 。这样的随机数显然并不能用。

　　在 lua users wiki 上找到了关于这个问题的说明，就是说，至少在 Windows 上，第一个随机数不是那么随机。解决办法是：

#{= highlight([=[
math.randomseed(os.time())
math.random(); math.random(); math.random()
]=], 'lua')}#

　　先“弹出”前面几个随机数，用后面的就要好多了。

Links:

* [http://lua-users.org/wiki/MathLibraryTutorial](http://lua-users.org/wiki/MathLibraryTutorial)
