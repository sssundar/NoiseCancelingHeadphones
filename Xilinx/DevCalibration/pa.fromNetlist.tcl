
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name DevCalibration -dir "D:/Users/Sushant/Documents/GitHub/NoiseCancelingHeadphones/Xilinx/DevCalibration/planAhead_run_2" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/Users/Sushant/Documents/GitHub/NoiseCancelingHeadphones/Xilinx/DevCalibration/test_dac_hardware.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/Users/Sushant/Documents/GitHub/NoiseCancelingHeadphones/Xilinx/DevCalibration} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "test_dac_hardware.ucf" [current_fileset -constrset]
add_files [list {test_dac_hardware.ucf}] -fileset [get_property constrset [current_run]]
link_design
