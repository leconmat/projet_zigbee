source $vars(data_dir)/constraints_variables.sdc

##-- oO0 Uncertainty 0Oo---------------------------------- 
#set_clock_uncertainty -setup $clock_uncertainty(setup) [get_clocks "clk"]
#set_clock_uncertainty -hold  $clock_uncertainty(hold)  [get_clocks "clk"]
