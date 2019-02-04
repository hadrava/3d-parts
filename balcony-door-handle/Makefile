all: balcony.gco balcony-low.stl balcony-high.stl

stls:: balcony-low.stl balcony-high.stl

SETTINGS_PATH := /home/had/.Slic3r
SETTINGS_CNAME := My Settings.ini
SLICER_PARAMS := --load "$(SETTINGS_PATH)/filament/$(SETTINGS_CNAME)" --load "$(SETTINGS_PATH)/print/$(SETTINGS_CNAME)" --load "$(SETTINGS_PATH)/printer/$(SETTINGS_CNAME)"

CUSTOM_SETTINGS := --load my_settings.ini

%.gcode: %.stl
	slic3r $(SLICER_PARAMS) $(CUSTOM_SETTINGS) $<

%.gco: %.gcode
	./gcode-to-gco.pl $< > $@
	./gco-time.pl $@

%.stl: %.scad
	openscad -o $@ $<

%-low.stl: %.scad
	openscad -D part_mode=1 -o $@ $<

%-high.stl: %.scad
	openscad -D part_mode=2 -o $@ $<

clean::
	rm -f balcony.gco balcony.gcode balcony.stl balcony-low.stl balcony-high.stl balcony-mix.gcode
