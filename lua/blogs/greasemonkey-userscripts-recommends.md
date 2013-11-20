* [Google Real Link](http://userscripts.org/scripts/show/125473)

	觉得 Google 搜索的重定向很烦？这个脚本可以让 Google 的搜索结果不包含重定向，点击链接直接到对应网站。

* [t.co Bypasser[modified]](http://userscripts.org/scripts/show/126245)

	让 twitter 上的短地址不再经过 t.co 。

下面是我开发的 userscripts（当然也都在用）：

* [NoBrighter](http://userscripts.org/scripts/show/138275)

	将太亮的页面元素改成淡绿色，避免刺眼。

* [Douban Timeline Marker](http://userscripts.org/scripts/show/125728)

	为豆瓣的友邻广播增加一个书签，下次就很容易找到上次看到哪儿了。

* [Weibo Bookmark](http://userscripts.org/scripts/show/126882)

	为微博增加一个书签，功能同上。

### 什么是油猴脚本，我为什么要用它？

　　扩展浏览器功能的方式，有这么几种：

* 各个浏览器的扩展（Extensions）或称插件（Plugins/Add-ons）：功能很强大，浏览器间不能通用
* 油猴脚本，或称 userscripts：就是一段 javascript ，当访问指定的网站时由浏览器加载，浏览器间可以通用
* bookmarklets：一段 javascript 直接保存在书签栏里，要用时手动点

　　可见油猴脚本具有很高的通用性，并且适用于那些需要跟目标网站一起加载的任务。

　　如果一个任务可以用 JavaScript 搞定，就可以写成油猴脚本或者 bookmarklets 而不需要浏览器插件。

### 如何安装油猴脚本？

* chrome：先安装 [Tampermonkey](http://tampermonkey.net/) 。
* firefox：先安装 [GreaseMonkey](https://addons.mozilla.org/zh-CN/firefox/addon/greasemonkey/) 。
* opera：打开 Settings -&gt; Advanced -&gt; Content -&gt; JavaScript Options -&gt; User JavaScript Folder 然后选择一个文件夹并把 userjs 放在那个文件夹下面。
