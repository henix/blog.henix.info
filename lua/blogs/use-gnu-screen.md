% GNU Screen 初探
% Linux; Linux; shell; screen
% 1298651039

　　用 Linux 一直都有个问题：屏幕太大，黑漆漆的，那么多空间都浪费了。如果 tty 下也可以像 vim 一样，split/vsplit，那该多好啊。。

　　最近发现了 [screen](http://www.gnu.org/software/screen/) 这个神器，可以实现以上功能，对控制台作水平分割，让空间得到充分利用。还可以一边用 vim 编代码，一边 make（虽然 vim 可以运行 shell 命令，但我觉得不爽）。简直就是命令行下的瓦片式窗口管理器。

　　有图有真相：

#{= makeImg('/files/use-gnu-screen/gnu-screen.png') }#

　　screen 的控制命令都以 C-a 开头，常用命令（来自 man screen）：

* 水平分割：C-a S
* 创建窗口：C-a c
* 选择窗口：C-a [0-9] 或 C-a n/p/space 选择上一个/下一个
* 在 region 间切换：C-a tab
* 杀掉当前 region ：C-a X
* resize region：C-a :resize -5
* 退出当前窗口：exit
* 退出并关闭所有窗口：C-a \
