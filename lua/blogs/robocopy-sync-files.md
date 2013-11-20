　　最近做这个博客，需要将动态生成出来的网页拷贝到一个放静态文件的文件夹中。

　　我需要的是差异拷贝，或者说同步。也就是说， **只有更新过的文件才需要拷贝，如果某个文件被删除，那么目标文件夹中的对应文件也应该被删除** 。

　　想到同步，自然就想到 rsync，但那玩意儿是 Linux 下的，Windows下得用 Cygwin。Cygwin 搞了半天又嫌太麻烦，于是找了一下 Windows 原生的，结果还真找到了这样的东西—— Robocopy 。

　　[Robocopy](http://en.wikipedia.org/wiki/Robocopy) 早在 NT 4.0 就包含在 Windows Resource Kit 中，在 Vista 和 Win7 是直接包含在系统中的。

使用方法：

	robocopy 源文件夹 目标文件夹 [文件名patterns] /mir

　　选择源文件夹中的那些文件并同步到目标文件夹中。目标文件夹会变得跟源文件夹一模一样，多余的文件会被删除，只有更新过的文件才被复制。

　　robocopy 还可以实现 **实时监控、实时备份** ：

	/MON:n :: 监视源；发现多于 n 个更改时再次运行。
	/MOT:m :: 监视源；如果更改，在 m 分钟时间内再次运行。

　　我使用的命令是：

	robocopy E:\... F:\... /XF *.swp /mir /mot:1

　　这样 robocopy 会一直运行，只能用 Ctrl-C 终止。每发现一个更改在一分钟之内就备份。XF 指定不需要备份的文件，这里的 \*.swp 是 gVim 生成的临时文件。
