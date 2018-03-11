#!/bin/sh
rsync -avz ./*.html ./*.css ./*.js ./*.jpg rss2.0.xml robots.txt ../output/
rsync -avz --exclude-from="-" tips/* security/* doc/* program/* web/* cs/* linux/* fp/* ../output/blog/ <<EOF
*.swp
_.*
*.dot
EOF
