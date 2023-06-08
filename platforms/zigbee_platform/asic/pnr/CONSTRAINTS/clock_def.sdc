source $vars(data_dir)/constraints_variables.sdc

#create_clock -name clk  -period $clk_period(clk) -waveform "0 [expr $clk_period(clk)/2]" [get_ports "clk"]
create_clock -name clk  -period $clk_period(clk) -waveform "0 [expr $clk_period(clk)/2]" [get_pins "io_CLK/Y"]
#set_clock_transition 200ps -max [get_clocks "clk"]
#set_clock_latency "$clk_period(clk)ns" -max [get_clocks "clk"]
#set_clock_latency 0ns -min [get_clocks "clk"]

