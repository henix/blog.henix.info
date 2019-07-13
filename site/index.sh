#!/bin/bash
. ./_.ini
cat <<EOF
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
<title>$sitetitle</title>
<link rel="stylesheet" href="root.css">
<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="rss2.0.xml">
EOF
cat myhead.seg.htm
cat <<EOF
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
for page in about; do
	title=$(head -n1 "${page}.md" | sed -e 's/^% //')
	cat <<EOF
| <a href="${page}.html">$(echo "$title" | sed -f htmlesc.sed)</a>
EOF
done
cat <<EOF
| <a href="rss2.0.xml">订阅更新</a>
</div>
</div>

</div><!-- end of page -->
<script async defer="defer" src="valid.js"></script>
EOF
cat all-end.seg.htm
cat <<EOF
</body>
</html>
EOF
