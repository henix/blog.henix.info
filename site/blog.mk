.PHONY: all clean

.SECONDARY:

DOTS := $(wildcard *.dot)
SVGS := $(patsubst %.dot,%.svg,$(DOTS))

all: index.html _.row _.htm $(SVGS)

_.id:
	pwd | tr '/' '\n' | tail -n1 > $@

_.cat:
	pwd | tr '/' '\n' | tail -n2 | head -n1 > $@

index.html: _.md _.id _.title _.date _.cat ../../_.sitetitle ../../_.siteurl ../../_.author ../../post.temp.htm ../../disqus.seg.htm ../../ga.seg.htm ../../baidu.seg.htm
	echo PANDOC HTML $$(< _.id)
	pandoc -t html5 --mathjax="https://cdn.jsdelivr.net/npm/mathjax@2.7.5/MathJax.js?config=TeX-AMS-MML_HTMLorMML" $$([ -f _.toc ] && echo --toc) --template=../../post.temp.htm -H ../../myhead.seg.htm -A ../../disqus.seg.htm -A ../../ga.seg.htm -A ../../baidu.seg.htm --highlight-style=kate -V id=$$(< _.id) -V "title=$$(< _.title)" -V date=$$(< _.date) -V cat=$$(< _.cat) -V "sitetitle=$$(< ../../_.sitetitle)" -V "siteurl=$$(< ../../_.siteurl)" -V "author=$$(< ../../_.author)" --css=../../root.css -o $@ $<

_.htm: _.md _.id ../../content.temp.htm
	echo PANDOC HTM $$(< _.id)
	pandoc -t html5 --mathjax $$([ -f _.toc ] && echo --toc) --template=../../content.temp.htm -o $@ $<

%.svg: %.dot
	dot -T svg $< > $@

_.row: _.date _.cat _.id _.title
	paste $^ > $@

clean:
	rm index.html _.row _.id _.cat _.htm $(SVGS)
