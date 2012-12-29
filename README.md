henix 的技术博客：[http://blog.henix.info/](http://blog.henix.info/)

一个 lua 的静态站点生成器。

## Features

* 文章点击量（使用 Google Analytics 统计）
* 文章评论数（使用 Disqus 统计）
* 热门文章
* 相关文章（根据标签）

## Dependency

### lua

* lxp : XML parser
* [slt2](https://github.com/henix/slt2) : Lua 模板

### js

* [flower-widgets](https://github.com/henix/flower-widgets) : js UI 库
* [flower.js](https://github.com/henix/flower.js)
* [rainy](https://github.com/henix/rainy) : js 依赖管理

## Build

```bash
cd lua
# 从 ga 下载点击量 csv
# 从 disqus 导出评论 xml
make # 生成点击量和评论数据
./gen.lua # 生成的东西放在 static
```

## Run

	lighttpd -D -f lighttpd.conf
