PROJECT = quilling-organiser
all: $(PROJECT)-F.gco $(PROJECT)-L.gco $(PROJECT)-I.gco $(PROJECT)-T.gco

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

%-F.stl: %.scad
	openscad -D part_mode=2 -D part_x=3 -D part_y=1 -o $@ $<

%-L.stl: %.scad
	openscad -D part_mode=2 -D part_x=1 -D part_y=1 -o $@ $<

%-I.stl: %.scad
	openscad -D part_mode=2 -D part_x=2 -D part_y=1 -D twin_mode=0 -o $@ $<

%-T.stl: %.scad
	openscad -D part_mode=2 -D part_x=2 -D part_y=1 -D twin_mode=2 -o $@ $<

clean::
	rm -f $(PROJECT)-F.gco $(PROJECT)-F.gcode $(PROJECT)-F.stl
	rm -f $(PROJECT)-L.gco $(PROJECT)-L.gcode $(PROJECT)-L.stl
	rm -f $(PROJECT)-I.gco $(PROJECT)-I.gcode $(PROJECT)-I.stl
	rm -f $(PROJECT)-T.gco $(PROJECT)-T.gcode $(PROJECT)-T.stl
