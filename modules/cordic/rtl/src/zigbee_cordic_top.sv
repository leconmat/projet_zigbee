//////////////////////////////////////////////////////////////////////////////////////////////
// File: zigbee_cordic_top.sv
// Authors: Nathan Hocquette
//          Romain Plumaugat
// Description: Calculate the phase given by ibb and qbb signals
//////////////////////////////////////////////////////////////////////////////////////////////
module zigbee_cordic_top (
	reset_n,
	clk,
	
	// Inputs
	ibb,
	qbb,

	// Outputs
	wout
	);



	//////////////////////////////////////////////////////////////////////////////////////////////
	// Wires and parameters declarations
	//////////////////////////////////////////////////////////////////////////////////////////////
	// CORDIC parameters
	parameter integer NUM_STAGES = 4; // Numbers of stages in the full CORDIC
	parameter integer IQ_SIZE = 5; // Size of primary inputs in bits
	parameter integer W_SIZE = 6; // Size of the final angle in bits

	// IOs and Clock declarations
	input wire signed [IQ_SIZE-1:0] ibb, qbb;
	output wire signed [W_SIZE-1:0] wout;
	input wire clk, reset_n;

	// DFF buffer for IOs
	reg [IQ_SIZE-1:0] ibb_ibuff, qbb_ibuff;
	reg [W_SIZE-1:0] wout_obuff;

	// Cordic stages wires
	// 1 wires stage more than number of cordic stages
	reg [IQ_SIZE+1-1:0] cor_x_s0 [2-1+1:0];
	reg [IQ_SIZE+1-1:0] cor_y_s0 [2-1+1:0];
	reg [W_SIZE-1:0] cor_w_s0 [2-1+1:0];
	
	reg [IQ_SIZE+1-1:0] cor_x_s1 [NUM_STAGES-1+1:2];
	reg [IQ_SIZE+1-1:0] cor_y_s1 [NUM_STAGES-1+1:2];
	reg [W_SIZE-1:0] cor_w_s1 [NUM_STAGES-1+1:2];

	always @(posedge clk, negedge reset_n) begin
		if(!reset_n) begin
			cor_x_s1[2] <= 0;
			cor_y_s1[2] <= 0;
			cor_w_s1[2] <= 0;
		end
		else begin
			cor_x_s1[2] <= cor_x_s0[2];
			cor_y_s1[2] <= cor_y_s0[2];
			cor_w_s1[2] <= cor_w_s0[2];
		end
	end



	//////////////////////////////////////////////////////////////////////////////////////////////
	// Wiring of the CORDIC TOP
	//////////////////////////////////////////////////////////////////////////////////////////////
	// Stage input assignation, function of the sign of ibb
	assign cor_y_s0[0] = ibb_ibuff[IQ_SIZE-1] ? {!qbb_ibuff[IQ_SIZE-1], -qbb_ibuff} :
											 {qbb_ibuff[IQ_SIZE-1], qbb_ibuff};

	assign cor_x_s0[0] = ibb_ibuff[IQ_SIZE-1] ? {1'b0, -ibb_ibuff}:
											 {1'b0, ibb_ibuff};

	assign cor_w_s0[0] = ibb_ibuff[IQ_SIZE-1] ? {1'b1, {W_SIZE-1{1'b0}}}: // 180 degree
											 {W_SIZE{1'b0}};



	//////////////////////////////////////////////////////////////////////////////////////////////
	// Cordic stages instantiation
	//////////////////////////////////////////////////////////////////////////////////////////////
	genvar iStage;
	generate
		for (iStage = 0; iStage < 2; iStage = iStage + 1) begin : zigbee_cordic_stage_gen_s0
			zigbee_cordic_stage_comb #(
				.NUM_STAGE(iStage),
				.XY_SIZE(IQ_SIZE + 1),
				.W_SIZE(W_SIZE),
				.CONST_TAN(1 << (NUM_STAGES - iStage - 1))
				) stage (
				.xin(cor_x_s0[iStage]),
				.yin(cor_y_s0[iStage]),
				.win(cor_w_s0[iStage]),
				.xout(cor_x_s0[iStage + 1]),
				.yout(cor_y_s0[iStage + 1]),
				.wout(cor_w_s0[iStage + 1])
				);
		end

		for (iStage = 2; iStage < NUM_STAGES; iStage = iStage + 1) begin : zigbee_cordic_stage_gen_s1
			zigbee_cordic_stage_comb #(
				.NUM_STAGE(iStage),
				.XY_SIZE(IQ_SIZE + 1),
				.W_SIZE(W_SIZE),
				.CONST_TAN(1 << (NUM_STAGES - iStage - 1))
				) stage (
				.xin(cor_x_s1[iStage]),
				.yin(cor_y_s1[iStage]),
				.win(cor_w_s1[iStage]),
				.xout(cor_x_s1[iStage + 1]),
				.yout(cor_y_s1[iStage + 1]),
				.wout(cor_w_s1[iStage + 1])
				);
		end
	endgenerate



	//////////////////////////////////////////////////////////////////////////////////////////////
	// Output logic
	//////////////////////////////////////////////////////////////////////////////////////////////
	always @(posedge clk, negedge reset_n)
	begin
		if (!reset_n) begin // If reset set all dff at 0
			ibb_ibuff <= 0;
			qbb_ibuff <= 0;
			wout_obuff <= 0;
		end
		else begin
			ibb_ibuff <= ibb;
			qbb_ibuff <= qbb;
			wout_obuff <= cor_w_s1[NUM_STAGES];
		end
	end

	// Output assignation
	assign wout = wout_obuff;
endmodule
