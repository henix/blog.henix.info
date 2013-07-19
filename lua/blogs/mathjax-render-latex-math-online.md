　　在网页上显示数学公式，以前我知道的有这几种方法：

1. W3C 的 [MathML](http://www.w3.org/Math/) -&gt; 只有少数浏览器支持，不同浏览器显示不一致，而且最关键的是：太丑
2. [mimetex](http://www.forkosh.com/mimetex.html) -&gt; 只能保存成图片，不能做成矢量图，制作 PDF 时效果较差

　　后来偶然在[班固米](http://bangumi.tv/group/topic/4527)上看到了 [MathJax](http://www.mathjax.org/) 这个神器：不但漂亮，而且使用 CSS 的 @font-face ，让出来的数学公式不是图片。我对班固米上的大神感到由衷地敬佩。。。

　　让我们先从那耳熟能详的求根公式开始：（可能速度比较慢，请耐心等待）

$x = \frac{-b\pm\sqrt{b^2-4ac}}{2a}$

　　然后，让我们看看高斯公式：

$\iiint_\Omega(\frac{\partial P}{\partial x}+\frac{\partial Q}{\partial y}+\frac{\partial R}{\partial z})dv=\oint_S Pdydz+Qdzdx+Rdxdy$

　　矩阵也是可以的：

$\left[\begin{array}{cccc}1&amp;x_1&amp;y_1&amp;z_1\\1&amp;x_2&amp;y_2&amp;z_2\\1&amp;x_3&amp;y_3&amp;z_3\\1&amp;x_4&amp;y_4&amp;z_4\end{array}\right]\left[\begin{array}{c}a_1\\a_2\\a_3\\a_4\end{array}\right]=\left[\begin{array}{c}T_1\\T_2\\T_3\\T_4\end{array}\right]$

　　下面是 LaTeX 公式常用符号 cheatsheet ：

1\. 希腊字母

<table style="width: 100%">
<tr><th>LaTex</th><th>显示效果</th></tr>
<tr><td>\alpha</td><td>\(\alpha\)</td></tr>
<tr><td>\beta</td><td>\(\beta\)</td></tr>
<tr><td>\gamma</td><td>\(\gamma\)</td></tr>
<tr><td>\delta</td><td>\(\delta\)</td></tr>
<tr><td>\omega</td><td>\(\omega\)</td></tr>
<tr><td>\rho</td><td>\(\rho\)</td></tr>
<tr><td>\tau</td><td>\(\tau\)</td></tr>
<tr><td>\lambda</td><td>\(\lambda\)</td></tr>
</table>

2\. 花体字

<table style="width: 100%">
<tr><th>LaTex</th><th>显示效果</th></tr>
<tr><td>\mathcal{L}</td><td>\(\mathcal{L}\)</td></tr>
<tr><td>\mathcal{M}</td><td>\(\mathcal{M}\)</td></tr>
<tr><td>\mathbb{P}</td><td>\(\mathbb{P}\)</td></tr>
<tr><td>\mathbb{R}</td><td>\(\mathbb{R}\)</td></tr>
</table>

3\. 微积分

<table style="width: 100%">
<tr><th>LaTex</th><th>显示效果</th></tr>
<tr><td>\int</td><td>\(\Large\int\)</td></tr>
<tr><td>\iint</td><td>\(\Large\iint\)</td></tr>
<tr><td>\iiint</td><td>\(\Large\iiint\)</td></tr>
<tr><td>\oint</td><td>\(\Large\oint\)</td></tr>
<tr><td>\oiint</td><td>\(\oiint\)</td></tr>
<tr><td>\partial</td><td>\(\partial\)</td></tr>
<tr><td>\infty</td><td>\(\infty\)</td></tr>
<tr><td>\prime</td><td>\(\prime\)</td></tr>
<tr><td>\dot x</td><td>\(\dot x\)</td></tr>
<tr><td>\ddot x</td><td>\(\ddot x\)</td></tr>
<tr><td>\lim</td><td>\(\lim\)</td></tr>
<tr><td>\log</td><td>\(\log\)</td></tr>
</table>

4\. 代数

<table style="width: 100%">
<tr><th>LaTex</th><th>显示效果</th></tr>
<tr><td>\frac12</td><td>\(\Large\frac12\)</td></tr>
<tr><td>\sum</td><td>\(\sum\)</td></tr>
<tr><td>\prod</td><td>\(\prod\)</td></tr>
<tr><td>\times</td><td>\(\times\)</td></tr>
<tr><td>\neq</td><td>\(\neq\)</td></tr>
<tr><td>\geq</td><td>\(\geq\)</td></tr>
<tr><td>\leq</td><td>\(\leq\)</td></tr>
<tr><td>\geqslant</td><td>\(\geqslant\)</td></tr>
<tr><td>\leqslant</td><td>\(\leqslant\)</td></tr>
<tr><td>\in</td><td>\(\in\)</td></tr>
<tr><td>\notin</td><td>\(\notin\)</td></tr>
<tr><td>\subseteq</td><td>\(\subseteq\)</td></tr>
<tr><td>\subset</td><td>\(\subset\)</td></tr>
<tr><td>\cup</td><td>\(\cup\)</td></tr>
<tr><td>\cap</td><td>\(\cap\)</td></tr>
<tr><td>\sqrt2</td><td>\(\sqrt2\)</td></tr>
<tr><td>\tilde x</td><td>\(\Large\tilde x\)</td></tr>
<tr><td>\vec x</td><td>\(\Large\vec x\)</td></tr>
<tr><td>\left[<br />\begin {array}{cc}<br />a11&amp;a12\\<br />a21&amp;a22<br />\end {array}<br />\right]</td><td>\(\left[\begin{array}{cc}a11&amp;a12\\a21&amp;a22\end{array}\right]\)</td></tr>
</table>

5\. 杂项

<table style="width: 100%">
<tr><th>LaTex</th><th>显示效果</th></tr>
<tr><td>\ </td><td>\(\ \) 空格</td></tr>
<tr><td>\dots</td><td>\(\dots\)</td></tr>
<tr><td>\rightarrow</td><td>\(\rightarrow\)</td></tr>
<tr><td>\leftarrow</td><td>\(\leftarrow\)</td></tr>
<tr><td>\begin {align}<br />
		(a+b)^2 &amp;= (a+b)(a+b) \\<br />
		&amp;= a^2+2ab+b^2<br />
		\end {align}</td><td>\(\begin{align}
		(a+b)^2 &amp;= (a+b)(a+b) \\
		&amp;= a^2+2ab+b^2
		\end{align}\)<br />align 模式，按 &amp; 的位置上下对齐</td></tr>
</table>

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  imageFont: null
});
</script>
<script type="text/javascript" src="/MathJax/MathJax.js?config=TeX-AMS_HTML"></script>
