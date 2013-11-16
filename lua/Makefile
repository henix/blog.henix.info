.PHONY: all runscala allposts alltags

.SECONDARY:

MDS := $(wildcard blogs/*.md)

all: pages/index.html pages/search.html pages/links.html pages/about.html pages/guestbook.html pages/rss2.0.xml pages/sitemap.xml

# tag names

tags.mk.inc: tags.db
	printf "TAGS := " > $@
	cut -f 2 $< | tr '\n' ' ' >> $@

-include tags.mk.inc

# scala

commons-io-2.4.jar:
	wget http://repo1.maven.org/maven2/commons-io/commons-io/2.4/commons-io-2.4.jar
	sha1sum -c commons-io-2.4.jar.sha1

classes/henix/blog/Main.class: blog.scala commons-io-2.4.jar
	scalac -classpath commons-io-2.4.jar -d classes $<

runscala: classes/henix/blog/Main.class commons-io-2.4.jar
	scala -classpath classes:commons-io-2.4.jar -Dpostpath="build/post" henix.blog.Main

# preprocess rule

%.pp.htm: %.temp.htm
	slt2pp.lua $< > $@
	printf $@ > $@.d
	printf ": " >> $@.d
	printf "$< " >> $@.d
	slt2dep.lua $< >> $@.d

# 首页

-include index.pp.htm.d

pages/index.html: build/index.lua index.pp.htm config.lua $(patsubst blogs/%.md,build/post/%.digest.seg.htm,$(MDS))
	runslt2.lua -d config.lua -t index.pp.htm < $< > $@

# tags

-include tag.pp.htm.d

tags/%.html: build/tag/%.lua tag.pp.htm
	runslt2.lua -d config.lua -t tag.pp.htm < $< > $@

build/tag/%.d: build/tag/%.lua tag.temp.d
	runslt2.lua -t tag.temp.d < $< > $@

-include $(patsubst %,build/tag/%.d,$(TAGS))

alltags: $(patsubst %,tags/%.html,$(TAGS))

# comments

comments.db: comments.xml
	lua5.1 parsecom.lua $< | sort -k 1b,1 > $@

# post 和 digest

build/post/%.smd: blogs/%.md config.lua
	runslt2.lua -d config.lua -v "{}" -t $< > $@

build/post/%.md.htm: build/post/%.smd
	gfm $< > $@

build/post/%.digest.htm: build/post/%.md.htm digestHtml
	./digestHtml 150 < $< > $@

digestHtml: digestHtml.vala
	valac $<

-include post.pp.htm.d

blog/%.html: build/post/%.lua post.pp.htm config.lua build/post/%.md.htm
	runslt2.lua -d config.lua -t post.pp.htm < $< > $@

allposts: $(patsubst blogs/%.md,blog/%.html,$(MDS))

build/post/%.digest.seg.htm: build/post/%.lua digestpost.seg.htm config.lua build/post/%.digest.htm
	runslt2.lua -d config.lua -t digestpost.seg.htm < $< > $@

# other pages

JSLIB_PATH := ~/jslibs
RAINY_PATH := ~/rainy

-include search.pp.htm.d

build/search.rain.htm: search.pp.htm config.lua
	runslt2.lua -d config.lua -v "{}" -t $< > $@

pages/search.html: build/search.rain.htm
	$(RAINY_PATH)/rain --incpath $(JSLIB_PATH) --moddef $(JSLIB_PATH)/base.js/base.moddef --moddef $(JSLIB_PATH)/csv.js/csv.moddef --moddef $(JSLIB_PATH)/flower.js/flower.moddef --moddef $(JSLIB_PATH)/flower-widgets/flowerui.moddef $< > $@

-include links.pp.htm.d

pages/links.html: links.pp.htm config.lua
	runslt2.lua -d config.lua -v "{}" -t $< > $@

-include about.pp.htm.d

pages/about.html: about.pp.htm config.lua
	runslt2.lua -d config.lua -v "{}" -t $< > $@

-include guestbook.pp.htm.d

pages/guestbook.html: guestbook.pp.htm config.lua
	runslt2.lua -d config.lua -v "{}" -t $< > $@

# RSS

pages/rss2.0.xml: build/rss.lua rss2.0.temp.xml config.lua
	runslt2.lua -d config.lua -t rss2.0.temp.xml < $< > $@

pages/sitemap.xml: build/rss.lua sitemap.temp.xml config.lua
	runslt2.lua -d config.lua -t sitemap.temp.xml < $< > $@
