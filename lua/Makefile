.PHONY: allposts alltags clean

.SECONDARY:

MDS := $(wildcard blogs/*.md)
TAGPOSTS := $(patsubst blogs/%.md,build/%.tagpost,$(MDS))

tags.mk.inc: tags.db
	printf "TAGS := " > $@
	cut -f 2 $< | tr '\n' ' ' >> $@

-include tags.mk.inc

comments.lua: comments.xml
	lua5.1 parsecom.lua $< > $@

build/%.title: blogs/%.md
	sed -n -e '1s/^% *//p' $< > $@

build/%.name:
	echo $@ | sed -e 's/^build\///' -e 's/\.name$$//' > $@

build/%.publish_time: blogs/%.md
	sed -n -e '3s/^% *//p' $< > $@

build/%.catid: blogs/%.md
	sed -n -e '2s/ //g' -e '2s/^%//p' $< | tr ';' '\n' | sed -n -e '1p' > $@

build/%.catname: build/%.catid category.db
	cat $< | join - category.db | cut -d ' ' -f 2 > $@

build/%.tags: blogs/%.md
	sed -n -e '2s/ //g' -e '2s/^%//p' $< | tr ';' '\n' | sed '1d' > $@

build/%.tags.seg.htm: build/%.tags tags.db
	sort -k 1b,1 < $< | join - tags.db | awk '{ print "<a href=\"/tags/" $$2 ".html\">" $$1 "</a>" }' > $@

build/%.tagpost: build/%.tags build/%.name build/%.publish_time
	./tagpost.sh $^ > $@

build/tagpost.db: $(TAGPOSTS)
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

-include $(patsubst %,build/%.tag.d, $(TAGS))

alltags: $(patsubst %,tags/%.html,$(TAGS))

# preprocess rules

%.pp.htm: %.temp.htm
	slt2pp.lua $< > $@
	printf $@ > $@.d
	printf ": " >> $@.d
	printf "$< " >> $@.d
	slt2dep.lua $< >> $@.d

-include tag.begin.pp.htm.d

build/%.tag.begin.html: build/%.tag.name tag.begin.pp.htm
	runslt2.lua -d config.lua -v "{tagname=$$(cat $< | ./escape.lua)}" -t tag.begin.pp.htm > $@

build/tag.end.html: tag.end.pp.htm
	cat $^ > $@

build/%.md.htm: blogs/%.md
	pandoc $< > $@

build/%.digest.htm: build/%.md.htm digestHtml
	./digestHtml 460 < $< > $@

digestHtml: digestHtml.vala
	valac $<

build/%.lua: build/%.name build/%.title build/%.catid build/%.catname build/%.publish_time build/%.md.htm build/%.tags.seg.htm
	./postlua.sh $^ > $@

build/%.digest.lua: build/%.name build/%.title build/%.catid build/%.catname build/%.publish_time build/%.digest.htm build/%.tags.seg.htm
	./postlua.sh $^ > $@

blog/%.html: build/%.lua post.pp.htm config.lua
	runslt2.lua -d config.lua -t post.pp.htm < $< > $@

allposts: $(patsubst blogs/%.md,blog/%.html,$(MDS))

build/%.digest.seg.htm: build/%.digest.lua digestpost.seg.htm config.lua
	runslt2.lua -d config.lua -t digestpost.seg.htm < $< > $@

clean:
	rm $(TARGETS)
