% 用 tmux 分割终端
% Linux; Linux; shell; screen; tmux
% 1301319078

　　不久前介绍过 [GNU Screen](/blog/use-gnu-screen.html) ，不过 screen 的问题是只能水平分割，不能垂直分割。要垂直分割得装 vertial split patch。

　　偶然发现了 [tmux](http://tmux.sourceforge.net/) ，screen 的替代品，可以轻松实现垂直分割。

　　先上图：切成三个窗格，一边看 manpage ，一边用 vim ，还可以一边跑 make ：

#{= makeImg('/files/tmux-split-terminal/tmux.png') }#

使用方法：

先一个 tmux 进入，然后快捷键：

* 垂直分割：C-b %
* 水平分割：C-b "
* 杀掉当前的窗格(pane)：退出bash 或者 C-b x
* 移动焦点：C-b 方向键

以下是命令，在终端中运行：

* 往上下左右resize几行：tmux resize-pane -[DULR] 1

详见 man tmux 。
