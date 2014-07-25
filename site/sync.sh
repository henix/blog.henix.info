#!/bin/sh
rsync -avz ./*.html ./*.css rss2.0.xml robots.txt ../output/
rsync -avz --include="_.html" --exclude-from="-" works hacks views dig ../output/ <<EOF
*.swp
_.*
*.dot
EOF
