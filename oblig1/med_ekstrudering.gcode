;FLAVOR:Marlin
;TIME:174
;Filament used: 0.0456743m
;Layer height: 0.2
;MINX:115.11
;MINY:115.11
;MINZ:0.2
;MAXX:119.89
;MAXY:119.89
;MAXZ:5
;Generated with Cura_SteamEngine master
M140 S50
M105
M190 S50 ;Setter tray temp til 50grader
M104 S200 ;Setter dyse temp til 200grader
M105
M109 S200 ;Setter dyse temp til 200grader og venter
M82 ;absolute extrusion mode
; Ender 3 Custom Start G-code
G92 E0 ; Reset Extruder
G28 ; Home all axes
G1 Z2.0 F3000 ; Move Z Axis up little to prevent scratching of Heat Bed
G1 X0.1 Y20 Z0.3 F5000.0 ; Move to start position
G1 X0.1 Y200.0 Z0.3 F1500.0 E15 ; Draw the first line - dette er testprint linjen
G1 X0.4 Y200.0 Z0.3 F5000.0 ; Move to side a little
G1 X0.4 Y20 Z0.3 F1500.0 E30 ; Draw the second line
G92 E0 ; Reset Extruder
G1 Z2.0 F3000 ; Move Z Axis up little to prevent scratching of Heat Bed
G1 X5 Y20 Z0.3 F5000.0 ; Move over to prevent blob squish
G92 E0
G92 E0
G1 F2700 E-5 ;Drar inn litt plast i dysa
;LAYER_COUNT:25
;LAYER:0
M107 ; vifte av da første lag skal hefte
;---------------------------------------- Herfra kan du legge inn egen kode


G0 F6000 X20 Y117.5 Z60 ; 6 cm over tray
G1 F600 X35 E0.5025 ; Flytter seg 1,5 cm
G0 X20 Y125
G1 F600 X170 E5.5275 ; Flytter seg 15 cm

G0 F6000 X117.5 Y140 Z100
G1 F600 X137.5 E6.1975

G0 F6000 X50 Y50 Z80
G1 F600 X150 E9.5475



;-----------------------Her blir egen kode ferdig, bare behold resten av linjene under, MEN modifiser line 1087
;TIME_ELAPSED:174.604030


G1 F2700 E4.5475 ; Drar inn tråd ------------- NB!! sett inn ny verdi som gir passelig inndrag, ellers risikerer dere å tømme/rewinde rullen
; Prøver å trekke inn 5 mm for å hindre at den ikke clogger extruderen

; ENDRE E-verdien


M140 S0
M107
G91 ;Relative positioning
G1 E-2 F2700 ;Retract a bit --- tror E-2 er en relativ kommando pga G91 som kan stå
G1 E-2 Z0.2 F2400 ;Retract and raise Z
G1 X5 Y5 F3000 ;Wipe out
G1 Z10 ;Raise Z more
G90 ;Absolute positioning

G1 X0 Y235 ;Present print
M106 S0 ;Turn-off fan
M104 S0 ;Turn-off hotend
M140 S0 ;Turn-off bed

M84 X Y E ;Disable all steppers but Z

M82 ;absolute extrusion mode
M104 S0
;End of Gcode
;SETTING_3 {"global_quality": "[general]\\nversion = 4\\nname = Standard Quality
;SETTING_3  #2\\ndefinition = creality_ender3\\n\\n[metadata]\\ntype = quality_c
;SETTING_3 hanges\\nquality_type = standard\\nsetting_version = 19\\n\\n[values]
;SETTING_3 \\nadhesion_type = none\\n\\n", "extruder_quality": ["[general]\\nver
;SETTING_3 sion = 4\\nname = Standard Quality #2\\ndefinition = creality_ender3\
;SETTING_3 \n\\n[metadata]\\ntype = quality_changes\\nquality_type = standard\\n
;SETTING_3 intent_category = default\\nposition = 0\\nsetting_version = 19\\n\\n
;SETTING_3 [values]\\ninfill_sparse_density = 100\\nwall_line_count = 0\\n\\n"]}
