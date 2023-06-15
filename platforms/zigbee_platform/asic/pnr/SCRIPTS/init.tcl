#######################################################
#                                                     
#  Name: init.tcl
#  Description: Initialize the design in Innovus
#                                                     
#######################################################
source "./SCRIPTS/vars.tcl"
source "./SCRIPTS/amsSetup.tcl"

set init_verilog [list \
	"./VERILOG/zigbee_platform.v" \
	"./VERILOG/zigbee_top_pad.v"
]
set init_mmmc_file "./SCRIPTS/view_definition.tcl"
set init_lef_file [list \
	"/softslin/AMS_410_ISR15/cds/HK_C35/LEF/c35b4/c35b4.lef_back" \
	"/softslin/AMS_410_ISR15/cds/HK_C35/LEF/c35b4/CORELIB.lef" \
	"./INPUT_DATA/IOLIB_4M.lef"
]
set init_top_cell "zigbee_top_pad"
set init_gnd_net [list gnd! gnd3r! gnd3o!]
set init_pwr_net [list vdd! vdd3r1! vdd3r2! vdd3o!]
set cts_cell_list [list CLKIN0 CLKIN1 CLKIN2 CLKIN3 CLKIN4 CLKIN6 CLKIN8 CLKIN10 CLKIN12 CLKIN15 CLKBU2 CLKBU4 CLKBU6 CLKBU8 CLKBU12 CLKBU15]

init_design
loadIoFile "./INPUT_DATA/zigbee_top_pad.io"
