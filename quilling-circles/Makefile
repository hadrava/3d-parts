all: quilling-circles.gco quilling-circles.pdf

SETTINGS_PATH := /home/had/.Slic3r
SETTINGS_CNAME := My Settings.ini
SLICER_PARAMS := --load "$(SETTINGS_PATH)/filament/$(SETTINGS_CNAME)" --load "$(SETTINGS_PATH)/print/$(SETTINGS_CNAME)" --load "$(SETTINGS_PATH)/printer/$(SETTINGS_CNAME)"

CUSTOM_SETTINGS := --load my_settings.ini

%.gcode: %.stl
	slic3r $(SLICER_PARAMS) $(CUSTOM_SETTINGS) $<

%.gco: %.gcode
	./gcode-to-gco.pl $< > $@

%.stl: %.scad
	openscad -o $@ $<

%.svg: %.scad
	openscad  -D svg=1 -D '$$fn=10' -o $@ $<

%.pdf: %.svg
	inkscape -A $@ $<

clean::
	rm -f quilling-circles.gco quilling-circles.gcode quilling-circles.stl quilling-circles.svg quilling-circles.pdf
