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
M109 S200 ;Setter dyse temp til 200 grader og venter
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
