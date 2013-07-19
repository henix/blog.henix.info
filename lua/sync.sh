#!/bin/sh
rsync -avz --delete blog ../static/
rsync -avz --delete tags ../static/
rsync -avz pages/index.html ../static/
