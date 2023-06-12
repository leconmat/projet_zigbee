#######################################################
#                                                     
#  Name: run.tcl
#  Description: Main script for flow.
#                                                     
#######################################################

# Initialize the design
source "./SCRIPTS/init.tcl"

# Define the floorplan (size of the chip and margin between core and IOs)
floorPlan -noSnapToGrid -site standard -d 1958.8 1958.8 55.0 55.0 55.0 55.0

addIoFiller -cell {PERI_SPACER_5_P PERI_SPACER_50_P PERI_SPACER_2_P PERI_SPACER_20_P PERI_SPACER_1_P PERI_SPACER_10_P PERI_SPACER_100_P PERI_SPACER_01_P} -prefix PADFILLER 

source "./SCRIPTS/pwr.tcl"

# Because AMS 350ns
setDesignMode -process 250

# Adding decoupling capacitors
setEndCapMode -rightEdge ENDCAPR -leftEdge ENDCAPL -prefix ENDCAP
addEndCap -prefix ENDCAP

# Place standard cells
setPlaceMode -padForPinNearBorder true
#place_design
optDesign -preCTS
place_opt_design

# Check placement
checkPlace

# Clock tree synthesis
setCTSMode  -engine ccopt
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
