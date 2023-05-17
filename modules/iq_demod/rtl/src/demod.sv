timeunit 1ns;
timeprecision 1ns;

module demod(

	input logic clk,
	input logic resetn,

	input logic [4:0] I_IF,
	input logic [4:0] Q_IF,

	input logic [1:0] sine_in,
	input logic [1:0] cosine_in,

	output logic [4:0] I_BB,
	output logic [4:0] Q_BB

);

	logic [4:0] IS;
	logic [4:0] IC;
	logic [4:0] QS;
	logic [4:0] QC;

always_comb
	begin
		if (~resetn) begin
			IS = 0;
			QS = 0;
			IC = 0;
			QC = 0;
		end
		else begin
			if ( (sine_in == 2'b00) && (cosine_in == 2'b01) ) begin
				IS = 0;
				QS = 0;
				IC = I_IF;
				QC = Q_IF;
			end
			else if ( (sine_in == 2'b01) && (cosine_in == 2'b00) ) begin
				IS = I_IF;
				QS = Q_IF;
				IC = 0;
				QC = 0;
			end
			else if ( (sine_in == 2'b00) && (cosine_in == 2'b11) ) begin
				IS = 0;
				QS = 0;
				IC = (~I_IF+(1'b1));
				QC = (~Q_IF+(1'b1));
			end
			else if ( (sine_in == 2'b11) && (cosine_in == 2'b00) ) begin
				IS = (~I_IF+(1'b1));
				QS = (~Q_IF+(1'b1));
				IC = 0;
				QC = 0;
			end
			else begin
				IS = 0;
				QS = 0;
				IC = 0;
				QC = 0;
			end
		end
	end

assign I_BB = IC - QS ;
assign Q_BB = IS + QC ;

endmodule
