　　最近遇到这样的问题：只有用 Cygwin 编译出来的静态库（.a），需要转换成可以在 VC++ 中调用 .dll 和 .lib 。

　　网上大多说的是 dll 怎么生成 .lib 什么的，跟我要的不一样。所以我自己想了这么一种办法：

1. 先用 ar 将 .a 中的所有 .o 文件解出来：

		ar x libatlas.a

2. 使用 MinGW 的 --export-all-symbols 选项，链接成 dll ，并导出所有符号：

		gcc -shared -o atlas.dll *.o -Wl,--export-all-symbols,--output-def,atlas.def

3. 使用 VC++ 自带的 lib 命令制作 .lib（需要上一步的 .def 文件）：

		lib /machine:i386 /def:atlas.def

Links:

* [http://www.mingw.org/wiki/MSVC_and_MinGW_DLLs](http://www.mingw.org/wiki/MSVC_and_MinGW_DLLs)
