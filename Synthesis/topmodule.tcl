set tech_file  {/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/tech/saed32nm_1p9m.tf}
set synthetic_library dw_foundation.sldb
#set mw_path "../libs/mw_libs"
set mw_ref_libs {/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/libs/mw_libs/saed32_io_fc               
                 /home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/libs/mw_libs/saed32nm_lvt_1p9m }
                  

set my_mw_lib msrv32____top.mw

create_mw_lib $my_mw_lib \
         -technology $tech_file \
         -mw_reference_library $mw_ref_libs \
         -open
            
set target_library  "/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/DBs/saed32lvt_ss0p95v125c.db \
/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/DBs/saed32lvt_ss0p95v125c.db \
/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/DBs/saed32rvt_ss0p95v125c.db \
/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/DBs/saed32hvt_ss0p75v125c.db \
/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/DBs/saed32sramlp_ss0p95v125c_i0p95v.db"

set link_library  "/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/DBs/saed32lvt_ss0p95v125c.db \
/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/DBs/saed32lvt_ss0p95v125c.db \
/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/DBs/saed32rvt_ss0p95v125c.db \
/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/DBs/saed32hvt_ss0p75v125c.db \
/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/DBs/saed32sramlp_ss0p95v125c_i0p95v.db"

set ref_libs "/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/DBs/saed32lvt_ss0p95v125c.db \
/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/DBs/saed32lvt_ss0p95v125c.db \
/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/DBs/saed32rvt_ss0p95v125c.db \
/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/DBs/saed32hvt_ss0p75v125c.db \
/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/DBs/saed32sramlp_ss0p95v125c_i0p95v.db"

set_tlu_plus_files\
   		-max_tluplus /home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/tech/saed32nm_1p9m_Cmax.lv.tluplus \
     		-min_tluplus /home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/ref/tech/saed32nm_1p9m_Cmin.lv.tluplus \


read_ddc {/home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/results/machine_counter.ddc
                   /home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/results/msrv32_alu.ddc}
read_verilog -rtl [glob /home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/rtl/*.v]
analyze -format verilog [glob /home1/BPD23/VSchandrika/VLSI_PD/Project/MACROS/rtl/*.v]
elaborate msrv32_top
current_design msrv32_top

#source ../constraints/floorplan_constraints.pcon
#read_sdc ../constraints/constraints_file.sdc 
create_clock -name clock -period 10 -waveform {5 10} [get_port ms_riscv32_mp_clk_in]
set_svf Msrv32_top.svf
# dft constraints
#set_dft_signal -view existing_dft -type ScanClock -port router_clock -timing [list 45 55]
#set_dft_signal -view existing_dft -type Reset -port router_clock -active_state 1
#set_scan_configuration -chain_count 4
#create_test_protocol
#dft_drc
#preview_dft
#insert_dft

             compile_ultra -no_autoungroup -no_boundary_optimization
             write_icc2_files -output ../results/Msrv32_top -force

write -hierarchy -format ddc -output ../results/Msrv32_top.ddc 
report_area > ../reports/Msvr32_top.rpt
report_hierarchy > ../reports/Msrv32_top.rpt
report_design > ../reports/Msrv32_top.rpt
report_timing -path full > ../reports/Msrv32_top.rpt
write -hierarchy -format verilog -output ../results/Msrv32_top.v
write_sdf  ../reports/Msrv32_top.sdf
write_parasitics -output ../results/Msrv32_top_parastics_8_6
write_sdc ../results/Msrv32_top.sdc 
write -format ddc -h -o ../results/Msrv32_top.ddc 

puts "Finished"
#exit
