module top_iq_demod(
	input logic clk,
	input logic resetn,
	input bit ADC_rdy, // on reçoit ça de l'ADC
	input logic signed [4:0] I_IF,
	input logic signed [4:0] Q_IF,
	output bit demod_iq_valid, // on envoie ça au cordiq
	output logic signed [4:0] I_BB,
	output logic signed [4:0] Q_BB
);

logic signed [4:0] I_BB_IN, Q_BB_IN;
logic signed [1:0] sine_IN, cosine_IN; 
bit  filter_en, valid_out_I, valid_out_Q; // demod sort filter_en et le filter le reçoit en entrée, c'est les signaux de valid interne 
/*demodulation demod(
	.clk(clk),
	.resetn(resetn),
	.ADC_rdy(ADC_rdy),
	.I_IF(I_IF),
	.Q_IF(Q_IF),
	.sine_in(sine_IN),
	.cosine_in(cosine_IN),
	.I_BB(I_BB_IN),
	.Q_BB(Q_BB_IN),
	.demod_rdy(filter_en)
);*/

filter_20 filtre_I (
	.clk(clk),
	.resetn(resetn),
	.in_valid(filter_en),
	.data_in(I_BB_IN),
	.data_out(I_BB),
	.out_valid(valid_out_I)
);
/*filter_20 filtre_Q (
	.clk(clk),
	.resetn(resetn),
	.in_valid(filter_en),
	.data_in(Q_BB_IN),
	.data_out(Q_BB),
	.out_valid(valid_out_Q)
);*/

assign I_BB_IN = I_IF;
assign Q_BB_IN = Q_IF;
assign filter_en = ADC_rdy;


fsm gen_sin(
	.clk(clk),               // Main Clock
  	.resetn(resetn),             // Synchronous Active High Reset (More Robust mapping on FPGA)
	.cosine_out(cosine_IN),        
  	.sine_out(sine_IN)
	);

always_comb
begin
	if (valid_out_I && valid_out_Q) begin
	for (integer i = 0; i < 100; i++)begin // on attend un cycle avant de l'envoyer pour pas tout désynchro
	demod_iq_valid = 1;
	end
	end 
	else demod_iq_valid = 0;
end
endmodule
