　　从官网上下下来的 wxWidgets 只有源代码，需要自己编译。

　　如何编译的问题全在源码包里的 INSTALL-MSW.txt 里写清楚了。命令样例：

```
make -f makefile.gcc BUILD=release SHARED=1
```

　　INSTALL-MSW.txt 的后面列出了一些编译选项：

* BUILD=debug/release ：编译 debug/release 版
* SHARED=0/1 ：编译成静态库/DLL
* UNICODE=0/1 ：启用 Unicode 支持
* VENDOR= ：可以指定一个自定义的名字，出来的 dll 会带有这个名字
* USE_OPENGL=0/1 ：是否编译 OpenGL 模块。为了启用 wxGLCanvas ，你还需要修改 setup.h

　　库编译好了之后，第二个问题就是如何编译使用 wxWidgets 的程序。在 Linux 中我们可以用 wx-config ，Windows 下有个 wx-config-win ：

* [http://wiki.wxwidgets.org/Wx-config_Windows_port](http://wiki.wxwidgets.org/Wx-config_Windows_port)
* [http://sites.google.com/site/wxconfig/](http://sites.google.com/site/wxconfig/)
* [http://code.google.com/p/wx-config-win/](http://code.google.com/p/wx-config-win/)

　　然后 wx-config --cxxflags 、wx-config --libs 即可。我的编译选项：

> -mthreads -DHAVE_W32API_H -D__WXMSW__ -IC:\wxMSW-2.8.12\lib\gcc_dll\msw -IC:\wxMSW-2.8.12\include -DWXUSINGDLL -Wno-ctor-dtor-privacy -pipe -fmessage-length=0

　　链接选项：

> -mthreads -LC:\wxMSW-2.8.12\lib\gcc_dll -lwxmsw28_html -lwxmsw28_adv -lwxmsw28_core -lwxbase28_xml -lwxbase28_net -lwxbase28 -lwxtiff -lwxjpeg -lwxpng -lwxzlib -lwxregex -lwxexpat -lkernel32 -luser32 -lgdi32 -lcomdlg32 -lwxregex -lwinspool -lwinmm -lshell32 -lcomctl32 -lole32 -loleaut32 -luuid -lrpcrt4 -ladvapi32 -lwsock32
