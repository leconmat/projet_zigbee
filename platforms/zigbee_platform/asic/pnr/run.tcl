#######################################################
#                                                     
#  Name: run.tcl
#  Description: Main script for flow.
#                                                     
#######################################################

# Initialize the design
source "./SCRIPTS/init.tcl"

source "./SCRIPTS/pwr.tcl"

# Because AMS 350ns
setDesignMode -process 250

# Adding decoupling capacitors
setEndCapMode -rightEdge ENDCAPR -leftEdge ENDCAPL -prefix ENDCAP
addEndCap -prefix ENDCAP

setPlaceMode -padForPinNearBorder true
setOptMode -usefulSkew true

# Création des group paths
set_interactive_constraint_modes [all_constraint_modes -active]
reset_path_group -all
reset_path_exception

set input_ports [all_inputs -no_clocks]
set output_ports [all_outputs]
set rams [get_cells -quiet -hierarchical * -filter "is_memory_cell==true"]

set gated_all [filter_collection [all_registers] "is_integrated_clock_gating_cell == true"]
set gated_rtl [get_cells -quiet -hierarchical * -filter "hierarchical_name =~ *GATED"]
set gated_synth [remove_from_collection $gated_all $gated_rtl]

set seqs [all_registers]
set tmp1 [remove_from_collection $seqs $gated_all]
set regs [remove_from_collection $tmp1 $rams]

#Options for path_groups
set_interactive_constraint_modes {}
setPathGroupOptions reg2reg 	-effortLevel high -slackAdjustment 0
setPathGroupOptions in2reg 	-effortLevel high -slackAdjustment 0
setPathGroupOptions reg2out 	-effortLevel high -slackAdjustment 0
setPathGroupOptions in2out 	-effortLevel high -slackAdjustment 0
setPathGroupOptions reg2gated 	-effortLevel high -slackAdjustment 0
setPathGroupOptions in2gated 	-effortLevel high -slackAdjustment 0
setPathGroupOptions my_path 	-effortLevel high -slackAdjustment 0

#Registers
group_path -name reg2reg 	-from $regs 		-to $regs
group_path -name in2reg 	-from $input_ports 	-to $regs
group_path -name reg2out 	-from $regs 		-to $output_ports
group_path -name in2out 	-from $input_ports 	-to $output_ports
group_path -name reg2gated 	-from $regs 		-to $gated_all
group_path -name in2gated 	-from $input_ports 	-to $gated_all

# Place standard cells
place_opt_design

setOptMode -fixDRC true
setOptMode -fixCap true -fixTran  true -fixFanoutLoad false
optDesign -preCTS

# Check placement
checkPlace

# Clock tree synthesis
setCTSMode -engine ccopt
set_ccopt_property use_inverters auto
setCCOptMode -cts_opt_type full
create_ccopt_clock_tree_spec -file ccopt.spec
source ccopt.spec
ccopt_design -cts

# Add fillers
setFillerMode -core {FILLANT1 FILLANT2 FILLANT5 FILLANT10 FILLANT25} -preserveUserOrder true
addFiller -cell FILL25 FILL10 FILL5 FILL2 FILL1 -prefix FILLER

# Circuit route
# First route clock tree because critical path, after the design
routeDesign

streamOut DB/zigbee_platform.gds -mapFile INPUT_DATA/gds2.map -libName DesignLib -units 1000 -mode ALL
