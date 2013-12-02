.PHONY: all dirs allposts allpages

.SECONDARY:

BLOGS := $(wildcard blogs/*.md)

PAGES := $(wildcard pages/*.md)

all: dirs allposts allpages output/rss2.0.xml

dirs:
	@mkdir -p output/blog

# preprocess rule

%.pp.htm: %.temp.htm
	slt2pp.lua $< > $@
	printf $@ > $@.d
	printf ": " >> $@.d
	printf "$< " >> $@.d
	slt2dep.lua $< >> $@.d

# 首页

-include index.pp.htm.d

output/index.html: build/index.lua index.pp.htm config.lua
	runslt2.lua -d config.lua -t index.pp.htm < $< > $@

# post

build/post/%.smd: blogs/%.md config.lua
	runslt2.lua -d config.lua -v "{}" -t $< > $@

build/post/%.htm: build/post/%.smd
	gfm $< > $@

-include post.pp.htm.d

output/blog/%.html: build/post/%.lua post.pp.htm config.lua build/post/%.htm
	runslt2.lua -d config.lua -t post.pp.htm < $< > $@

allposts: $(patsubst blogs/%.md,output/blog/%.html,$(BLOGS))

# pages

build/page/%.htm: pages/%.md
	gfm $< > $@

-include page.pp.htm.d

output/%.html: build/page/%.lua page.pp.htm config.lua build/page/%.htm
	runslt2.lua -d config.lua -t page.pp.htm < $< > $@

allpages: $(patsubst pages/%.md,output/%.html,$(PAGES)) output/index.html

# RSS

output/rss2.0.xml: build/rss.lua rss2.0.temp.xml config.lua $(patsubst blogs/%.md,build/post/%.htm,$(BLOGS))
	runslt2.lua -d config.lua -t rss2.0.temp.xml < $< > $@
