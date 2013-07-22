　　这个脚本可以将当前页面上已加载的所有新鲜事置为“已读”。

　　注意这个跟人人网自带的最下面的“全部标记为已读”是不同的。“全部标记为已读”是将你的全部新鲜事——不管是否已经在当前页面加载，标记为已读。我这个是只清除当前已加载的新鲜事。

<!--p style="font-size: large; text-align: center">[人人-全部已读](javascript:(function(){function c(i,h){var g;if(document.createEvent){g=document.createEvent('HTMLEvents');g.initEvent(h,true,true);return !i.dispatchEvent(g)}else{g=document.createEventObject();return i.fireEvent('on'+h,g)}}var f=confirm('%E7%A1%AE%E5%AE%9A%EF%BC%9F');if(f){var d=document.querySelector('div.feed-list');var e=d.querySelectorAll('a.delete');var a=e.length;for(var b=0;b<a;b++){c(e[b],'click')}alert('%E5%B7%B2%E6%B8%85%E9%99%A4 '+a+' %E6%9D%A1%E6%96%B0%E9%B2%9C%E4%BA%8B')}})();)</p -->

<p style="font-size: large; text-align: center">
<a href="javascript:(function(){if(confirm('\u786e\u5b9a\uff1f')){for(var c=document.querySelector('div.feed-list').querySelectorAll('a.delete'),d=c.length,b=0;b<d;b++){var e=c[b],a=void 0;document.createEvent?(a=document.createEvent('HTMLEvents'),a.initEvent('click',!0,!0),e.dispatchEvent(a)):(a=document.createEventObject(),e.fireEvent('onclick',a))}alert('\u5df2\u6e05\u9664 '+d+' \u6761\u65b0\u9c9c\u4e8b')}})();">人人-全部已读</a>
</p>

### 用法

　　将上面的链接拖到书签栏。然后在人人网的页面点击书签栏的按钮，会提示你是否确定。如果确定，最后会显示已清除的新鲜事的数量。

　　对于 IE 用户：此脚本只支持 IE8 及以上，<del>而且由于 Windows 上 IE 不支持 UTF-8 编码的字符串，会出现乱码。请使用这个英文版：<a href="javascript:(function(){function c(i,h){var g;if(document.createEvent){g=document.createEvent('HTMLEvents');g.initEvent(h,true,true);return !i.dispatchEvent(g)}else{g=document.createEventObject();return i.fireEvent('on'+h,g)}}var f=confirm('sure?');if(f){var d=document.querySelector('div.feed-list');var e=d.querySelectorAll('a.delete');var a=e.length;for(var b=0;b<a;b++){c(e[b],'click')}alert(a+' newsfeeds cleared')}})();">人人-全部已读</a> 。Windows 上的其他浏览器（Chrome / Firefox / Opera）都可以正常工作。</del>（2012-8-25：发现是我自己 js 使用不当，没有用 \u 转义中文，现已改用 Closure complier 压缩 js ，可以自动转义中文）

### 源代码

　　实际上就是模拟点击每条新鲜事右边的“X”。

#{= highlight([=[
(function () {
	function fireEvent(element, eventType) {
		var evt;
		if (document.createEvent) {
			evt = document.createEvent("HTMLEvents");
			evt.initEvent(eventType, true, true); // type, bubbling, cancelable
			return !element.dispatchEvent(evt);
		} else {
			evt = document.createEventObject();
			return element.fireEvent('on' + eventType, evt);
		}
	}
	var goon = confirm('确定？');
	if (goon) {
		var feedlist = document.querySelector('div.feed-list');
		var deletes = feedlist.querySelectorAll('a.delete');
		var len = deletes.length;
		for (var i = 0; i < len; i++) {
			fireEvent(deletes[i], 'click');
		}
		alert('已清除 ' + len + ' 条新鲜事');
	}
})();
]=], 'js', {lineno=true})}#
