　　最近做右边“热门文章”的彩虹表效果，为了让它在 IE 上能优雅降级，研究了下针对 IE 的 CSS Hacks ：

#{= highlight([=[
selector{
  property:value; /* all browsers */
  property:value\9; /* IE 6 7 8 9 */
  property:value\0; /* IE 8 9 Opera */
  property:value\0/; /* IE 8 9 */
  property:value\9\0; /* IE 9 */
  *property:value; /* IE6 IE7 */
  +property:value; /* IE7 */
  _property:value; /* IE6 */
}
* html selector {
  property:value; /* IE 6 */
}
@media \0screen {
  selector {
    property:value; /* IE 8 */
  }
}
:root selector {
  property:value\9; /* IE 9 */
}
]=], 'css', {lineno=true})}#

　　关键是 \\0 这个 hack ：很多地方都说是 IE 8 9 的 hack ，但经我测试后发现最新版的 Opera 也识别（Opera 是 SB），恰好我平时用 Opera 用得比较多……最后终于找到了 \\0/ 这个 hack ，算是圆满解决。

　　所以，CSS Hacks 这种东西，一定要自己测试，要注意文章的实效性。

References:

* [Browser CSS hacks « Paul Irish](http://paulirish.com/2009/browser-specific-css-hacks/)
* [Personal CSS Hacks for IE6, IE7, IE8, IE9 » Ultimate Web Development (CSS, HTML, jQuery, WordPress) - Dimox.net](http://dimox.net/personal-css-hacks-for-ie6-ie7-ie8/)
