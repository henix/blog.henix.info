henix 的技术博客：[http://blog.henix.info/](http://blog.henix.info/)

一个使用 Makefile + Scala + lua + vala + github-markdown 的静态站点生成器。

* v1 完全用 lua 编写
* v2 重构为由 Makefile 粘合的各种语言大杂烩 [采用 Makefile 重构](https://github.com/henix/blog.henix.info/issues/5)
* v3 在 Makefile 的基础上将高内聚的计算部分迁移到 Scala [用 Scala 重构](https://github.com/henix/blog.henix.info/issues/9)

* [新年第一贴/准备启用新博客](http://blog.henix.info/blog/new-year-new-blog.html)
* [纯静态博客的实现](http://blog.henix.info/blog/my-static-blog.html) （注意到当时 jekyll 等还没开始流行）
* [这个 blog 用到的一些算法](http://blog.henix.info/blog/blog-algorithms.html)

## Features

### 内容

* <del>文章点击量（使用 Google Analytics 统计）</del> [在首页添加最新评论](https://github.com/henix/blog.henix.info/issues/2)
* 文章评论数（使用 Disqus 统计）
* 热门文章（根据评论数和点击量）
* 相关文章（根据标签）

### 呈现

* 数学公式（via MathJax） [MathJax: 在网页上显示 LaTeX 数学公式](http://blog.henix.info/blog/mathjax-render-latex-math-online.html)
* 代码高亮（via [highlight](https://github.com/henix/blog.henix.info/issues/4)）

### 设计

* 每篇文章没有“上一篇”、“下一篇”的导航，首页不按时间排列而按照分类排列。这是我的“去 timeline 化”设计：[为什么 timeline 不一定是组织信息的最佳方式](http://blog.henix.info/blog/why-not-timeline.html)
* 根据客户端时间自动切换样式表（一套白天样式、一套晚上样式）
* 禁止 iframe（防 ISP 插广告）

## Dependency

### Scala

* 需要安装 scala
* commons-io 2.4

### lua

* lxp : XML parser
* [slt2](https://github.com/henix/slt2) : Lua 模板

### js

* [flower-widgets](https://github.com/henix/flower-widgets) : js UI 库
* [flower.js](https://github.com/henix/flower.js)
* [rainy](https://github.com/henix/rainy) : js 依赖管理

### vala

需要安装 vala 编译器

### github-markdown

详见这个 issue：[后端渲染引擎采用 pandoc](https://github.com/henix/blog.henix.info/issues/7)

安装 github-markdown 并把 gfm 所在的目录加入 $PATH

## Build

	cd lua
	# 从 disqus 导出评论 xml 并保存为 comments.xml
	make runscala
	make
	make -j3 allposts alltags
	./sync.sh

## Run

	lighttpd -D -f lighttpd.conf
	firefox http://localhost:8080/
