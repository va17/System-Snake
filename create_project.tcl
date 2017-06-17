#
# Vivado (TM) v2015.3 (64-bit)
#
# create_project.tcl: Tcl script for re-creating project 'snake_project'
#
# Generated by Vivado on Fri Mar 18 15:46:03 -0400 2016
# IP Build 1367837 on Mon Sep 28 08:56:14 MDT 2015
#
# This file contains the Vivado Tcl commands for re-creating the project to the state*
# when this script was generated. In order to re-create the project, please source this
# file in the Vivado Tcl Shell.
#
# * Note that the runs in the created project will be configured the same way as the
#   original project, however they will not be launched automatically. To regenerate the
#   run results please launch the synthesis/implementation runs as needed.
#
#*****************************************************************************************
# NOTE: In order to use this script for source control purposes, please make sure that the
#       following files are added to the source control system:-
#
# 1. This project restoration tcl script (create_project.tcl) that was generated.
#
# 2. The following source(s) files that were local or imported into the original project.
#    (Please see the '$orig_proj_dir' and '$origin_dir' variable setting below at the start of the script)
#
#    <none>
#
# 3. The following remote source files that were added to the original project:-
#
#    "C:/Xilinx/Projects/snake_project/snake_project.srcs/sources_1/new/snake_source.sv"
#    "C:/Xilinx/Projects/snake_project/snake_project.srcs/sources_1/new/interface_header.vh"
#    "C:/Xilinx/Projects/snake_project/snake_project.srcs/sources_1/new/vga_controller_header.vh"
#    "C:/Xilinx/Projects/snake_project/snake_project.srcs/sources_1/new/snake_header.vh"
#    "C:/Xilinx/Projects/snake_project/snake_project.srcs/sources_1/new/top_module.sv"
#    "C:/Xilinx/Projects/snake_project/snake_project.srcs/sources_1/new/vga_controller_source.sv"
#    "C:/Xilinx/Projects/snake_project/snake_project.srcs/sources_1/new/random_source.sv"
#    "C:/Xilinx/Projects/snake_project/snake_project.srcs/sources_1/new/random_header.vh"
#    "C:/Xilinx/Projects/snake_project/snake_project.srcs/sources_1/ip/clk_wiz_pixel/clk_wiz_pixel.xci"
#    "C:/Xilinx/Projects/snake_project/snake_project.srcs/constrs_1/new/nexysddr_master.xdc"
#    "C:/Xilinx/Projects/snake_project/snake_project.srcs/sim_1/new/simulate_test_snake_controller.sv"
#    "C:/Xilinx/Projects/snake_project/snake_project.srcs/sim_1/new/simulate_score_module.sv"
#
#*****************************************************************************************

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

variable script_file
set script_file "create_project.tcl"

