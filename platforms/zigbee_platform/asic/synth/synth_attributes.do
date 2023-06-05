####################################
## File: synth_attributes.do
## Description: This file contains all attributes about your design
##              You must specify all of them before run the synthesis
####################################

# Only if the design contains submodules (zigbee_top for example)
set vars(is_hierarchical) 1
set vars(submodules) [list "CDR" \
                           "codiq" \
                           "cordic" \
                           "fifo_rx" \
                           "fifo_tx" \
                           "iq_demod"]

# Design properties
set vars(top_level_module) "zigbee_platform"
set vars(clk_net) "clk_i"
set vars(clock_period) 20

# Compile design options (none, low, medium or high)
# WARNING: For map_effort only medium or high
set vars(map_effort) "high"
set vars(area_effort) "high"
set vars(power_effort) "high"
