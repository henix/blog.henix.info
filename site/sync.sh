#!/bin/sh
rsync -av ./*.html ./*.css ./valid.js ./post.js ./comment.js ./*.jpg rss2.0.xml sitemap.xml robots.txt ../public/
rsync -av --exclude-from="-" ./*/* ../public/blog/ <<EOF
*.swp
_.*
*.dot
EOF
