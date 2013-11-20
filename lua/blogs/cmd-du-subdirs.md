　　当我发现某个磁盘的空间不够的时候，就想手动整理一下这块盘，看看那些文件是不必要的，把它们删除或者把旧的文件压缩。

　　但是在整理之前，最好先看一下哪个文件夹是最占用空间的，这样才能最大限度地释放空间。在 Linux 下我们可以用 du 命令，Windows 下也可以用 du ：

#{= highlight([=[
for /F "tokens=*" %i in ('dir /ad /b') do @echo "%i" | xargs du -hs | sort -k 1hr | head -n 20
]=], 'bat')}#

　　这条命令首先通过 dir 列出所有的子目录，再用 for 把每个目录名用双引号引起来，因为目录名可能包含空格，然后用 xargs 把它们作为参数传给 du 。最后用 sort 排序和 head 输出前 20 条。

　　运行结果：

```
C:\Users\Administrator>for /F "tokens=*" %i in ('dir /ad /b') do @echo "%i" | xargs du -hs | sort -k 1hr | head -n 20
3.0G    AppData
363M    Documents
8.7M    Music
4.8M    NTUSER.dat
2.2M    CMB
1.6M    Pictures
972K    fontconfig
768K    ntuser.dat.LOG1
582K    Desktop
```

　　这样我们就可以瞅准占用空间最多的文件夹进行整理了。

　　这么一条命令真可称得上怪异：既用到了 Windows 的 dir ，又用到了 Linux 的 xargs du 等。要想运行它，你需要安装 [GnuWin32](http://gnuwin32.sourceforge.net/) 的 [CoreUtils](http://gnuwin32.sourceforge.net/packages/coreutils.htm) 和 [FindUtils](http://gnuwin32.sourceforge.net/packages/findutils.htm)。

## 其他方案

　　安装 Cygwin：

#{= highlight([=[
du -hs $(ls -A) | sort -k 1hr | head -n 20
]=], 'bat')}#

　　小众软件推荐 [TreeSize Free](http://www.appinn.com/treesize/) ，但显然不如命令绿色。
