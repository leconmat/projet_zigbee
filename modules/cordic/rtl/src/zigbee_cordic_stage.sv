module zigbee_cordic_stage 
	#(parameter integer NUM_STAGE, XY_SIZE, W_SIZE,
	  parameter [W_SIZE-1:0] CONST_TAN) (

	Xin, Yin, Win,
	Xout, Yout, Wout
	);

	input logic signed [XY_SIZE-1:0] Xin, Yin;
	input logic signed [W_SIZE-1:0] Win;

	output logic signed [XY_SIZE-1:0] Xout, Yout;
	output logic signed [W_SIZE-1:0] Wout;

	logic signed [XY_SIZE-1:0] Xin_shifted, Yin_shifted;

	assign Xin_shifted = Xin >>> NUM_STAGE;
	assign Yin_shifted = Yin >>> NUM_STAGE;

	always_comb
	begin
		if (!Yin[XY_SIZE-1]) // If Yin is positive
		begin
			Xout <= Xin + Yin_shifted;
			Yout <= Yin - Xin_shifted;
			Wout <= Win + CONST_TAN;
		end
		else 				// If Yin is negative
		begin
			Xout <= Xin - Yin_shifted;
			Yout <= Yin + Xin_shifted;
			Wout <= Win - CONST_TAN;
		end
	end
endmodule
