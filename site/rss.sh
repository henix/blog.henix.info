#!/bin/bash
. ./_.ini
cat <<EOF
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0">
<channel>
<title>$sitetitle</title>
<link>$siteurl/</link>
<description>$sitedesc</description>
<language>zh-cn</language>
<lastBuildDate>$(date +"%a, %d %b %Y %H:%M:%S +0800")</lastBuildDate>
EOF
IFS=$'\t'
while read -r publish_time cat id title; do
	cat <<EOF
<item>
<title>$(echo "$title" | sed -f htmlesc.sed)</title>
<link>$siteurl/blog/$id/</link>
<description>$(sed -f htmlesc.sed "$cat/$id/_.htm")</description>
<author>$author</author>
<guid isPermaLink="false">$id:$publish_time</guid>
<pubDate>$(date --date="$publish_time" +"%a, %d %b %Y %H:%M:%S +0800")</pubDate>
</item>
EOF
done < sorted.row
cat <<EOF
</channel>
</rss>
EOF
