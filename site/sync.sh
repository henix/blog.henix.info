#!/bin/sh
rsync -avz ./*.html lib ./*.css rss2.0.xml robots.txt ../output/
rsync -avz --include="_.html" --exclude-from="-" tips/* security/* devtools/* program/* ../output/blog/ <<EOF
*.swp
_.*
*.dot
EOF
