#!/bin/sh
rsync -avz ./*.html ./*.css ./valid.js ./post.js ./*.jpg rss2.0.xml robots.txt ../public/
rsync -avz --exclude-from="-" ./*/* ../public/blog/ <<EOF
*.swp
_.*
*.dot
EOF
