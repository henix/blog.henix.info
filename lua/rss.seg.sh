#!/bin/sh

name=$(cat $1)
title=$(cat $2)
catname=$(cat $3)
publish_time=$(cat $4)
post_path=$5
tagsfile=$6

echo "<item>
	<title>$(echo $title | sed -f htmlesc.sed)</title>
	<link>$SITEURL/blog/${name}.html</link>
	<description>$(cat $post_path | sed -f htmlesc.sed)</description>
	<author>henix</author>
	<guid>$name</guid>
	<pubDate>$(date "+%a, %d %b %Y %H:%M +0800" --date="@$publish_time")</pubDate>
	<category>$catname</category>
	$(sed -f htmlesc.sed $tagsfile | sed -e 's/.*/<category>&<\/category>/')
</item>"
