MAKEFLAGS += -j4
OUTPUTS = axo-top.stl axo-base.stl

.PHONY: all clean

all: $(OUTPUTS)

%.stl: %.scad
	openscad -o $@ $<

%.svg: %.scad
	openscad -o $@ $<

axo-base.stl: axo-base.scad rounded.scad constants.scad

axo-top.stl: axo-top.scad rounded.scad constants.scad

clean:
	rm -f $(OUTPUTS)
