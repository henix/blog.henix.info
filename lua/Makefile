.PHONY: all dirs allposts allpages

.SECONDARY:

BLOGS := $(wildcard blogs/*.md)

PAGES := $(wildcard pages/*.md)

all: dirs allposts allpages output/rss2.0.xml output/sitemap.xml

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
	@echo slt2 $<
	@runslt2.lua -d config.lua -t index.pp.htm < $< > $@

# post

build/post/%.smd: blogs/%.md config.lua
	@echo slt2 $<
	@runslt2.lua -d config.lua -v "{}" -t $< > $@

GFM := gfm
PANDOC := pandoc -f markdown-markdown_in_html_blocks-tex_math_dollars --toc --template=pandoc.temp.htm

build/posts.mk: posts.db
	@cut -f 1,5 $< | awk '{ print "build/post/" $$1 ".htm: build/post/" $$1 ".smd"; print "\t@echo " toupper($$2) " $$<"; print "\t@$$(" toupper($$2) ") $$< > $$@\n"; }' > $@

-include build/posts.mk

-include post.pp.htm.d

output/blog/%.html: build/post/%.lua post.pp.htm config.lua build/post/%.htm
	@echo slt2 $<
	@runslt2.lua -d config.lua -t post.pp.htm < $< > $@

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
	@echo slt2 $<
	@runslt2.lua -d config.lua -t rss2.0.temp.xml < $< > $@

# sitemap.xml

output/sitemap.xml: build/sitemap.lua sitemap.temp.xml config.lua
	@echo slt2 $<
	@runslt2.lua -d config.lua -t sitemap.temp.xml < $< > $@
