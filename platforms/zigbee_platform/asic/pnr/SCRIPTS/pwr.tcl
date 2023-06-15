# Add power ring
setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer MET4 -stacked_via_bottom_layer MET1 -via_using_exact_crossover_size 1 -orthogonal_only true -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addRing -nets {vdd! gnd!} -type core_rings -follow io -exclude_selected 1 -layer {top MET3 bottom MET3 left MET4 right MET4} -width {top 20 bottom 20 left 20 right 20} -spacing {top 5 bottom 5 left 5 right 5} -offset {top 5 bottom 5 left 5 right 5} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None

# Add power stripes
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer MET4 -stacked_via_bottom_layer MET1 -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog { padcore_ring  block_ring } -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape   }
addStripe -nets {gnd! vdd!} -layer MET4 -direction vertical -width 10 -spacing 0.8 -number_of_sets 6 -start_from left -start_offset 30 -stop_offset 30 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit MET4 -padcore_ring_bottom_layer_limit MET1 -block_ring_top_layer_limit MET4 -block_ring_bottom_layer_limit MET1 -use_wire_group 0 -snap_wire_center_to_grid None

# Connecting power stripes to core
clearGlobalNets
globalNetConnect vdd! -type pgpin -pin vdd! -instanceBasename * -hierarchicalInstance {}
globalNetConnect gnd! -type pgpin -pin gnd! -instanceBasename * -hierarchicalInstance {}
globalNetConnect vdd! -type pgpin -pin A -instanceBasename PWR1 -hierarchicalInstance {}
globalNetConnect gnd! -type pgpin -pin A -instanceBasename GND1 -hierarchicalInstance {}
globalNetConnect vdd! -type pgpin -pin A -instanceBasename PWR2 -hierarchicalInstance {}
globalNetConnect gnd! -type pgpin -pin A -instanceBasename GND2 -hierarchicalInstance {}

sroute
