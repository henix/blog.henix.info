.PHONY: all clean

FILES := js/catebox.js

all: $(FILES)

JSLIB_PATH := ~/jslibs
RAINY_PATH := ~/rainy

%.js: %.temp.js
	$(RAINY_PATH)/rain --incpath $(JSLIB_PATH) --moddef $(JSLIB_PATH)/base.js/base.moddef --moddef $(JSLIB_PATH)/csv.js/csv.moddef --moddef $(JSLIB_PATH)/flower.js/flower.moddef --moddef $(JSLIB_PATH)/flower-widgets/flowerui.moddef $< > $@

clean:
	rm $(FILES)
