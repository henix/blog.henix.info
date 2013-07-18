% 列出某文件夹下所有子文件夹占用的空间大小
% Windows; cmd.exe; sed; Windows
% 1298527253

　　当我发现某个磁盘的空间不够的时候，就想手动整理一下这块盘，看看那些文件是不必要的，把它们删除或者把旧的文件压缩。

　　但是在整理之前，最好先看一下哪个文件夹是最占用空间的，这样才能最大限度地释放空间。在 Linux 下我们可以用 du 命令，Windows 下也可以用 du ：

```bat
dir /ad /b | sed -e "s/\(.*\)/""\1""""/" | xargs du -hs
```

　　这条命令首先通过 dir 列出所有的子目录，再用 sed 把每个目录名用双引号引起来，因为目录名可能包含空格（这里的双引号纠结得蛋疼，其实我要把这个命令发出来，多半是怕我以后忘了这里的双引号是怎么写出来的），最后用 xargs 把它们作为参数传给 du 。

　　运行结果：

```
C:\>dir /ad /b | sed -e "s/\(.*\)/""\1""""/" | xargs du -hs
40K     $RECYCLE.BIN
13M     Boot
92M     cygwin
4.0K    Documents and Settings
104M    MinGW
8.1M    msys
0       PerfLogs
1.1G    Program Files
956M    ProgramData
53M     Python27
186M    Recovery
4.0K    System Volume Information
2.8G    Users
8.2G    Windows
497M    wxMSW-2.8.11
```

　　这样我们就可以瞅准占用空间最多的文件夹进行整理了。

　　这么一条命令真可称得上怪异：既用到了 Windows 的 dir ，又用到了 Linux 的 xargs du 等。要想运行它，你需要安装 [GnuWin32](http://gnuwin32.sourceforge.net/) 的 [CoreUtils](http://gnuwin32.sourceforge.net/packages/coreutils.htm) 、[FindUtils](http://gnuwin32.sourceforge.net/packages/findutils.htm) 和 [Sed]("http://gnuwin32.sourceforge.net/packages/sed.htm") 。
