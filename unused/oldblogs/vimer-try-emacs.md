　　最近开始尝试另一个文本编辑器 emacs 。对于一个会 vim 的人来说最大的障碍当然是克服 vim 对我的诱惑：“这个用 vim 一下不就搞定了！Emacs 怎么这么复杂？”

　　我一上来敲的第一条命令就是“vim ~/.emacs”……为了对 Emacs 表示补偿，我决定在学会 Emacs 后干的第一件事是“emacs ~/.vimrc”……

　　事实上，早在我试用 Emacs 之前，我觉得 Emacs 的一个快捷键十分趁手，这就是 Alt-Backspace 删除最后一个单词。这个快捷键我最早是在 bash 中学到的，后来发现原来 bash 也是学 emacs 的。然后我在 vimrc 中定义了一个 map ，因为我想在 vim 中也用这个快捷键（注：终端下 alt 键会映射成 ESC）：

#{= highlight([=[
" set Alt-Backspace works like Emacs
imap <ESC><BS> <ESC>vbdi
]=], 'txt')}#

　　在 gvimrc 中的定义是：

#{= highlight([=[
imap <M-BS> <ESC>vbdi
]=], 'txt')}#

　　我对 Alt-Backspace 是有多热爱！现在我每个使用这个键 10 次以上，在 bash 、vim 、和 emacs 中……

　　回到正题。首先要弄的是 [SmartTabs](http://www.emacswiki.org/SmartTabs) 。之前用不惯 Emacs 以至于放弃就是因为它的 tab 配置跟 vim 相比太奇葩了，尤其是对于我这种喜欢用 \t（而不是空格）缩进的人，Emacs 总是强制用空格缩进。用了 SmartTab 之后要好些，但有时仍不免用 Ctrl-q tab 手动插入 tab 。

　　然后就是各种插件了。因为已经有了 vim 的经验，文本编辑器中的概念（concept）是相通的，比如自动补全（auto-complete）、代码模板（code snippets）等等，搜索起来也就容易了。下面是 Vim 和 Emacs 的插件的大致比较：

### 1. load-path

　　这个要先说因为这个影响到所有插件的安装。装载路径就是一个自定义的路径，vim/emacs 会到这些地方去找脚本。

* vim: 自带，用 pathogen 可以很方便的管理
* emacs: 自带 (add-to-list 'load-path "~/")

### 2. 自动补全（Auto complete）

　　自动补全一般分两种：要做语法分析的和不做语法分析的（利用当前文件 token 、语言的关键词列表等）。非语法类：

* vim: autocomplpop, neocomplcache
* emacs: hippie-expand, [auto-complete](http://cx4a.org/software/auto-complete/)

　　我的 hippie-expand 配置（貌似是很早之前从网上看的）：

#{= highlight([=[
; hippie-expand
(global-set-key "\M-/" 'hippie-expand)

(setq hippie-expand-try-functions-list
	'(try-expand-dabbrev-visible
		 try-expand-dabbrev-visible
		 try-expand-dabbrev-all-buffers
		 try-expand-dabbrev-from-kill
		 try-complete-file-name-partially
		 try-complete-file-name
		 try-expand-all-abbrevs
		 try-expand-list
		 try-expand-line
		 try-complete-lisp-symbol-partially
		 try-complete-lisp-symbol
		 )
	)
]=], 'lisp', {lineno=true})}#

　　然后用 M-/ 触发补全。

　　基于语法的自动补全：

* vim: clang_complete
* emacs: auto-complete-clang, gccsense

### 3. 代码模板（Code snippets）

　　基本想法跟缩写词（abbrev）是一样的，我们平时有很多小的经常出现的代码片段

* vim: ultisnip
* emacs: yasnippet

### 4. 语法检查（syntax check）

　　这类插件可以说是 life changing ，一旦用过就离不开了。原理是在编辑某语言的文件时，编辑器调用该语言 complier 进行编译，并把 compiler 输出的错误直接标在对应的行上。随时检查错误，这样你编辑完一个文件，基本上就是没有语法错误的了。

* vim: syntastic：每次保存文件的时候进行编译
* emacs: flymake（emacs 自带）：编译的时机有一套复杂的算法，貌似是空闲之后 5s

　　现在我用这个检查 js ：[https://github.com/jegbjerg/flymake-node-jshint](https://github.com/jegbjerg/flymake-node-jshint)

### 5. 文件查找和浏览

* vim: ctrlp, nerdtree
* emacs: C-x C-f??

　　然后还有 color-theme 和 emacs 的特定语言的 mode 如 nxhtml 、js2-mode 、[lua-mode](http://immerrr.github.com/lua-mode/) 和 markdown-mode 等，以及为了使用输入法而 alias emacs='LC_CTYPE=zh_CN.utf8 emacs' 。现在我基本上在 emacs 中 survive 了。

### 参考

* [My Emacs Python environment « SaltyCrane Blog](http://www.saltycrane.com/blog/2010/05/my-emacs-python-environment/)
