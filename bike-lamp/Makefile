PROJECT = lamp
all: $(PROJECT)-bar.gco $(PROJECT)-holder.gco

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

%-bar.stl: %.scad
	openscad -D part_mode=1 -o $@ $<

%-holder.stl: %.scad
	openscad -D part_mode=2 -o $@ $<

clean::
	rm -f $(PROJECT)-bar.gco $(PROJECT)-bar.gcode $(PROJECT)-bar.stl
	rm -f $(PROJECT)-holder.gco $(PROJECT)-holder.gcode $(PROJECT)-holder.stl
