#!/bin/bash
. ./_.ini
cat <<EOF
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<link rel="icon" href="data:,">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$sitetitle</title>
EOF
cat myhead.seg.htm
cat <<EOF
<link rel="stylesheet" href="root.css">
<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="rss2.0.xml">
</head>
<body>
<div id="page">

<h1 class="sitetitle">$sitetitle</h1>

<p id="banner"><img src="banner2.jpg" alt=""></p>
EOF
sortedcats=$(< sorted.row sort -t $'\t' -su -k 2,2 | sort -t $'\t' -r -k 1,1 | cut -f 2)
for cat in $sortedcats; do
	cat <<EOF
<div class="box">
<h5 class="cate-title">$(sed -f htmlesc.sed "$cat/_.name")</h5>
<ul class="box-body post-list">
EOF
	IFS=$'\t'
	< sorted.row awk -F '\t' '$2 == "'"$cat"'"' | while read -r publish_time cat id title ; do
		cat <<EOF
<li>$publish_time<a href="blog/$id/">$(echo "$title" | sed -f htmlesc.sed)</a></li>
EOF
	done
	IFS=
	cat <<EOF
</ul>
</div>
EOF
done
cat <<EOF
<div id="footer">
<div style="float:left">
<a class="-Valid" href="https://validator.w3.org/check?uri=referer">Valid</a>
EOF
for page in about updates ; do
	title=$(head -n1 "${page}.md" | sed -e 's/^% //')
	cat <<EOF
| <a href="${page}.html">$(echo "$title" | sed -f htmlesc.sed)</a>
EOF
done
cat <<EOF
</div>
</div>

</div><!-- end of page -->
EOF
cat js-start.seg.htm
cat all-end.seg.htm
cat <<EOF
</body>
</html>
EOF
