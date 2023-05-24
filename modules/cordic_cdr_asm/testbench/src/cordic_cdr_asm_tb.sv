// File: cordic_cdr_asm_tb.sv
// Authors: Nathan Hocquette
// Description: Testbench for the cordic + CDR module (assembly)

`timescale 1ns/100ps
`define PERIOD 20ns
`define BITSTREAM_SIZE 100

module cordic_cdr_asm_tb (
	);
	parameter integer AMPLITUDE = 15;
	parameter real PI = 3.14159265359;

	logic clk;
	logic reset_n;

	//CORDIC I/O
	logic [4:0] ibb;
	logic [4:0] qbb;
	logic iValid = 0;

	//CDR Outputs
	logic bitstream_o;
	logic bitstream_en;	

	//Stimulation signals
	bit newBit;
	bit bitstream_i[$];
	real angle = 0;
	real dataPassed = 0;
	real dataFailed = 0;

	//DUT
	cordic_cdr_asm_top DUT(
		.clk(clk),
		.reset_n(reset_n),
		.ibb(ibb),
		.qbb(qbb),
		.iValid(iValid),
		.bitstream(bitstream_o),
		.bitstream_en(bitstream_en)
	);

	//global clk
	initial
	begin
		clk = 1;
		forever #(`PERIOD / 2) clk = ~clk;
	end

	//reset
	initial
	begin
		reset_n = 0;
		#500 reset_n = 1;
	end

	//Stimulation
	initial	forever
		if(reset_n)
		begin
			//bit phase generation
			newBit = $urandom();

			bitstream_i.push_back(newBit);				

			for(integer i = 0; i < 5; i = i + 1)
			begin
				if(newBit)
					angle = angle + PI / (2 * 5);
				else
					angle = angle - PI / (2 * 5);

				angle = angle + (($urandom() % 1000) / 10000) - 0.05;

				//wrapper
				if (angle < 0)
					angle = angle + 2 * PI;
				if (angle > 2 * PI)
					angle = angle - 2 * PI;

				//IQ generation
				ibb = int'($cos(angle) * AMPLITUDE);
				qbb = int'($sin(angle) * AMPLITUDE);

				iValid = 1;

				@(posedge clk);
				iValid = 0;
				@(posedge clk);
				@(posedge clk);
				@(posedge clk);
				@(posedge clk);
			end
		end
		else #1;

	initial forever @(negedge bitstream_en)
		if(bitstream_o != bitstream_i.pop_front())
		begin
			dataFailed = dataFailed + 1;
			$display("Invalid output bitstream");
		end
		else
			dataPassed = dataPassed + 1;

endmodule
