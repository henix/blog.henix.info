#!/bin/sh

. ./config.sh

catpost=$1
tagsdb=$2

curdate=$(date +%Y-%m-%d)

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<urlset
	xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\"
	xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
	xsi:schemaLocation=\"http://www.sitemaps.org/schemas/sitemap/0.9
	http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd\">
<url>
	<loc>$SITEURL</loc>
	<priority>1.00</priority>
	<lastmod>$curdate</lastmod>
	<changefreq>daily</changefreq>
</url>
<url>
	<loc>$SITEURL/about.html</loc>
	<priority>0.5</priority>
	<lastmod>$curdate</lastmod>
	<changefreq>daily</changefreq>
</url>
<url>
	<loc>$SITEURL/links.html</loc>
	<priority>0.5</priority>
	<lastmod>$curdate</lastmod>
	<changefreq>daily</changefreq>
</url>
<url>
	<loc>$SITEURL/guestbook.html</loc>
	<priority>0.5</priority>
	<lastmod>$curdate</lastmod>
	<changefreq>daily</changefreq>
</url>"

cut -f 2 $catpost | while read name; do
	echo "<url>
	<loc>$SITEURL$(getPostURL $name)</loc>
	<priority>0.5</priority>
	<lastmod>$curdate</lastmod>
	<changefreq>daily</changefreq>
</url>"
done

cut -f 2 $tagsdb | while read tagid; do
	echo "<url>
	<loc>$SITEURL$(getTagURL $tagid)</loc>
	<priority>0.5</priority>
	<lastmod>$curdate</lastmod>
	<changefreq>daily</changefreq>
</url>"
done

echo "</urlset>"
