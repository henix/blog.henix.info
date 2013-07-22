　　开发个人博客除了写写 HTML/CSS/Javascript ，也是会遇到不少算法问题的。下面是我对一些问题的思考，以及相关的方案：

### 1. 热门度 ranking

　　即如何确定热门文章的排序。用于度量文章热门程度的主要有两项指标：点击数和评论数。我看到不少博客程序的办法是，有两个列表，一个是按点击量的 top 10 ，一个是按评论数的 top 10 。或者有些网站是只有评论数 top 10 。

　　我这个 blog 采用的是一个很简单的加权：热门度 = 点击数 + 7 * 评论数。

　　但这样也有一些问题，比如，“热门文章”一栏很少改变，排名第一的文章是历史上获得点击最多的文章，它在那里已经呆了将近一年了，后来的文章很难反超。于是可以考虑的改进是：引入时间因素。可以按时间加权，离现在越近的权值越高。

　　其实本来我以前也有一个“本月热门”，本月热门是只用当月数据排序出来的结果，反映了当前的热门。但后来发现这个结果基本上跟首页是一样的，读者还不如直接看首页。另一方面，博客跟新闻类网站不同，不是实时的，发文频率也很低，其实没必要这么搞。

　　目前的加权方式相当于所有时间点上的数据的权都是一样的，比较照顾历史数据。但是这样也有好处：有些东西的价值是不会随着时间的流逝而减少的。这样的加权照顾了经典文章。从最近的情况看，真正的有价值的文章也是有机会从默默无闻冲进前 10 的（从搜索引擎过来的流量帮了不少忙）。

　　所以各种加权方式也是各有优劣，究竟选用哪一种还需要仔细比较。

　　阮一峰前不久有几篇介绍 ranking 的文章可供参考：[基于用户投票的排名算法（六）：贝叶斯平均](http://www.ruanyifeng.com/blog/2012/03/ranking_algorithm_bayesian_average.html)。

### 2. 相关文章

　　两篇文章的相关度由它们的 tag 决定。直观上，两篇文章共有的 tag 越多，它们就越相关。所以一种直接的做法是：相关度 = 公共 tag 数。

　　我采用的算法是经典的[余弦相似度](http://en.wikipedia.org/wiki/Cosine_similarity)：

$$ 相似度(A,B) = \frac{AB 共同拥有的 tag 数量}{\sqrt{A的tag数}\sqrt{B的tag数}} $$

　　这个算法不但考虑了公共的 tag 数，也考虑到另外一个因素：AB 单独拥有的 tag 越多，则它们越不相关。

　　效率上，由于要同时计算所有文章与其他每篇文章的相似度，时间是 n<sup>2</sup> 的，也有一些算法来改善这个时间，但需要用 Jaccard 相似度，以后有时间研究一下。

　　其他的玩法还可以：对每篇文章进行中文分词，然后用 [TF-IDF](http://zh.wikipedia.org/wiki/TF-IDF) 提取文章的关键词，这可以用于 auto tagging（现在我的 tag 都是手动添加的）。不过只是一个个人博客做到这种程度。。我还没有那么蛋疼...

　　当然，实践上，也可以用[无觅的推荐插件](http://www.wumii.com/widget/relatedItems.htm)，不过我觉得自己做的可以随时调整，准确率更高。

### 3. HTML 摘要

　　我的首页并没有显示每篇文章的全文，只是显示了开头的一段。这就需要设计一种 HTML 摘要算法。

　　第一种想法是，先去掉所有 tag ，再按字符串长度截整。比如 [CSDN 博客](http://blog.csdn.net/shell_picker)就是这样做的。这样算法简单，但问题是，文章的格式信息完全被删除了，文章的内容全部都挤在一段里，看着觉得排版很乱。

　　另一种办法是，对 HTML 进行解析，取出前面的几个标签，直到总长度超过一个阈值。这种方案编程复杂，需要考虑各种特殊情况。

　　我的方案是：考虑对第一个算法进行改进。实际上读者并不需要标签跟原文一模一样，只需要换行跟原文一样就行了。于是我设计了这样一个算法：

1. 将 p 的结束符 &lt;/p&gt; 替换成一个不会在其他地方出现的特殊字符，如 0x7f
2. 将 &lt;br /&gt; 替换成 0x7f
3. 删去所有标签
4. 将 0x7f 替换成 &lt;br /&gt;

　　这样，标签跟原文不一样，但原文换了行的地方，摘要里也换了行。读者看的时候就能得到跟原文差不多的效果了。目前我的博客首页的摘要就是由这个算法生成的。

　　在具体实现的时候，还遇到过一些其他问题。比如，如果最后一个字符恰好是 HTML 转义符，如 &amp;amp; ，截断的位置不能出现在 HTML 实体的中间。所以，如果遇到了 &amp; 就需要把整个 HTML 实体完整地“吞下”。Lua 代码：

#{= highlight([=[
function digestHTML(str, length)
	local ret = string.gsub(str, "</p>", string.char(127))
	ret = string.gsub(ret, "<br />", string.char(127))
	ret = string.gsub(ret, "<.->", "")

	-- truncate UTF-8 string
	local i = 1
	local curlen = 0
	local len = string.len(ret)
	while curlen < length and i <= len do
		local t = string.byte(ret, i)
		if t > 127 then
			i = i + 3
		else
			if t == string.byte('&') then
				while string.byte(ret, i) ~= string.byte(';') and i < len do
					i = i + 1
				end
			end
			i = i + 1
		end
		curlen = curlen + 1
	end

	return string.gsub(string.sub(ret, 1, i - 1), string.char(127), "<br />")
end
]=], 'lua', {lineno=true})}#

#{include: 'mathjax.seg.htm' }#
