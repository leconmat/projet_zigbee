source $vars(data_dir)/constraints_variables.sdc

##-- oO0 Uncertainty 0Oo---------------------------------- 
#set_clock_uncertainty -setup [expr $clock_uncertainty(setup) + $impl_uncertainty(setup)] [get_clocks "clk"]
#set_clock_uncertainty -hold  [expr $clock_uncertainty(hold) + $impl_uncertainty(hold)]  [get_clocks "clk"]

