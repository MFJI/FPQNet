  
## Env Variables

#set action_root [lindex $argv 0]
#set fpga_part  	[lindex $argv 1]
set fpga_part    xcvu37p-fsvh2892-2-e-es1
set action_root ../../lenet

set aip_dir 	$action_root/ip
set log_dir     $action_root/../../hardware/logs
set log_file    $log_dir/create_action_ip.log
set src_dir 	$aip_dir/action_ip_prj/action_ip_prj.srcs/sources_1/ip

## Create a new Vivado IP Project
puts "\[CREATE_ACTION_IPs..........\] start [clock format [clock seconds] -format {%T %a %b %d/ %Y}]"
puts "                        FPGACHIP = $fpga_part"
puts "                        ACTION_ROOT = $action_root"
puts "                        Creating IP in $src_dir"
create_project action_ip_prj $aip_dir/action_ip_prj -force -part $fpga_part -ip >> $log_file

## Project IP Settings
## General
#puts "                        Generating axi_dwidth_converter ......"
#create_ip -name axi_dwidth_converter -vendor xilinx.com -library ip -version 2.1 -module_name axi_dwidth_converter_0 >> $log_file
#set_property -dict [list CONFIG.ADDR_WIDTH {64} CONFIG.SI_DATA_WIDTH {512} CONFIG.MI_DATA_WIDTH {1024}] [get_ips axi_dwidth_converter_0]
#
#generate_target all [get_files $src_dir/axi_dwidth_converter_0/axi_dwidth_converter_0.xci] >> $log_file
#
#close_project

#multipilier
puts "                        Generating mult_gen ......"
create_ip -name mult_gen -vendor xilinx.com -library ip -version 12.0 -module_name mult_8bs_4bs >> $log_file
set_property -dict [list CONFIG.PortAWidth {8} CONFIG.PortBWidth {4} CONFIG.Multiplier_Construction {Use_Mults} CONFIG.OutputWidthHigh {11}] [get_ips mult_8bs_4bs]
set_property generate_synth_checkpoint false [get_files  $src_dir/mult_8bs_4bs/mult_8bs_4bs.xci] >> $log_file
generate_target all [get_files  $src_dir/mult_8bs_4bs/mult_8bs_4bs.xci] >> $log_file

#ram_3b_16d
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name ram_3b_16d
set_property -dict [list CONFIG.Memory_Type {Simple_Dual_Port_RAM} CONFIG.Assume_Synchronous_Clk {true} CONFIG.Write_Width_A {3} CONFIG.Read_Width_A {3} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Write_Width_B {3} CONFIG.Read_Width_B {3} CONFIG.Operating_Mode_B {READ_FIRST} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {false} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Enable_Rate {100}] [get_ips ram_3b_16d]
generate_target {instantiation_template} [get_files $src_dir/ram_3b_16d/ram_3b_16d.xci]
#update_compile_order -fileset sources_1
set_property generate_synth_checkpoint false [get_files  $src_dir/ram_3b_16d/ram_3b_16d.xci]
generate_target all [get_files  $src_dir/ram_3b_16d/ram_3b_16d.xci]

#ram_8b_256d
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name ram_8b_256d
set_property -dict [list CONFIG.Memory_Type {Simple_Dual_Port_RAM} CONFIG.Assume_Synchronous_Clk {true} CONFIG.Write_Width_A {8} CONFIG.Write_Depth_A {256} CONFIG.Read_Width_A {8} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Write_Width_B {8} CONFIG.Read_Width_B {8} CONFIG.Operating_Mode_B {READ_FIRST} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {false} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Enable_Rate {100}] [get_ips ram_8b_256d]
generate_target {instantiation_template} [get_files $src_dir/ram_8b_256d/ram_8b_256d.xci]
set_property generate_synth_checkpoint false [get_files $src_dir/ram_8b_256d/ram_8b_256d.xci]
generate_target all [get_files $src_dir/ram_8b_256d/ram_8b_256d.xci]

