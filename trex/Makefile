PROJECT = case
all: $(PROJECT)-B.stl $(PROJECT)-H.stl $(PROJECT)-T.stl $(PROJECT)-P.stl

SETTINGS_PATH := $(HOME)/.Slic3r
SETTINGS_CNAME := general.ini
SLICER_PARAMS := --load "$(SETTINGS_PATH)/filament/$(SETTINGS_CNAME)" --load "$(SETTINGS_PATH)/print/$(SETTINGS_CNAME)" --load "$(SETTINGS_PATH)/printer/$(SETTINGS_CNAME)"

CUSTOM_SETTINGS := --load my_settings.ini

%.gcode: %.stl
	slic3r $(SLICER_PARAMS) $(CUSTOM_SETTINGS) $<

%.gco: %.gcode
	./gcode-to-gco.pl $< > $@
	./gco-time.pl $@

%.stl: %.scad
	openscad -o $@ $<

# Bottom
%-B.stl: %.scad
	openscad -D bottom_part=true -o $@ $<

# Bottom + Hook
%-H.stl: %.scad
	openscad -D bottom_part=true -D hook_present=true -o $@ $<

# Top
%-T.stl: %.scad
	openscad -D bottom_part=false -o $@ $<

# Top + Pinheader
%-P.stl: %.scad
	openscad -D bottom_part=false -D pinheader_present=true -o $@ $<


clean::
	rm -f $(PROJECT)-B.gco $(PROJECT)-B.gcode $(PROJECT)-B.stl
	rm -f $(PROJECT)-H.gco $(PROJECT)-H.gcode $(PROJECT)-H.stl
	rm -f $(PROJECT)-T.gco $(PROJECT)-T.gcode $(PROJECT)-T.stl
	rm -f $(PROJECT)-P.gco $(PROJECT)-P.gcode $(PROJECT)-P.stl
