create the PG nets
create_net -power VDD
create_net -ground VSS
#Making Logical Connections
connect_pg_net -net VDD [get_pins -hierarchical "*/VDD"] 
connect_pg_net -net VSS [get_pins -hierarchical "*/VSS"]
#Setting up the attribute for TIE cells
set_attribute [get_lib_cells */*TIE*] dont_touch false
set_lib_cell_purpose -include optimization [get_lib_cells */*TIE*]
########PG ring creation####
create_pg_ring_pattern ring_pattern -horizontal_layer M8 \
    -horizontal_width {0.6} -horizontal_spacing {1} \
    -vertical_layer M9 -vertical_width {0.7} \
    -vertical_spacing {1} -corner_bridge false
set_pg_strategy core_ring -core -pattern \
    {{pattern: ring_pattern}{nets: {VDD VSS}}{offset: {1 1}}} \
    -extension {{stop: innermost_ring}}
compile_pg -strategies core_ring
###Mesh
create_pg_mesh_pattern pg_mesh_pattern -layers {{{vertical_layer: M8} {width: 0.6} {spacing: Interleaving}{pitch: 12}}{{vertical_layer: M6} {width: 0.5} {spacing: Interleaving}{pitch: 12}}{{horizontal_layer: M7}{width: 0.5}{spacing: interleaving}{pitch:10}}}
set_pg_strategy s_mesh1 -core -pattern\
{{pattern:pg_mesh_pattern} {nets:{VDD VSS}}\
{offset_start:{5 5}}} -extension {{stop:outermost_ring}}
compile_pg -strategies s_mesh1
##STD_Rails###
create_pg_std_cell_conn_pattern \
    std_cell_rail  \
    -layers {M1} \
    -rail_width 0.06
set_pg_strategy rail_start -core \
    -pattern {{name: std_cell_rail} {nets: VDD VSS} }
compile_pg -strategies rail_start

check_pg_drc
check_pg_connectivity
check_pg_missing_vias
