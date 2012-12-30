henix 的技术博客：[http://blog.henix.info/](http://blog.henix.info/)

一个 lua 的静态站点生成器。

[新年第一贴/准备启用新博客](http://blog.henix.info/blog/new-year-new-blog.html)
[纯静态博客的实现](http://blog.henix.info/blog/my-static-blog.html) （注意到当时 jekyll 等还没开始流行）
[这个 blog 用到的一些算法](http://blog.henix.info/blog/blog-algorithms.html)

## Features

* 文章点击量（使用 Google Analytics 统计）
* 文章评论数（使用 Disqus 统计）
* 热门文章（根据评论数和点击量）
* 相关文章（根据标签）

* 数学公式（via MathJax） [MathJax: 在网页上显示 LaTeX 数学公式](http://blog.henix.info/blog/mathjax-render-latex-math-online.html)
* 代码高亮（via SyntaxHighlighter）

## Dependency

### lua

* lxp : XML parser
* [slt2](https://github.com/henix/slt2) : Lua 模板

### js

* [flower-widgets](https://github.com/henix/flower-widgets) : js UI 库
* [flower.js](https://github.com/henix/flower.js)
* [rainy](https://github.com/henix/rainy) : js 依赖管理

## Build

	cd lua
	# 从 ga 下载点击量 csv 并保存为 visits.2.csv
	# 从 disqus 导出评论 xml 并保存为 comments.xml
	make # 生成点击量和评论数据
	./gen.lua # 生成的东西放在 static

## Run

	lighttpd -D -f lighttpd.conf
	firefox http://localhost:8080/
