timeunit 1ns;
timeprecision 1ns;

module demodulation(
	input logic clk,
	input logic resetn,
	input bit ADC_rdy,
	input logic signed [4:0] I_IF,
	input logic signed [4:0] Q_IF,
	input logic signed [1:0] sine_in,
	input logic signed [1:0] cosine_in,
	output logic signed [4:0] I_BB, 
	output logic signed [4:0] Q_BB,
	output bit demod_rdy
);

	logic signed [6:0] I_BB_f;
	logic signed [6:0] Q_BB_f;
	logic signed [6:0] IS;
	logic signed [6:0] IC;
	logic signed [6:0] QS;
	logic signed [6:0] QC;


	enable validation(	.clk(clk),
				.resetn(resetn),
				.ADC_rdy(ADC_rdy),
				.demod_rdy(demod_rdy)
	);

	/*fsm sincos (		.clk(clk),
				.resetn(resetn),
				.cosine_out(cosine_in),
				.sine_out(sine_in)
	);
	always_ff @(posedge clk, negedge resetn)
		begin
			if (~resetn) 
			begin
				I_BB <= 0;
				Q_BB <= 0;
			end
		end //always ff
	*/
	/*always_comb
	begin
		if ( (sine_in == 2'b00) && (cosine_in == 2'b01) ) 
		begin
			IS = 0;
			QS = 0;
			IC = I_IF;
			QC = Q_IF;
		end
		else if ( (sine_in == 2'b01) && (cosine_in == 2'b00) ) 
		begin
			IS = I_IF;
			QS = Q_IF;
			IC = 0;
			QC = 0;
		end
		else if ( (sine_in == 2'b00) && (cosine_in == 2'b11) ) 
		begin
			IS = 0;
			QS = 0;
			IC = ((~I_IF)+(1'b1));
			QC = ((~Q_IF)+(1'b1));
		end
		else if ( (sine_in == 2'b11) && (cosine_in == 2'b00) ) 
		begin
			IS = ((~I_IF)+1'b1);
			QS = ((~Q_IF)+1'b1);
			IC = 0;
			QC = 0;
		end
		else 
		begin
			IS = 0;
			QS = 0;
			IC = 0;
			QC = 0;
		end
	end //always comb*/
	assign IS = sine_in * I_IF;
	assign IC = cosine_in * I_IF;
	assign QS = sine_in * Q_IF;
	assign QC = cosine_in * Q_IF;	
	assign I_BB_f = IC/*[6:2]*/ - QS/*[6:2]*/;
	assign Q_BB_f = IS/*[6:2]*/ + QC/*[6:2]*/;
	assign I_BB[4:0] = I_BB_f[4:0];
	assign Q_BB[4:0] = Q_BB_f[4:0];

endmodule