OUTPUTS = case.stl

.PHONY: all clean

all: $(OUTPUTS)

%.stl: %.scad
	openscad -o $@ $<

%.svg: %.scad
	openscad -o $@ $<

case.stl: case.scad rounded.scad constants.scad

clean:
	rm -f $(OUTPUTS)