#fifo_3b_16d
create_ip -name fifo_generator -vendor xilinx.com -library ip -version 13.2 -module_name fifo_3b_16d
set_property -dict [list CONFIG.Fifo_Implementation {Common_Clock_Block_RAM} CONFIG.Input_Data_Width {3} CONFIG.Input_Depth {16} CONFIG.Output_Data_Width {3} CONFIG.Output_Depth {16} CONFIG.Use_Embedded_Registers {false} CONFIG.Reset_Type {Asynchronous_Reset} CONFIG.Full_Flags_Reset_Value {1} CONFIG.Data_Count_Width {4} CONFIG.Write_Data_Count_Width {4} CONFIG.Read_Data_Count_Width {4} CONFIG.Full_Threshold_Assert_Value {14} CONFIG.Full_Threshold_Negate_Value {13} CONFIG.Enable_Safety_Circuit {true}] [get_ips fifo_3b_16d]
generate_target {instantiation_template} [get_files $src_dir/fifo_3b_16d/fifo_3b_16d.xci]
#update_compile_order -fileset sources_1
set_property generate_synth_checkpoint false [get_files $src_dir/fifo_3b_16d/fifo_3b_16d.xci]
generate_target all [get_files $src_dir/fifo_3b_16d/fifo_3b_16d.xci]

#fifo_1b_32d
create_ip -name fifo_generator -vendor xilinx.com -library ip -version 13.2 -module_name fifo_1b_32d
set_property -dict [list CONFIG.Fifo_Implementation {Common_Clock_Block_RAM} CONFIG.Input_Data_Width {1} CONFIG.Input_Depth {32} CONFIG.Output_Data_Width {1} CONFIG.Output_Depth {32} CONFIG.Use_Embedded_Registers {false} CONFIG.Reset_Type {Asynchronous_Reset} CONFIG.Full_Flags_Reset_Value {1} CONFIG.Data_Count_Width {5} CONFIG.Write_Data_Count_Width {5} CONFIG.Read_Data_Count_Width {5} CONFIG.Full_Threshold_Assert_Value {30} CONFIG.Full_Threshold_Negate_Value {29} CONFIG.Enable_Safety_Circuit {true}] [get_ips fifo_1b_32d]
generate_target {instantiation_template} [get_files $src_dir/fifo_1b_32d/fifo_1b_32d.xci]
set_property generate_synth_checkpoint false [get_files $src_dir/fifo_1b_32d/fifo_1b_32d.xci]
generate_target all [get_files $src_dir/fifo_1b_32d/fifo_1b_32d.xci]

#read_ip $action_root/ip/fifo_1b_32d.xcix
#generate_target all [get_ips fifo_1b_32d]
#synth_ip [get_ips fifo_1b_32d]
#get_files -all -of_objects [get_files fifo_1b_32d.xcix]


#read_ip $action_root/ip/fifo_3b_16d.xcix
#generate_target all [get_ips fifo_3b_16d]
#synth_ip [get_ips fifo_3b_16d]
#get_files -all -of_objects [get_files fifo_3b_16d.xcix]


#read_ip $action_root/ip/mult_8bs_4bs.xcix
#generate_target all [get_ips mult_8bs_4bs]
#synth_ip [get_ips mult_8bs_4bs]
#get_files -all -of_objects [get_files mult_8bs_4bs.xcix]


#read_ip $action_root/ip/ram_3b_16d.xcix
#generate_target all [get_ips ram_3b_16d]
#synth_ip [get_ips ram_3b_16d]
#get_files -all -of_objects [get_files ram_3b_16d.xcix]


#read_ip $action_root/ip/ram_8b_256d.xcix
#generate_target all [get_ips ram_8b_256d]
#synth_ip [get_ips ram_8b_256d]
#get_files -all -of_objects [get_files ram_8b_256d.xcix]

close_project

puts "\[CREATE_ACTION_IPs..........\] done  [clock format [clock seconds] -format {%T %a %b %d %Y}]"
