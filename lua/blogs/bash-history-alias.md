　　我们经常喜欢在 bash 中定义 alias 或者写一些小函数，以自动化某些常见任务。但这就有一个问题：哪些命令最需要定义成 alias？

　　考虑两个因素：

1. 命令使用的频率
2. 命令的长度

　　显然，一条命令被使用的次数越多，长度越长（需要输入的内容越多），这个命令越有必要定义一个更短的“快捷方式”，以减少击键次数。

　　比如，我的 .bash_history 中，“startx”出现了 9 次，如果我定义一个 alias x='startx' ，这样我每次用 x 来启动 X11 ，每次可以减少 5 次按键，累计减少 45 次按键。

　　所以我自然就想到了写一个脚本来统计。排序的依据是：命令频度系数 = 命令出现的次数 * 命令的长度。也就是把这条命令定义成 alias 后，所能节约的按键次数的期望。

## 改进：命令前缀

　　这个方案帮助我发现了诸如 alias g='git status' 和 alias gd='git diff' 之类的可以定义成 alias 的命令。但用了一段时间后我发现了一个不太令人满意的地方：

　　我最初的做法是把一个命令当成整体进行计算频度系数的。但有些时候，命令需要被拆开分析。举例：

```
git commit -m "foo1"
git commit -m "foo2"
git commit -m "bar1"
git commit -m "bar2"
```

　　按照原来的方案，这些命令都被视为不同的，每个命令都只出现了一次。但是，我希望提取出它们的公共前缀“git commit -m”。所以解决方案是，对每个命令，先得到其所有“命令前缀”。比如 git commit -m "foo" 的所有“命令前缀”为：

```
git
git commit
git commit -m
git commit -m "foo"
```

　　然后再把这些东西按照频度系数排序。

## 结果

　　用上面的方法分析我的 bash_history 之后我发现我 git 相关命令使用频繁很高，按键又多，故定义 alias 如下：

#{= highlight([=[
alias g='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias gp='git push origin master'
alias ga='git add'
alias gcm='git commit -m'
]=], 'bash')}#

　　另外一些我个人使用频率很高的命令：

#{= highlight([=[
alias oe='/opt/eclipse/eclipse &'
alias n='cd ~/notes'
alias mp='mvn package'
]=], 'bash')}#

## 代码

　　上面的代码实现我放在 [https://github.com/henix/aliaswho](https://github.com/henix/aliaswho) 。用 Haskell 写的，很乱。因为当时正好在学 Haskell 就练练手，下次写的话也许用其他语言了。

PS. 虽然有些人用一些网站，如 [alias.sh](http://alias.sh/) 。但是，适合自己的优化才是最好的。这就跟优化程序之前要 profile 一样。这套方案相当于对你的 shell 操作进行 profile 。

PS2. 这个问题的本质应该跟信息论和 Huffman 编码有关：出现频率越高的东西的信息熵越低，所以应该使用越短的编码。
