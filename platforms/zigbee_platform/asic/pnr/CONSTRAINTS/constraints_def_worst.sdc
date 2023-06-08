source $vars(data_dir)/constraints_variables.sdc

#---------------------------------------------------------
# Input
#---------------------------------------------------------

#set_input_transition $input_transition_min_worst -min [get_ports "CLK"]
#set_input_transition $input_transition_min_worst -min [get_ports "RESET"]
#set_input_transition $input_transition_min_worst -min [get_ports "Filter_In"]
#set_input_transition $input_transition_min_worst -min [get_ports "ADC_Eocb"]
#
#set_input_transition $input_transition_max_worst -max [get_ports "CLK"]
#set_input_transition $input_transition_max_worst -max [get_ports "RESET"]
#set_input_transition $input_transition_max_worst -max [get_ports "Filter_In"]
#set_input_transition $input_transition_max_worst -max [get_ports "ADC_Eocb"]
#
#set_load -pin_load $std_load_worst [get_ports "CLK"]
#set_load -pin_load $std_load_worst [get_ports "RESET"]
#set_load -pin_load $std_load_worst [get_ports "Filter_In"]
#set_load -pin_load $std_load_worst [get_ports "ADC_Eocb"]
#
#
##---------------------------------------------------------
## Output
##---------------------------------------------------------
#set_max_capacitance $max_cap_worst  [get_ports "Filter_Out"]
#set_max_capacitance $max_cap_worst  [get_ports "ADC_Convstb"]
#set_max_capacitance $max_cap_worst  [get_ports "ADC_Rdb"]
#set_max_capacitance $max_cap_worst  [get_ports "ADC_csb"]
#set_max_capacitance $max_cap_worst  [get_ports "DAC_WRb"]
#set_max_capacitance $max_cap_worst  [get_ports "DAC_csb"]
#set_max_capacitance $max_cap_worst  [get_ports "LDACb"]
#set_max_capacitance $max_cap_worst  [get_ports "CLRB"]
