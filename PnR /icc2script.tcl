#########path setup
set ref_path  "/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref"
set ndm_path "/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/WORK_DIR"
set results_path " /home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/results"
###setup of technology and ref 
set tech_file "$ref_path/tech/saed32nm_1p9m.tf"
set reflib  "$ref_path/CLIBs"
set reference_library [join "
$reflib/saed32_1p9m_tech.ndm 
$reflib/saed32_hvt.ndm
$reflib/saed32_lvt.ndm
$reflib/saed32_rvt.ndm
$reflib//saed32_sram_lp.ndm
$ndm_path/machine_counter.ndm
$ndm_path/msrv32_alu.ndm"
]
#######library creation
create_lib -technology $tech_file -ref_libs $reference_library msrv32__top

#########reading netlist and SDC
read_verilog $results_path/msrv32_top.v
read_sdc  /home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/results/msrv32_top.sdc
current_design msrv32_top
Link_design

##########parasitic reading
read_parasitic_tech -name {new_model} -tlup {$ref_path/tech/saed32nm_1p9m_Cmin.lv.tluplus} -layermap  \
                                           {$ref_path/tech/saed32nm_tf_itf_tluplus.map}

#source -echo /home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/design_data/mcmm_risc_core.tcl					   
current_corner default
set_parasitic_parameters -early_spec new_model -late_spec new_model
set_process_number 0.99 -corners default
set_temperature 125 -corners default
set_voltage 0.75 -corners default
current_mode default
set_scenario_status default -active true -setup true -hold true -max_transition true -max_capacitance true -min_capacitance true -leakage_power true  \
-dynamic_power true

#souce -echo /home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/design_data/risc_core.upf


###########floorplan checks
report_design -all
check_netlist
report_timing
report_design_mismatch -verbose
check_design -checks {dp_pre_floorplan}
check_design -checks {dp_pre_create_placement_abstract}

#########floor plan
initialize_floorplan -core_offset {4} -core_utilization 0.7
place_pins -self
################pin placing
set_block_pin_constraints -self -allowed_layers {M3} -pin_spacing 3 -sides {1 3} -width {0.07} 
#place_pins -ports [get_ports -filter {direction == in }] 
place_pins -ports [all_inputs] 
set_block_pin_constraints -self -allowed_layers {M2} -pin_spacing 3 -sides {2 4} -width {0.07} 
#place_pins -ports [get_ports -filter {direction == out}] 
place_pins -ports [all_outputs] 
place_pins -legalize -ports [all_inputs] 
place_pins -legalize -ports [all_outputs] 
check_pin_placement 
create_keepout_margin -type hard_macro -outer {2 2 2 2} [get_flat_cells -filter "is_hard_macro"]
get_lib_cells *DCAP*
set_attribute [get_lib_cells *DCAP*] dont_use false
create_boundary_cell -left_boundary_cell saed32_hvt|saed32_hvt_std/DCAP_HVT -right_boundary_cell saed32_hvt|saed32_hvt_std/DCAP_HVT 
create_boundary_cell -top_boundary_cell saed32_hvt|saed32_hvt_std/DCAP_HVT -bottom_boundary_cell saed32_hvt|saed32_hvt_std/DCAP_HVT

#########powerplan
source -echo /home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/scripts/powerplan.tcl
#########checks##
check_pg_connectivity
check_pg_drc
check_pg_missing_vias

################checks placements
check_design -checks pre_placement_stage
check_design -checks physical_constraints

###########Placement
create_placement -floorplan
#Grouping paths
##########if macros
#group_path -name MACRO2REG -from [get_cells physical_context -filter design_types==macro] -to [all_registers]
#group_path -name REG2MACRO -from [all_registers] -to [get_cells -physical_context -filter design_types==macro]
#####
group_path -name INPUTS2REG -from [all_inputs] -to [all_registers]
group_path -name OUTPUTS2REG -from [all_registers] -to [all_outputs]
group_path -name REG2REG -from [all_registers] -to [all_registers]

######set_app_options
set_app_options -name place.coarse.continue_on_missing_scandef -value true
set_app_options -name place.coarse.max_density -value 0.6
set_app_options -name place.coarse.congestion_driven_max_util -value 0.6
create_placement -congestion
place_opt
legalize_placement

######Checks#
check_legality
analyze_design_violations
report_constraints -all_violators

##################reports should be generated
report_design -all
report_global_timing
report_utilization

######################Pre checks for cts
check_design -checks pre_clock_tree_stage

#clock route
set CTS_CELLS [get_lib_cells "*/NBUFF*LVT */NBUFF*RVT */INVX*_LVT */INVX*_RVT */CGL* */LSUP* */*DFF*"]
set_dont_touch $CTS_CELLS false
set_lib_cell_purpose -exclude cts [get_lib_cells] 
set_lib_cell_purpose -include cts $CTS_CELLS
source -echo  /home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/scripts/ndr.tcl
set_app_options -name time.remove_clock_reconvergence_pessimism -value true
clock_opt -from build_clock -to build_clock
clock_opt -from route_clock -to route_clock
clock_opt -from final_opto -to final_opto
report_clock_settings
report_qor -summary
clock_opt

################post CTS
report_clock_qor


#routing
route_auto -max_detail_route_iterations 15
route_auto
route_opt
route_eco
report_lib_cells -objects [get_lib_cells *FILL*]
#signoff_check_drc -auto_eco true
check_lvs
save_block

#script writing
write_script -force -format icc2 -output ../reports/machine_control.spef
write_parasitics -output ../reports/spef_generation_01
write_sdf ../results/machine_control.sdf
write_verilog ../results/machine_control.v
write_gds ../results/machine_control.gds
write_sdc -output ../results/machine_control.sdc

save_block
