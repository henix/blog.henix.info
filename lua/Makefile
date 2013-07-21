.PHONY: all allposts alltags clean

.SECONDARY:

MDS := $(wildcard blogs/*.md)

all: pages/index.html pages/search.html pages/links.html pages/about.html pages/guestbook.html

tags.mk.inc: tags.db
	printf "TAGS := " > $@
	cut -f 2 $< | tr '\n' ' ' >> $@

-include tags.mk.inc

category.mk.inc: category.db
	printf "CATES := " > $@
	cut -f 1 $< | tr '\n' ' ' >> $@

-include category.mk.inc

# post 的一般信息

build/post/%.name:
	#echo $@ | sed -e 's/^build\/post\///' -e 's/\.name$$//' > $@
	echo $(patsubst build/post/%.name,%,$@) > $@

# category

build/post/%.catname: blogs/%.catid category.db
	cat $< | join - category.db | cut -d ' ' -f 2 > $@

build/post/%.catpost: blogs/%.catid build/post/%.name blogs/%.publish_time
	paste $^ > $@

build/catpost.db: $(patsubst blogs/%.md,build/post/%.catpost,$(MDS))
	cat $^ | sort -k 1b,1 > $@

build/%.cat.id:
	echo $@ | sed -e 's/^build\///' -e 's/\.cat\.id$$//' > $@

build/%.cat.begin.html: build/%.cat.id category.db cat.begin.temp.htm
	runslt2.lua -v "{cateid=$$(cat $< | ./escape.lua),catename=$$(cat $< | join - category.db | cut -d ' ' -f 2 | ./escape.lua)}" -t cat.begin.temp.htm > $@

build/%.cat.d: build/%.cat.id build/catpost.db
	printf "build/%s.cat.seg.htm: build/%s.cat.begin.html " $$(cat $<) $$(cat $<) > $@
	join $< build/catpost.db | sort -k 3nr | cut -d ' ' -f 2 | sed -e 's/.*/build\/post\/&.digest.seg.htm/' | tr '\n' ' ' >> $@
	echo cat.end.temp.htm >> $@
	echo -e "\tcat \$$^ > \$$@" >> $@

-include $(patsubst %,build/%.cat.d,$(CATES))

# 首页

-include index.begin.pp.htm.d
-include index.end.pp.htm.d

build/index.begin.html: index.begin.pp.htm
	runslt2.lua -d config.lua -v "{}" -t $< > $@

build/index.end.html: index.end.pp.htm build/popular.seg.htm
	runslt2.lua -d config.lua -v "{}" -t $< > $@

build/index.html.d: build/catpost.db
	printf "pages/index.html: build/index.begin.html " > $@
	sort -k 3nr $< | sort -s -u -k 1,1 | sort -k 3nr | cut -f 1 | sed -e 's/.*/build\/&.cat.seg.htm/' | tr '\n' ' ' >> $@
	echo build/index.end.html >> $@
	echo -e "\tcat \$$^ > \$$@" >> $@

-include build/index.html.d

# tags

build/post/%.tags.seg.htm: blogs/%.tags tags.db
	sort -k 1b,1 < $< | join - tags.db | awk '{ if (NR > 1) printf ", " ; print "<a href=\"/tags/" $$2 ".html\">" $$1 "</a>" }' > $@
	[ $$(cat $< | wc -l) -eq $$(cat $@ | wc -l) ]

build/post/%.tagpost: blogs/%.tags build/post/%.name blogs/%.publish_time
	./tagpost.sh $^ > $@

build/tag/tagpost.db: $(patsubst blogs/%.md,build/post/%.tagpost,$(MDS))
	cat $^ | sort -k 1b,1 > $@

build/tag/tags2.db: tags.db
	sort -k 2b,2 < $< > $@

build/tag/%.id:
	#echo $@ | sed -e 's/^build\/tag\///' -e 's/\.id$$//' > $@
	echo $(patsubst build/tag/%.id,%,$@) > $@

build/tag/%.name: build/tag/%.id build/tag/tags2.db
	join -2 2 $< build/tag/tags2.db | cut -d ' ' -f 2 > $@

build/tag/%.d: build/tag/%.id build/tag/tagpost.db build/tag/tags2.db
	printf "tags/%s.html: build/tag/%s.begin.html " $$(cat $<) $$(cat $<) > $@
	join -2 2 $< build/tag/tags2.db | cut -d ' ' -f 2 | join - build/tag/tagpost.db | sort -k 3nr | cut -d ' ' -f 2 | sed -e 's/.*/build\/post\/&.digest.seg.htm/' | tr '\n' ' ' >> $@
	echo build/tag/tag.end.html >> $@
	echo -e "\tcat \$$^ > \$$@" >> $@

-include $(patsubst %,build/tag/%.d,$(TAGS))

alltags: $(patsubst %,tags/%.html,$(TAGS))

# 相关文章

# 计算 tag 的权重
build/tag/%.weight: build/tag/%.name build/tag/tagpost.db
	printf "%s\t" $$(cat $<) > $@
	echo "scale=6;1/(1+l($$(join $< build/tag/tagpost.db | wc -l)))" | bc -l >> $@

build/tag/tagweight.db: $(patsubst %,build/tag/%.weight,$(TAGS))
	cat $^ | sort -k 1b,1 > $@

build/post/%.weight: blogs/%.tags build/tag/tagweight.db
	sort -k 1b,1 $< | join - build/tag/tagweight.db | awk '{s+=$$2}END{print s}' > $@

build/post/%.sortag: blogs/%.tags
	sort -k 1b,1 $< > $@

# 此 post 与其他 post 的共同 tag 的权重
build/post/%.coweight: build/post/%.sortag $(patsubst blogs/%.md,build/post/%.sortag,$(MDS)) build/tag/tagweight.db
	for i in $(patsubst blogs/%.md,build/post/%.sortag,$(MDS)); do printf "%s\t" $$(echo $$i | sed -e 's/^build\/post\///' -e 's/\.sortag$$//') ; comm -12 $< $$i | join - build/tag/tagweight.db | awk 'BEGIN{s=0}{s+=$$2}END{print s}' ; done | awk '{if($$2>0) print $$0}' | sort -k 2nr | sed -e '/^$(patsubst build/post/%.coweight,%,$@)\t/d' > $@

build/post/%.rela: build/post/%.coweight $(patsubst blogs/%.md,build/post/%.weight,$(MDS))
	myw=$$(cat $(patsubst build/post/%.coweight,build/post/%.weight,$<)) ; while read id co; do printf "%s\t" $$id ; echo "scale=6; $$co / ($$myw + $$(cat build/post/$${id}.weight) - $$co)" | bc ; done < $< | sort -k 2nr > $@

build/post/%.rela.seg.htm: build/post/%.rela
	head -n 5 $< | cut -f 1 | while read id ; do echo "<li><a href=\"/blog/$$id.html\">$$(cat blogs/$$id.title | sed -f htmlesc.sed)</a></li>" ; done > $@

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

build/tag/%.begin.html: build/tag/%.name tag.begin.pp.htm
	runslt2.lua -d config.lua -v "{tagname=$$(cat $< | ./escape.lua)}" -t tag.begin.pp.htm > $@

build/tag/tag.end.html: tag.end.pp.htm
	cat $^ > $@

# post 和 digest

## 评论数

comments.db: comments.xml
	lua5.1 parsecom.lua $< | sort -k 1b,1 > $@

build/post/%.comnum: build/post/%.name comments.db
	join $< comments.db | cut -d ' ' -f 2 > $@

build/popular.seg.htm: comments.db $(patsubst blogs/%.md,build/post/%.name,$(MDS)) $(patsubst blogs/%.md,blogs/%.title,$(MDS))
	cat $(patsubst blogs/%.md,build/post/%.name,$(MDS)) | sort | join - comments.db | sort -k 2nr | head -n 10 | while read id comnum; do echo "<li><a href=\"/blog/$$id.html\" title=\"$$comnum 条评论\">$$(cat blogs/$$id.title | sed -f htmlesc.sed)</a></li>" ; done > $@

build/post/%.smd: blogs/%.md
	runslt2.lua -d config.lua -v "{}" -t $< > $@

build/post/%.md.htm: build/post/%.smd
	gfm $< > $@

build/post/%.digest.htm: build/post/%.md.htm digestHtml
	./digestHtml 150 < $< > $@

digestHtml: digestHtml.vala
	valac $<

build/post/%.lua: build/post/%.name blogs/%.title blogs/%.catid build/post/%.catname blogs/%.publish_time build/post/%.comnum
	./postlua.sh $^ $(patsubst build/post/%.name,build/post/%.md.htm,$<) $(patsubst build/post/%.name,build/post/%.tags.seg.htm,$<) $(patsubst build/post/%.name,build/post/%.rela.seg.htm,$<) > $@

build/post/%.digest.lua: build/post/%.name blogs/%.title blogs/%.catid build/post/%.catname blogs/%.publish_time build/post/%.comnum
	./postlua.sh $^ $(patsubst build/post/%.name,build/post/%.digest.htm,$<) $(patsubst build/post/%.name,build/post/%.tags.seg.htm,$<) > $@

-include post.pp.htm.d

blog/%.html: build/post/%.lua post.pp.htm config.lua build/post/%.md.htm build/post/%.tags.seg.htm build/post/%.rela.seg.htm
	runslt2.lua -d config.lua -t post.pp.htm < $< > $@

allposts: $(patsubst blogs/%.md,blog/%.html,$(MDS))

build/post/%.digest.seg.htm: build/post/%.digest.lua digestpost.seg.htm config.lua build/post/%.digest.htm build/post/%.tags.seg.htm
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

clean:
	rm $(TARGETS)
