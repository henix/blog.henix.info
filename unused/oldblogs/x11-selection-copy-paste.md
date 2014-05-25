　　在 Linux 中，你是如何复制粘贴的呢？

　　是不是也像在 Windows 中一样：选择一段文本 -> 右键 -> Copy -> 切到另一个程序 -> 右键 -> Paste ？

　　接触 Linux 这么多年来，我一直都是这么干的——偶尔也会有“如果像 Windows 一样可以 Ctrl-C Ctrl-V 就更好了”这种想法——Windows 的惯性思维让我中毒太深。

　　我今天才发现，我错了！我一直都没有发现 X11 的复制粘贴的精髓！

　　所以下面就是精髓了。在 X11 中，复制粘贴应该这么干：

1. 在一个程序中，选中一段文本
2. **什么也别动！**直接切换到你要粘贴的程序
3. 按下鼠标 **中键** ，粘贴进去了！

　　怎么样，是不是很 cool ？

　　在 X11 中，有两个剪贴板：PRIMARY 和 CLIPBOARD 。用鼠标中键的是 PRIMARY ，而通过菜单明确执行复制粘贴的是 CLIPBOARD 。鼠标中键也可以是 **Shift-Insert** 。

　　[xsel](http://www.kfish.org/software/xsel/) 这个小工具可以与剪贴板交互，查看或设置剪贴板的内容。

Links:

* [http://en.wikipedia.org/wiki/X_Window_selection](http://en.wikipedia.org/wiki/X_Window_selection)
