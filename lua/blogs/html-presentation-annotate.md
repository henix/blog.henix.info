　　annotate 的意思是做 presentation 的时候可以用鼠标在上面画线，ppt 中对应的功能叫“笔指针”，用文字描述太麻烦了，还是看这篇文章吧：[用powerpoint的笔指针绘画和书写](http://www.360doc.com/content/10/0406/11/927278_21802293.shtml)。个人认为这是一个很重要的功能，可以说是结合了 ppt 和传统的黑板/白板。

　　我想用 HTML 做 presentation 的时候也可以这样，这就需要在网页上用鼠标画图。

1\. 先转 pdf 再用 [PDF Presenter](http://sourceforge.net/projects/pdfpresenter/)

　　有时候不能完全转 pdf

2\. firefox 或 chrome 插件

　　找到一个 [Screen Draw](https://addons.mozilla.org/en-US/firefox/addon/screen-draw/) 。

3\. bookmarklets

* http://markup.io/ - 有时候加载之后会影响页面样式，特别是 file:// 的时候。加载速度太慢。
* http://drawhere.com/ - 打开后页面就不能动了。
* http://goggles.sneakygcr.net/ - 功能不错，还可以擦除。但如果在公开的页面（不是 file://）上打开的话会显示其他所有人画出来的笔迹，也就是说会记录你画的东西。
* http://eatponies.com/ - 它强调可以协作，但我不需要。
* http://scribblet.org/ - 不错，但是还是这个问题：一旦进入画图模式页面就不能动了。

　　这类中最好的选择：Goggles 、scribblet

4\. 自己用 Raphael 写一个 js 库

　　如果没有其他更好的选择的话。最好能实现笔迹与幻灯片的绑定，即：每张幻灯片都有自己的笔迹，切换幻灯片的时候笔迹也跟着换。

　　最终选择：Screen Draw 。
