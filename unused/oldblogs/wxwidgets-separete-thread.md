　　有时候我们可能需要在非主线程中使用 wxWidgets 创建 GUI ：由主线程启动 GUI 线程，再在 GUI 线程中创建窗口，然后主线程等待一些事件的发生，当事件发生时由主线程通知更新 GUI 。

　　但对 wxWidgets 来说还需要一些额外的技巧：因为 wxWidgets 默认使用 IMPLEMENT_APP 宏来生成 main 函数，并在 main 函数里进入 Mainloop ，而这些我们自己不能控制。但在非主线程中使用 wxWidgets ，必须由我们自己控制何时进入 Mainloop 。

　　在网上查了不少资料，最后看了下 wxWidgets 的头文件，发现了这样的解决办法：

1. 首先，wxWidgets 有个 IMPLEMENT_APP_NO_MAIN 宏可以替代 IMPLEMENT_APP 。这个宏不会声明 main 函数，但仍会完成必要的全局变量的声明。这个我是在 wx/app.h 中发现的。必须放在 .cpp 文件中。
2. 在子线程中，调用 wxEntry(argc, argv) 就可以立即进入 Mainloop 。
3. 但在调用 wxEntry 之前，由于没有使用 wxWidgets 自带的初始化，所以必须自己用 wxInitialize(argc, argv) 初始化，否则会报错。

　　在使用过程中，我的经验是，主线程中不能进行 sizer 相关的操作，不能添加控件，否则会死锁，原因不明，不知道是不是因为没有加锁。目前我只有一种解决办法：先在 GUI 线程中创建好所有 widgets ，然后在主线程中用 SetLabel 等函数更新。

　　最后，现在 Windows 上编译 wxWidgets 也简单了，直接在 msys 里：

```
mkdir msysbuild
cd msysbuild
../configure --with-msw --disable-debug --disable-shared
make
make install
```

　　有了 MSys 很多开源软件的编译都变得简单了~

Links:

* [http://www.cnblogs.com/BAKER_LEE/articles/1961544.html](http://www.cnblogs.com/BAKER_LEE/articles/1961544.html)
* [http://stackoverflow.com/questions/208373/wxwidgets-how-to-initialize-wxapp-without-using-macros-and-without-entering-the](http://stackoverflow.com/questions/208373/wxwidgets-how-to-initialize-wxapp-without-using-macros-and-without-entering-the)
