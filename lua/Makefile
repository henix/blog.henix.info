.PHONY: all clean

TARGETS := visits_table.lua comments.lua

all: $(TARGETS)

visits_table.lua: visits.2.csv
	cat $^ | lua5.1 visits.lua visits_table > $@

comments.lua: comments.xml
	lua5.1 parsecom.lua $< > $@

clean:
	rm $(TARGETS)
