.PHONY: all allposts alltags clean

.SECONDARY:

MDS := $(wildcard blogs/*.md)

all: pages/index.html $(patsubst blogs/%.md,blog/%.html,$(MDS)) $(patsubst %,tags/%.html,$(TAGS))

tags.mk.inc: tags.db
	printf "TAGS := " > $@
	cut -f 2 $< | tr '\n' ' ' >> $@

-include tags.mk.inc

category.mk.inc: category.db
	printf "CATES := " > $@
	cut -f 1 $< | tr '\n' ' ' >> $@

-include category.mk.inc

comments.lua: comments.xml
	lua5.1 parsecom.lua $< > $@

# post 的一般信息

build/%.title: blogs/%.md
	sed -n -e '1s/^% *//p' $< > $@

build/%.name:
	echo $@ | sed -e 's/^build\///' -e 's/\.name$$//' > $@

build/%.publish_time: blogs/%.md
	sed -n -e '3s/^% *//p' $< > $@

# category

build/%.catid: blogs/%.md
	sed -n -e '2s/ //g' -e '2s/^%//p' $< | tr ';' '\n' | sed -n -e '1p' > $@

build/%.catname: build/%.catid category.db
	cat $< | join - category.db | cut -d ' ' -f 2 > $@

build/%.catpost: build/%.catid build/%.name build/%.publish_time
	paste $^ > $@

build/catpost.db: $(patsubst blogs/%.md,build/%.catpost,$(MDS))
	cat $^ | sort -k 1b,1 > $@

build/%.cat.id:
	echo $@ | sed -e 's/^build\///' -e 's/\.cat\.id$$//' > $@

build/%.cat.begin.html: build/%.cat.id category.db cat.begin.temp.htm
	runslt2.lua -v "{cateid=$$(cat $< | ./escape.lua),catename=$$(cat $< | join - category.db | cut -d ' ' -f 2 | ./escape.lua)}" -t cat.begin.temp.htm > $@

build/%.cat.d: build/%.cat.id build/catpost.db
	printf "build/%s.cat.seg.htm: build/%s.cat.begin.html " $$(cat $<) $$(cat $<) > $@
	join $< build/catpost.db | sort -k 3nr | cut -d ' ' -f 2 | sed -e 's/.*/build\/&.digest.seg.htm/' | tr '\n' ' ' >> $@
	echo cat.end.temp.htm >> $@
	echo -e "\tcat \$$^ > \$$@" >> $@

-include $(patsubst %,build/%.cat.d,$(CATES))

# 首页

-include index.begin.pp.htm.d
-include index.end.pp.htm.d

build/index.begin.html: index.begin.pp.htm
	runslt2.lua -d config.lua -v "{}" -t $< > $@

build/index.end.html: index.end.pp.htm
	runslt2.lua -d config.lua -v "{}" -t $< > $@

build/index.html.d: build/catpost.db
	printf "pages/index.html: build/index.begin.html " > $@
	sort -k 3nr $< | sort -s -u -k 1,1 | sort -k 3nr | cut -f 1 | sed -e 's/.*/build\/&.cat.seg.htm/' | tr '\n' ' ' >> $@
	echo build/index.end.html >> $@
	echo -e "\tcat \$$^ > \$$@" >> $@

-include build/index.html.d

# tags

build/%.tags: blogs/%.md
	sed -n -e '2s/ //g' -e '2s/^%//p' $< | tr ';' '\n' | sed '1d' > $@

build/%.tags.seg.htm: build/%.tags tags.db
	sort -k 1b,1 < $< | join - tags.db | awk '{ if (NR > 1) printf ", " ; print "<a href=\"/tags/" $$2 ".html\">" $$1 "</a>" }' > $@

build/%.tagpost: build/%.tags build/%.name build/%.publish_time
	./tagpost.sh $^ > $@

build/tagpost.db: $(patsubst blogs/%.md,build/%.tagpost,$(MDS))
	cat $^ | sort -k 1b,1 > $@

build/tags2.db: tags.db
	sort -k 2b,2 < $< > $@

build/%.tag.name:
	echo $@ | sed -e 's/^build\///' -e 's/\.tag\.name$$//' > $@

build/%.tag.d: build/%.tag.name build/tagpost.db build/tags2.db
	printf "tags/%s.html: build/%s.tag.begin.html " $$(cat $<) $$(cat $<) > $@
	join -2 2 $< build/tags2.db | cut -d ' ' -f 1 | join - build/tagpost.db | sort -k 3nr | cut -d ' ' -f 2 | sed -e 's/.*/build\/&.digest.seg.htm/' | tr '\n' ' ' >> $@
	echo build/tag.end.html >> $@
	echo -e "\tcat \$$^ > \$$@" >> $@

-include $(patsubst %,build/%.tag.d,$(TAGS))

alltags: $(patsubst %,tags/%.html,$(TAGS))

# preprocess rules

%.pp.htm: %.temp.htm
	slt2pp.lua $< > $@
	printf $@ > $@.d
	printf ": " >> $@.d
	printf "$< " >> $@.d
	slt2dep.lua $< >> $@.d

# tag 模板

-include tag.begin.pp.htm.d
-include tag.end.pp.htm.d

build/%.tag.begin.html: build/%.tag.name tag.begin.pp.htm
	runslt2.lua -d config.lua -v "{tagname=$$(cat $< | ./escape.lua)}" -t tag.begin.pp.htm > $@

build/tag.end.html: tag.end.pp.htm
	cat $^ > $@

# post 和 digest

build/%.md.htm: blogs/%.md
	pandoc $< > $@

build/%.digest.htm: build/%.md.htm digestHtml
	./digestHtml 150 < $< > $@

digestHtml: digestHtml.vala
	valac $<

build/%.lua: build/%.name build/%.title build/%.catid build/%.catname build/%.publish_time build/%.md.htm build/%.tags.seg.htm
	./postlua.sh $^ > $@

build/%.digest.lua: build/%.name build/%.title build/%.catid build/%.catname build/%.publish_time build/%.digest.htm build/%.tags.seg.htm
	./postlua.sh $^ > $@

blog/%.html: build/%.lua post.pp.htm config.lua build/%.md.htm build/%.tags.seg.htm
	runslt2.lua -d config.lua -t post.pp.htm < $< > $@

allposts: $(patsubst blogs/%.md,blog/%.html,$(MDS))

build/%.digest.seg.htm: build/%.digest.lua digestpost.seg.htm config.lua build/%.digest.htm build/%.tags.seg.htm
	runslt2.lua -d config.lua -t digestpost.seg.htm < $< > $@

clean:
	rm $(TARGETS)
