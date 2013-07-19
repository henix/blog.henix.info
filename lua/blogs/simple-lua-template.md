　　[slt](http://code.google.com/p/slt/)（Simple Lua Template）是一个 Lua 模板引擎。模板引擎类似 printf 的格式化字符串，根据一个模板，将一些变量“串行化”成一段文本，不过功能更强大，通常用来生成 HTML 页面。

　　一般的模板引擎应该实现的功能有：

* 分支条件
* 循环，可以遍历列表
* 包含文件
* ……

　　我接触到的第一个模板引擎是 Java 的 [FreeMarker](http://freemarker.sourceforge.net/) ，发现这东西可以取代 JSP 。

　　slt 是我在编写这个 blog 的过程中开发的，我使用 Lua 作为这个 blog 的开发语言，自然需要一个 Lua 的模板引擎。但现有的模板引擎感觉都太复杂。

* Kepler 的 [Cosmo](http://cosmo.luaforge.net/) ：用法太复杂，模板、子模板，不知道什么意思。
* [ltp](http://www.savarese.com/software/ltp/) ：感觉上可以用，但要用一套专门的命令。
* [leslie](http://code.google.com/p/leslie/) ：Django 风格的模板，自己实现了 if/for/include ，Lua 的模板干嘛要像 Django 一样？

　　Simple Lua Template 的想法很简单。就像 jsp 可以在 HTML 中嵌入 Java 代码一样，或者像 PHP 的风格一样，slt 就是在 HTML 中嵌入 Lua 代码。

```html
<span>
#{ if user ~= nil then }
  Hello, #{= user.name }!
#{ else }
  <a href="/login">login</a>
#{ end }
</span>
#{include: 'footer.seg.htm' }
```

　　我认为这样就够用了，也够简单。欢迎试用，欢迎提建议：[http://code.google.com/p/slt/](http://code.google.com/p/slt/) 。
