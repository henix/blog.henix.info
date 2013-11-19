　　// 旧地址：[http://blog.csdn.net/shell_picker/archive/2010/09/17/5889851.aspx](http://blog.csdn.net/shell_picker/archive/2010/09/17/5889851.aspx)

　　看到最近技术宅是如此的火，比如 [Word 版 Only my railgun](http://v.youku.com/v_show/id_XMTM3Mjg5OTcy=.html)、[Vim 版 Bad Apple](http://v.youku.com/v_show/id_XMTQ0MjM4Nzg4.html)。我也来玩玩技术宅，装一下逼。。。

　　做出来的效果看这里（请用高清）：[http://v.youku.com/v_show/id_XMjA2OTgzMjcy.html](http://v.youku.com/v_show/id_XMjA2OTgzMjcy.html)

　　这个是原始视频：[http://v.youku.com/v_show/id_XMjIyNjcwMA==.html](http://v.youku.com/v_show/id_XMjIyNjcwMA==.html) 。另外顺便一提，我这个视频跟原始视频的同步是很精确的，你可以比较一下。

　　想到要玩就玩以前的人都没有搞过的，所以我想到了用 [AutoHotKey](http://www.autohotkey.com/) 通吃任意文本编辑器。基本原理是先把视频中的每一帧抓下来保存成图片，再使用 [aview](http://aa-project.sourceforge.net/aview)（cygwin 里有 Windows 版）将图片转换成字符，这个直接参考了七星庐大神的攻略：[http://qixinglu.com/archives/vim_is_ascii_player](http://qixinglu.com/archives/vim_is_ascii_player) 。

<p class="center">#{= makeImg('/files/qq-ascii-video.gif') }#</p>

　　然后一段很简单的 AutoHotKey 脚本：

#{= highlight([=[
#b::
Loop, read, files.txt
{
    FileRead, Clipboard, %A_LoopReadLine%
    if not ErrorLevel
    {
        Send ^v
        Sleep 37
    }
}
return
]=], 'ahk')}#

　　每一帧图像都存到一个文件里，这些文件的名字存到 files.txt 里面。再在 AutoHotKey 中把每个文件的内容读到剪贴板里，然后每隔 37 毫秒向程序发送 Ctrl+V 。这个 37 是个经验值，是试出来的，对应于 18fps 的视频。

　　其他就是 mplayer 可以直接输出 pnm 格式的图片：

#{= highlight([=[
mplayer -vo pnm:outdir=xop18 X3-1.mp4
]=], 'bash')}#

　　其实 pnm -&gt; txt 这个过程可以写个 Makefile 然后 make -j3 多线程并行转换，只不过懒得写了，直接用 [start 命令](http://technet.microsoft.com/zh-cn/library/cc755674%28WS.10%29.aspx)实现多进程。
