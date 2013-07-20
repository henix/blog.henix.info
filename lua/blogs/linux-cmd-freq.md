　　我们经常喜欢在 bash 中定义 alias 或者写一些小脚本，以自动化某些常见任务。但这就有一个问题：哪些命令最需要定义成 alias？

　　考虑两个因素：

1. 命令使用的频率
2. 命令的长度

　　显然，一条命令被使用的次数越多，长度越长（需要输入的内容越多），这个命令越有必要定义一个更短的“快捷方式”，以减少击键次数。

　　比如，我的 .bash_history 中，“startx”出现了 9 次，如果我定义一个 alias x='startx' ，这样我每次用 x 来启动 X11 ，每次可以减少 5 次按键，累计减少 45 次按键。

　　所以我自然就想到了写一个脚本来统计。排序的依据是：命令频度系数 = 命令出现的次数 * 命令的长度。当然，我们也可以用更复杂的信息论的方法（信息熵/哈夫曼编码？有兴趣的同学可以研究一下）来定义这个频度系数，但对于这种简单的任务，这个定义已经够用了。

　　reducewhat.py：我应该减少哪个？

#{= highlight([=[
#!/usr/bin/python2
import sys
import re

records = []
for line in sys.stdin:
	records.append(re.match(r'[ ]*(\d)+ ([^ ]+)(.*)', line.rstrip()).groups())

for record in sorted(records, key=lambda d:int(d[0])*(len(d[1])+len(d[2])), reverse=True):
	print "%s %s%s" % record
]=], 'python', {lineno=true})}#

　　然后可以有两种调用方式：

　　统计整个命令行：

#{= highlight([=[
sed '/^$/d' .bash_history | sort | uniq -c | ./reducewhat.py
]=], 'bash')}#

　　只统计“命令”部分：

#{= highlight([=[
sed '/^$/d' .bash_history | awk '{print $1}' | sort | uniq -c | ./reducewhat.py
]=], 'bash')}#

　　sed 的作用是除去空行，否则后面的 python 脚本可能出错
