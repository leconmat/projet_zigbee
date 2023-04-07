module zigbee_cordic_top (
	Ibb, Qbb, Wout, Clk
);
	parameter integer NUM_STAGES = 4;
	parameter integer IQ_SIZE = 5;
	parameter integer W_SIZE = 6;

	input logic signed [IQ_SIZE-1:0] Ibb, Qbb;
	output logic signed [W_SIZE-1:0] Wout;
	input logic Clk;

	// DFF buffer for IOs
	logic signed [IQ_SIZE-1:0] Ibb_ibuff, Qbb_ibuff;
	logic signed [W_SIZE-1:0] Wout_obuff;

	always @(posedge Clk)
	begin
		Ibb_ibuff <= Ibb;
		Qbb_ibuff <= Qbb;
		Wout <= Wout_obuff;
	end

	// Cordic stages wires
	logic [IQ_SIZE+1-1:0] cor_x [NUM_STAGES-1+1:0]; //1 stage more than number of cordic stages
	logic [IQ_SIZE+1-1:0] cor_y [NUM_STAGES-1+1:0];
	logic [W_SIZE-1:0] cor_w [NUM_STAGES-1+1:0];
	
	// Stage input assignation
	always_comb
	begin
		if (Ibb_ibuff[IQ_SIZE-1]) // negative
		begin
			cor_y[0] <= {!Qbb_ibuff[IQ_SIZE-1], -Qbb_ibuff};
			cor_x[0] <= {1'b0, -Ibb_ibuff};
			cor_w[0] <= {1'b1, {W_SIZE-1{1'b0}}}; // 180 degree
		end
		else // positive
		begin
			cor_y[0] <= {Qbb_ibuff[IQ_SIZE-1], Qbb_ibuff};
			cor_x[0] <= {1'b0, Ibb_ibuff};
			cor_w[0] <= {W_SIZE{1'b0}}; // 0 degree
		end
	end
	
	// Cordic stages instantiation
	genvar iStage;
	generate
		for (iStage = 0; iStage < NUM_STAGES; iStage = iStage+1)
		begin
			zigbee_cordic_stage #(
				.NUM_STAGE(iStage),
				.XY_SIZE(IQ_SIZE + 1),
				.W_SIZE(W_SIZE),
				.CONST_TAN(1 << (NUM_STAGES - iStage - 1))
				) stage (
				.Xin(cor_x[iStage]),
				.Yin(cor_y[iStage]),
				.Win(cor_w[iStage]),
				.Xout(cor_x[iStage + 1]),
				.Yout(cor_y[iStage + 1]),
				.Wout(cor_w[iStage + 1])
				);
		end
	endgenerate
	
	assign Wout_obuff = cor_w[NUM_STAGES];
endmodule
