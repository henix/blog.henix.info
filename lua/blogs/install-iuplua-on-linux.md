% 在 Linux 上安装 iuplua
% Lua; Lua; IUP; Linux
% 1300348540

由于我的 Linux 发行版（[Arch Linux](http://www.archlinux.org/)）不包含 [iuplua](http://www.tecgraf.puc-rio.br/iup/) ，所以我不得不自己下载安装：

1. 从 <a href="http://sourceforge.net/projects/iup/files/">http://sourceforge.net/projects/iup/files/</a> 下载
2. 解压后，看 install ，那是个 shell script

我看 install 这个脚本的大意是，把 *.so copy 到 /usr/lib/lua/5.1 。

实际的安装过程如下：

1. 首先确定你的系统库的位置，可能是 /usr/lib 或者 /usr/lib64 ，我的是 /usr/lib
2. mv libiuplua*.so /usr/lib/lua/5.1 # 这部分库是由 lua 直接调用的
3. mv libiup*.so /usr/lib # 注意这部分库的名字中不包含 lua ，由上面的库调用
4. cd /usr/lib/lua/5.1<br />
ln -sv libiuplua*51.so iuplua*.so # 把 51 结尾的库文件符号链接到不含 51 的 .so
