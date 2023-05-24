// File: cordic_cdr_asm_top.sv
// Authors: Nathan Hocquette
// Description: Top module for the cordic + CDR module (assembly)

`timescale 1ns/100ps

module cordic_cdr_asm_top (
		input logic clk,
		input logic reset_n,
		input logic [4:0] ibb,
		input logic [4:0] qbb,
		input logic iValid,
		output logic bitstream,
		output logic bitstream_en
	);

	logic [5:0] w;

	logic data_en_o;
	logic data_o;

	logic cord_valid;

	assign bitstream = data_o;
	assign bitstream_en = data_en_o;

	//CORDIC instantiation
	zigbee_cordic_top CORDIC (
		.clk(clk),
		.reset_n(reset_n),
		.ibb(ibb),
		.qbb(qbb),
		.wout(w),
		.iValid(iValid),
		.oValid(cord_valid)
	);

	//CDR instantiation 
	bit_recovery_CDR BRCDR (
		.clk_i(clk),
           	.resetn_i(reset_n),
		.phase_i(w),
		.ph_valid_i(cord_valid),
		.data_en_o(data_en_o),
           	.data_o(data_o)
	);

endmodule
