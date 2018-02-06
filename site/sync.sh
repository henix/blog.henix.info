#!/bin/sh
rsync -avz ./*.html ./*.css ./*.jpg rss2.0.xml robots.txt ../output/
rsync -avz --exclude-from="-" tips/* security/* devtools/* program/* web/* ../output/blog/ <<EOF
*.swp
_.*
*.dot
EOF
