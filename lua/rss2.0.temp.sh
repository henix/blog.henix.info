#!/bin/sh

echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<rss version=\"2.0\">
	<channel>
		<title>遥远的街市</title>
		<link>$SITEURL</link>
		<description>$SITEDESC</description>
		<language>zh-cn</language>
		<category>Blog</category>
		<category>技术</category>
		<category>Computer</category>
		<category>IT</category>
		<lastBuildDate>$(date "+%a, %d %b %Y %H:%M +0800")</lastBuildDate>
		$(cat)
	</channel>
</rss>"
