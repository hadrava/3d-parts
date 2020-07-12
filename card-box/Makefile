PROJECT = case
all: $(PROJECT)-bottom.gco $(PROJECT)-top.gco

SETTINGS_PATH := /home/had/.Slic3r
#SETTINGS_CNAME := My Settings.ini
SETTINGS_CNAME := prusa-inspired.ini
SLICER_PARAMS := --load "$(SETTINGS_PATH)/filament/$(SETTINGS_CNAME)" --load "$(SETTINGS_PATH)/print/$(SETTINGS_CNAME)" --load "$(SETTINGS_PATH)/printer/$(SETTINGS_CNAME)"

CUSTOM_SETTINGS := --load my_settings.ini

%.gcode: %.stl
	slic3r $(SLICER_PARAMS) $(CUSTOM_SETTINGS) $<

%.gco: %.gcode
	./gcode-to-gco.pl $< > $@
	./gco-time.pl $@

%.stl: %.scad
	openscad -o $@ $<

%-bottom.stl: %.scad
	openscad -D part_mode=1 -o $@ $<

%-top.stl: %.scad
	openscad -D part_mode=2 -o $@ $<

clean::
	rm -f $(PROJECT)-bottom.gco $(PROJECT)-bottom.gcode $(PROJECT)-bottom.stl
	rm -f $(PROJECT)-top.gco $(PROJECT)-top.gcode $(PROJECT)-top.stl
