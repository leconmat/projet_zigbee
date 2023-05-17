# Get all attributes specify in synth_attributes.do
source synth_attributes.do

set rtlFolder "$::env(PROJECT_DIR)/modules/$::env(IPmodule)/rtl/src/"

if {$vars(is_hierarchical)} {
	foreach submodule $vars(submodules) {
		lappend $rtlFolder "$::env(PROJECT_DIR)/modules/$submodule/rtl/src/"
	}
}

# Recover design files in the rtl directory
set files [glob $rtlFolder *.{sv,v,vhd}]

# Read design
foreach file $files {
	analyze -library WORK -autoread $file
}
elaborate $vars(top_level_module) -library WORK

check_design

# Specify the clock
create_clock -name "clk" -period $vars(clock_period) -waveform [list 0 [expr {$vars(clock_period)/2.0}] ] $vars(clk_net)

# Specify the max area to 0. Allow design_compiler to synthetize with the minimum surface
set_max_area 0


# Specify each corner for synthesis
set corners {BEST TYPICAL WORST}
foreach corner $corners {
	puts "The actual corner is ${corner}"
	set_operating_conditions -library c35_CORELIB_TYP $corner
	compile -exact_map -map_effort $vars(map_effort) -area_effort $vars(area_effort) -power_effort $vars(power_effort) -incremental_mapping -ungroup_al
  
	set rptDir "REPORTS/${corner}"
	file mkdir ${rptDir}
	uplevel #0 { report_design -nosplit } > ${rptDir}/${corner}_design.rpt
	uplevel #0 { report_constraint -significant_digits 2 } > ${rptDir}/${corner}_constraints.rpt
	uplevel #0 { report_clock -attribute } > ${rptDir}/${corner}_clock.rpt
	uplevel #0 { report_area } > ${rptDir}/${corner}_area.rpt
	uplevel #0 { report_compile_options -nosplit } > ${rptDir}/${corner}_compile_options.rpt
	uplevel #0 { report_power -analysis_effort high } > ${rptDir}/${corner}_power.rpt
	uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 4 -sort_by group } > ${rptDir}/${corner}_timing.rpt
}

file mkdir synthesis_RTL
write -hierarchy -format verilog -output synthesis_RTL/$vars(top_level_module).v

exit 0
