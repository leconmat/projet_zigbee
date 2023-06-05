module bit_recovery_CDR(
			input logic clk,
      input logic resetn,
			input logic signed [5:0] phase_i,
			input logic ph_valid_i,
			output logic data_en_o,
           		output logic data_o
			);
logic data_w, clk_w, resetn_w;

assign clk_w = clk;
  assign resetn_w = resetn;
bit_recovery i_bit_recovery(
			  .clk(clk_w),
                    	  .resetn(resetn_w),
                    	  .phase(phase_i),
                    	  .ph_valid(ph_valid_i),
                    	  .data_bits(data_w)
			);

cdr i_cdr(
	.clk(clk_w),
        .resetn_i(resetn_w),
        .data_i(data_w),
        .data_en_o(data_en_o),
        .data_o(data_o)
        );


endmodule
