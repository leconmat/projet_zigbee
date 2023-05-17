module bit_recovery_CDR(
			input logic clk_i,
           		input logic resetn_i,
			input logic signed [5:0] phase_i,
			input logic ph_valid_i,
			output logic data_en_o,
           		output logic data_o
			);
logic data_w;

bit_recovery i_bit_recovery(
			  .clk(clk_i),
                    	  .resetn(resetn_i),
                    	  .phase(phase_i),
                    	  .ph_valid(ph_valid_i),
                    	  .data_bits(data_w)
			);

cdr i_cdr(
	.clk(clk_i),
        .resetn_i(resetn_i),
        .data_i(data_w),
        .data_en_o(data_en_o),
        .data_o(data_o)
        );


endmodule
