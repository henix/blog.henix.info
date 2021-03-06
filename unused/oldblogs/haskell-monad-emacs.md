### Monad

　　Monad 就是一个悬着的 IO（计算）动作，举例：

#{= highlight([=[
main = foldr (\m ms -> m >>= return) (return ()) (map putStrLn ["1", "2"])
]=], 'haskell') }#

　　这里 foldr 故意只使用了第一个参数。

　　输出：1

　　当 map putStrLn 的时候，IO 还没有发生。直到 foldr 执行 return ，列表中的第一个 IO 才真正发生。另外，从这个例子也可以看出，foldr 的执行是 lazy 的，如果只用到了第一个值，那么后面的整个列表都不会被求值。这也是为什么 sequence 函数用 foldr 实现，但求值顺序是从左到右。

　　哪些东西能强迫 IO 发生？

1. `>>=` `>>` `sequence` `sequence_` `mapM` `mapM_` （`>>=` 和 `>>` 都只是强迫第一个 IO 发生，余类推）
2. 从 main 函数返回的是一个 IO () 。返回的时候 IO 还没有发生，返回之后，Haskell 运行时会让最后返回的那个 IO 发生。

　　IO Monad 就像一个“脏”标记，一旦被打上这个标记，就没办法把它去掉了。副作用就像洪水猛兽，必须用 Monad 把它们隔离开。

### 管道操作符

　　让函数应用顺序跟书写顺序一样从左到右。

　　定义：

#{= highlight([=[
infixl 9 |>
(|>) = flip (.) -- 反向的 function composition

infixl 0 ||>
(||>) = flip ($) -- 反向的 function application
]=], 'haskell') }#

　　使用：

#{= highlight([=[
main = ["1", ";2"] ||> (map putStrLn) |> (foldr (\m ms -> m >>= return) (return ()))
]=], 'haskell') }#

### Haskell 的 Emacs 配置

　　Emacs 在函数式语言的支持上的确比 Vim 好，所以我现在写函数式语言的时候用 Emacs ，写命令式语言用 Vim 。而且函数式语言的源码全是表达式，的确没办法用 tab 缩进，我以前一直坚持用 tab 缩进，现在我写函数式语言程序的时候用空格。

　　主要参考 [http://www.haskell.org/haskellwiki/Haskell_mode_for_Emacs](http://www.haskell.org/haskellwiki/Haskell_mode_for_Emacs)

1\. 安装 haskell-mode

	git clone https://github.com/haskell/haskell-mode

　　我用的手动方式。

　　安装后跟 flymake 还是不能正确配合，所以需要下面的。

2. 安装 ghc-mod

	cabal install ghc-mod

　　中间 haskell-src-exts-1.13.5 抱怨说找不到 happy ，一个 Haskell 的 parser generator 。于是 cabal install happy ，然后把 ~/.cabal/bin 导出 PATH ，archlinux 上的方法是创建 /etc/profile.d/cabal.sh：

	PATH=$PATH:~/.cabal/bin
	export PATH

　　然后 ghc-mod 就装好了。

　　然后按照 [http://www.mew.org/~kazu/proj/ghc-mod/en/install.html](http://www.mew.org/~kazu/proj/ghc-mod/en/install.html) 编译 ghc-mod ，修改 .emacs 即可。

　　编辑时打开 flymake-mode ，可以实时显示语法错误和 warnings 。
