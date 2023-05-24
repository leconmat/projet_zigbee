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
	iValid,

	// Outputs
	wout,
	oValid
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
	input wire clk, reset_n, iValid;
	output wire oValid;

	// DFF buffer for IOs
	reg [IQ_SIZE-1:0] ibb_ibuff, qbb_ibuff;
	reg [W_SIZE-1:0] wout_obuff;
	reg iValid_ibuff;
	reg oValid_obuff;

	// Cordic stages wires
	// 1 wires stage more than number of cordic stages
	logic [IQ_SIZE+1-1:0] cor_x_s0 [2-1+1:0];
	logic [IQ_SIZE+1-1:0] cor_y_s0 [2-1+1:0];
	logic [W_SIZE-1:0] cor_w_s0 [2-1+1:0];
	
	logic [IQ_SIZE+1-1:0] cor_x_s1 [NUM_STAGES-1+1:2];
	logic [IQ_SIZE+1-1:0] cor_y_s1 [NUM_STAGES-1+1:2];
	logic [W_SIZE-1:0] cor_w_s1 [NUM_STAGES-1+1:2];

	logic valid_s0 [2-1+1:0];
	logic valid_s1 [NUM_STAGES-1+1:2];

	always @(posedge clk, negedge reset_n) begin
		if(!reset_n) begin
			cor_x_s1[2] <= 0;
			cor_y_s1[2] <= 0;
			cor_w_s1[2] <= 0;
			valid_s1[2] <= 0;
		end
		else begin
			if (ibb_ibuff[IQ_SIZE-1]) begin
				cor_x_s0[0] <= {1'b0, -ibb_ibuff};
				cor_y_s0[0] <= {(!qbb_ibuff[IQ_SIZE-1]) && (qbb_ibuff != 0), -qbb_ibuff};
				cor_w_s0[0] <= {1'b1, {W_SIZE-1{1'b0}}}; // 180 degrees
			end
			else begin
				cor_x_s0[0] <= {1'b0, ibb_ibuff};
				cor_y_s0[0] <= {qbb_ibuff[IQ_SIZE-1], qbb_ibuff};
				cor_w_s0[0] <= {W_SIZE{1'b0}};
			end
		
			valid_s0[0] <= iValid_ibuff;

			cor_x_s1[2] <= cor_x_s0[2];
			cor_y_s1[2] <= cor_y_s0[2];
			cor_w_s1[2] <= cor_w_s0[2];
			valid_s1[2] <= valid_s0[2];
		end
	end



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
				// Inputs
				.xin(cor_x_s0[iStage]),
				.yin(cor_y_s0[iStage]),
				.win(cor_w_s0[iStage]),
				.validIn(valid_s0[iStage]),
				// Outputs
				.xout(cor_x_s0[iStage + 1]),
				.yout(cor_y_s0[iStage + 1]),
				.wout(cor_w_s0[iStage + 1]),
				.validOut(valid_s0[iStage + 1])
				);
		end

		for (iStage = 2; iStage < NUM_STAGES; iStage = iStage + 1) begin : zigbee_cordic_stage_gen_s1
			zigbee_cordic_stage_comb #(
				.NUM_STAGE(iStage),
				.XY_SIZE(IQ_SIZE + 1),
				.W_SIZE(W_SIZE),
				.CONST_TAN(1 << (NUM_STAGES - iStage - 1))
				) stage (
				// Inputs
				.xin(cor_x_s1[iStage]),
				.yin(cor_y_s1[iStage]),
				.win(cor_w_s1[iStage]),
				.validIn(valid_s1[iStage]),
				// Outputs
				.xout(cor_x_s1[iStage + 1]),
				.yout(cor_y_s1[iStage + 1]),
				.wout(cor_w_s1[iStage + 1]),
				.validOut(valid_s1[iStage + 1])
				);
		end
	endgenerate



	//////////////////////////////////////////////////////////////////////////////////////////////
	// Output logic
	//////////////////////////////////////////////////////////////////////////////////////////////
	always @(posedge clk, negedge reset_n)
	begin
		if (!reset_n) begin // If reset set all dff at 0
			iValid_ibuff <= 0;
			ibb_ibuff <= 0;
			qbb_ibuff <= 0;
			wout_obuff <= 0;
			oValid_obuff <= 0;
		end
		else begin
			iValid_ibuff <= iValid;
			ibb_ibuff <= ibb;
			qbb_ibuff <= qbb;
			wout_obuff <= cor_w_s1[NUM_STAGES];
			oValid_obuff <= valid_s1[NUM_STAGES];
		end
	end

	// Output assignation
	assign wout = wout_obuff;
	assign oValid = oValid_obuff;
endmodule
