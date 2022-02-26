
;-----------------------Her blir egen kode ferdig, bare behold resten av linjene under, MEN modifiser line 1087
;TIME_ELAPSED:174.604030

G1 F2700 E2173 ; Drar inn tråd ------------- NB!! sett inn ny verdi som gir passelig inndrag, ellers risikerer dere å tømme/rewinde rullen

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
