MAKEFLAGS += -j4
OUTPUTS = case.stl spacer.stl

.PHONY: all clean

all: $(OUTPUTS)

%.stl: %.scad
	openscad -o $@ $<

%.svg: %.scad
	openscad -o $@ $<

case.stl: case.scad rounded.scad constants.scad

spacer.stl: spacer.scad rounded.scad constants.scad

clean:
	rm -f $(OUTPUTS)