# Help information for this script
proc help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < [llength $::argc]} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir" { incr i; set origin_dir [lindex $::argv $i] }
      "--help"       { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/"]"

# Create project
create_project snake_project ./snake_project

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [get_projects snake_project]
set_property "board_part" "" $obj
set_property "compxlib.activehdl_compiled_library_dir" "$proj_dir/snake_project.cache/compile_simlib/activehdl" $obj
set_property "compxlib.funcsim" "1" $obj
set_property "compxlib.ies_compiled_library_dir" "$proj_dir/snake_project.cache/compile_simlib/ies" $obj
set_property "compxlib.modelsim_compiled_library_dir" "$proj_dir/snake_project.cache/compile_simlib/modelsim" $obj
set_property "compxlib.overwrite_libs" "0" $obj
set_property "compxlib.questa_compiled_library_dir" "$proj_dir/snake_project.cache/compile_simlib/questa" $obj
set_property "compxlib.riviera_compiled_library_dir" "$proj_dir/snake_project.cache/compile_simlib/riviera" $obj
set_property "compxlib.timesim" "1" $obj
set_property "compxlib.vcs_compiled_library_dir" "$proj_dir/snake_project.cache/compile_simlib/vcs" $obj
set_property "corecontainer.enable" "0" $obj
set_property "default_lib" "xil_defaultlib" $obj
set_property "enable_optional_runs_sta" "0" $obj
set_property "ip_cache_permissions" "" $obj
set_property "ip_output_repo" "" $obj
set_property "managed_ip" "0" $obj
set_property "part" "xc7a100tcsg324-1" $obj
set_property "sim.ip.auto_export_scripts" "1" $obj
set_property "simulator_language" "Mixed" $obj
set_property "source_mgmt_mode" "DisplayOnly" $obj
set_property "target_language" "Verilog" $obj
set_property "target_simulator" "XSim" $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/snake_project.srcs/sources_1/new/snake_source.sv"]"\
 "[file normalize "$origin_dir/snake_project.srcs/sources_1/new/interface_header.vh"]"\
 "[file normalize "$origin_dir/snake_project.srcs/sources_1/new/vga_controller_header.vh"]"\
 "[file normalize "$origin_dir/snake_project.srcs/sources_1/new/snake_header.vh"]"\
 "[file normalize "$origin_dir/snake_project.srcs/sources_1/new/top_module.sv"]"\
 "[file normalize "$origin_dir/snake_project.srcs/sources_1/new/vga_controller_source.sv"]"\
 "[file normalize "$origin_dir/snake_project.srcs/sources_1/new/random_source.sv"]"\
 "[file normalize "$origin_dir/snake_project.srcs/sources_1/new/random_header.vh"]"\
 "[file normalize "$origin_dir/snake_project.srcs/sources_1/new/PS2Receiver.v"]"\
 "[file normalize "$origin_dir/snake_project.srcs/sources_1/new/debouncer.v"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/snake_project.srcs/sources_1/new/snake_source.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/snake_project.srcs/sources_1/new/interface_header.vh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/snake_project.srcs/sources_1/new/vga_controller_header.vh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/snake_project.srcs/sources_1/new/snake_header.vh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/snake_project.srcs/sources_1/new/top_module.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/snake_project.srcs/sources_1/new/vga_controller_source.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/snake_project.srcs/sources_1/new/random_source.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/snake_project.srcs/sources_1/new/random_header.vh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj


# Set 'sources_1' fileset file properties for local files
# None

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property "design_mode" "RTL" $obj
set_property "edif_extra_search_paths" "" $obj
set_property "elab_link_dcps" "1" $obj
set_property "elab_load_timing_constraints" "1" $obj
set_property "generic" "" $obj
set_property "include_dirs" "" $obj
set_property "lib_map_file" "" $obj
set_property "loop_count" "1000" $obj
set_property "name" "sources_1" $obj
set_property "top" "top_module" $obj
set_property "verilog_define" "" $obj
set_property "verilog_uppercase" "0" $obj

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/snake_project.srcs/sources_1/ip/clk_wiz_pixel/clk_wiz_pixel.xci"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/snake_project.srcs/sources_1/ip/clk_wiz_pixel/clk_wiz_pixel.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj


# Set 'sources_1' fileset file properties for local files
# None

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/snake_project.srcs/constrs_1/new/nexysddr_master.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "$origin_dir/snake_project.srcs/constrs_1/new/nexysddr_master.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "processing_order" "NORMAL" $file_obj
set_property "scoped_to_cells" "" $file_obj
set_property "scoped_to_ref" "" $file_obj
set_property "used_in" "synthesis implementation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property "name" "constrs_1" $obj
set_property "target_constrs_file" "" $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
set files [list \
 "[file normalize "$origin_dir/snake_project.srcs/sim_1/new/simulate_test_snake_controller.sv"]"\
 "[file normalize "$origin_dir/snake_project.srcs/sim_1/new/simulate_score_module.sv"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sim_1' fileset file properties for remote files
set file "$origin_dir/snake_project.srcs/sim_1/new/simulate_test_snake_controller.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/snake_project.srcs/sim_1/new/simulate_score_module.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj


# Set 'sim_1' fileset file properties for local files
# None

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property "generic" "" $obj
set_property "include_dirs" "" $obj
set_property "name" "sim_1" $obj
set_property "nl.cell" "" $obj
set_property "nl.incl_unisim_models" "0" $obj
set_property "nl.process_corner" "slow" $obj
set_property "nl.rename_top" "" $obj
set_property "nl.sdf_anno" "1" $obj
set_property "nl.write_all_overrides" "0" $obj
set_property "runtime" "1000ns" $obj
set_property "source_set" "sources_1" $obj
set_property "top" "top_module" $obj
set_property "unit_under_test" "" $obj
set_property "verilog_define" "" $obj
set_property "verilog_uppercase" "0" $obj
set_property "xelab.debug_level" "typical" $obj
set_property "xelab.dll" "0" $obj
set_property "xelab.load_glbl" "1" $obj
set_property "xelab.more_options" "" $obj
set_property "xelab.mt_level" "auto" $obj
set_property "xelab.nosort" "1" $obj
set_property "xelab.rangecheck" "0" $obj
set_property "xelab.relax" "1" $obj
set_property "xelab.sdf_delay" "sdfmax" $obj
set_property "xelab.snapshot" "" $obj
set_property "xelab.unifast" "" $obj
set_property "xsim.compile.xvhdl.more_options" "" $obj
set_property "xsim.compile.xvhdl.nosort" "1" $obj
set_property "xsim.compile.xvhdl.relax" "1" $obj
set_property "xsim.compile.xvlog.more_options" "" $obj
set_property "xsim.compile.xvlog.relax" "1" $obj
set_property "xsim.elaborate.debug_level" "typical" $obj
set_property "xsim.elaborate.load_glbl" "1" $obj
set_property "xsim.elaborate.mt_level" "auto" $obj
set_property "xsim.elaborate.rangecheck" "0" $obj
set_property "xsim.elaborate.relax" "1" $obj
set_property "xsim.elaborate.sdf_delay" "sdfmax" $obj
set_property "xsim.elaborate.snapshot" "" $obj
set_property "xsim.elaborate.xelab.more_options" "" $obj
set_property "xsim.more_options" "" $obj
set_property "xsim.saif" "" $obj
set_property "xsim.simulate.runtime" "1000ns" $obj
set_property "xsim.simulate.saif" "" $obj
set_property "xsim.simulate.saif_all_signals" "0" $obj
set_property "xsim.simulate.uut" "" $obj
set_property "xsim.simulate.wdb" "" $obj
set_property "xsim.simulate.xsim.more_options" "" $obj
set_property "xsim.tclbatch" "" $obj
set_property "xsim.view" "" $obj
set_property "xsim.wdb" "" $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
  create_run -name synth_1 -part xc7a100tcsg324-1 -flow {Vivado Synthesis 2015} -strategy "Vivado Synthesis Defaults" -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2015" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property "constrset" "constrs_1" $obj
set_property "description" "Vivado Synthesis Defaults" $obj
set_property "flow" "Vivado Synthesis 2015" $obj
set_property "name" "synth_1" $obj
set_property "needs_refresh" "1" $obj
set_property "part" "xc7a100tcsg324-1" $obj
set_property "srcset" "sources_1" $obj
set_property "strategy" "Vivado Synthesis Defaults" $obj
set_property "incremental_checkpoint" "" $obj
set_property "include_in_archive" "1" $obj
set_property "steps.synth_design.tcl.pre" "" $obj
set_property "steps.synth_design.tcl.post" "" $obj
set_property "steps.synth_design.args.flatten_hierarchy" "rebuilt" $obj
set_property "steps.synth_design.args.gated_clock_conversion" "off" $obj
set_property "steps.synth_design.args.bufg" "12" $obj
set_property "steps.synth_design.args.fanout_limit" "10000" $obj
set_property "steps.synth_design.args.directive" "Default" $obj
set_property "steps.synth_design.args.fsm_extraction" "auto" $obj
set_property "steps.synth_design.args.keep_equivalent_registers" "0" $obj
set_property "steps.synth_design.args.resource_sharing" "auto" $obj
set_property "steps.synth_design.args.control_set_opt_threshold" "auto" $obj
set_property "steps.synth_design.args.no_lc" "0" $obj
set_property "steps.synth_design.args.shreg_min_size" "3" $obj
set_property "steps.synth_design.args.max_bram" "-1" $obj
set_property "steps.synth_design.args.max_dsp" "-1" $obj
set_property "steps.synth_design.args.cascade_dsp" "auto" $obj
set_property -name {steps.synth_design.args.more options} -value {} -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
  create_run -name impl_1 -part xc7a100tcsg324-1 -flow {Vivado Implementation 2015} -strategy "Vivado Implementation Defaults" -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2015" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property "constrset" "constrs_1" $obj
set_property "description" "Vivado Implementation Defaults" $obj
set_property "flow" "Vivado Implementation 2015" $obj
set_property "name" "impl_1" $obj
set_property "needs_refresh" "1" $obj
set_property "part" "xc7a100tcsg324-1" $obj
set_property "srcset" "sources_1" $obj
set_property "strategy" "Vivado Implementation Defaults" $obj
set_property "incremental_checkpoint" "" $obj
set_property "include_in_archive" "1" $obj
set_property "steps.opt_design.is_enabled" "1" $obj
set_property "steps.opt_design.tcl.pre" "" $obj
set_property "steps.opt_design.tcl.post" "" $obj
set_property "steps.opt_design.args.verbose" "0" $obj
set_property "steps.opt_design.args.directive" "Default" $obj
set_property -name {steps.opt_design.args.more options} -value {} -objects $obj
set_property "steps.power_opt_design.is_enabled" "0" $obj
set_property "steps.power_opt_design.tcl.pre" "" $obj
set_property "steps.power_opt_design.tcl.post" "" $obj
set_property -name {steps.power_opt_design.args.more options} -value {} -objects $obj
set_property "steps.place_design.tcl.pre" "" $obj
set_property "steps.place_design.tcl.post" "" $obj
set_property "steps.place_design.args.directive" "Default" $obj
set_property -name {steps.place_design.args.more options} -value {} -objects $obj
set_property "steps.post_place_power_opt_design.is_enabled" "0" $obj
set_property "steps.post_place_power_opt_design.tcl.pre" "" $obj
set_property "steps.post_place_power_opt_design.tcl.post" "" $obj
set_property -name {steps.post_place_power_opt_design.args.more options} -value {} -objects $obj
set_property "steps.phys_opt_design.is_enabled" "0" $obj
set_property "steps.phys_opt_design.tcl.pre" "" $obj
set_property "steps.phys_opt_design.tcl.post" "" $obj
set_property "steps.phys_opt_design.args.directive" "Default" $obj
set_property -name {steps.phys_opt_design.args.more options} -value {} -objects $obj
set_property "steps.route_design.tcl.pre" "" $obj
set_property "steps.route_design.tcl.post" "" $obj
set_property "steps.route_design.args.directive" "Default" $obj
set_property -name {steps.route_design.args.more options} -value {} -objects $obj
set_property "steps.post_route_phys_opt_design.is_enabled" "0" $obj
set_property "steps.post_route_phys_opt_design.tcl.pre" "" $obj
set_property "steps.post_route_phys_opt_design.tcl.post" "" $obj
set_property "steps.post_route_phys_opt_design.args.directive" "Default" $obj
set_property -name {steps.post_route_phys_opt_design.args.more options} -value {} -objects $obj
set_property "steps.write_bitstream.tcl.pre" "" $obj
set_property "steps.write_bitstream.tcl.post" "" $obj
set_property "steps.write_bitstream.args.raw_bitfile" "0" $obj
set_property "steps.write_bitstream.args.mask_file" "0" $obj
set_property "steps.write_bitstream.args.no_binary_bitfile" "0" $obj
set_property "steps.write_bitstream.args.bin_file" "1" $obj
set_property "steps.write_bitstream.args.readback_file" "0" $obj
set_property "steps.write_bitstream.args.logic_location_file" "0" $obj
set_property "steps.write_bitstream.args.verbose" "0" $obj
set_property -name {steps.write_bitstream.args.more options} -value {} -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:snake_project"
