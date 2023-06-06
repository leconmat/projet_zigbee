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
	reg signed [IQ_SIZE-1:0] ibb_ibuff, qbb_ibuff;
	reg signed [W_SIZE-1:0] wout_obuff;
	reg iValid_ibuff;
	reg oValid_obuff;

	// Cordic stages wires
	// 1 wires stage more than number of cordic stages
	logic signed [IQ_SIZE+1-1:0] cor_x_s0 [2-1+1:0];
	logic signed [IQ_SIZE+1-1:0] cor_y_s0 [2-1+1:0];
	logic signed [W_SIZE-1:0] cor_w_s0 [2-1+1:0];
	
	// No registers for x and y at the last stage
	logic signed [IQ_SIZE+1-1:0] cor_x_s1 [NUM_STAGES-1:2];
	logic signed [IQ_SIZE+1-1:0] cor_y_s1 [NUM_STAGES-1:2];
	logic signed [W_SIZE-1:0] cor_w_s1 [NUM_STAGES-1+1:2];

	logic valid_s0 [2-1+1:0];
	logic valid_s1 [NUM_STAGES-1+1:2];
	


	//////////////////////////////////////////////////////////////////////////////////////////////
	// Cordic stages instantiation
	//////////////////////////////////////////////////////////////////////////////////////////////
	zigbee_cordic_stage_comb #(
				.NUM_STAGE(0),
				.XY_SIZE(IQ_SIZE + 1),
				.W_SIZE(W_SIZE),
				.CONST_TAN(1 << (NUM_STAGES - 1))
				) S0 (
				// Inputs
				.xin(cor_x_s0[0]),
				.yin(cor_y_s0[0]),
				.win(cor_w_s0[0]),
				.validIn(valid_s0[0]),
				// Outputs
				.xout(cor_x_s0[1]),
				.yout(cor_y_s0[1]),
				.wout(cor_w_s0[1]),
				.validOut(valid_s0[1])
				);
	
				
	zigbee_cordic_stage_comb #(
				.NUM_STAGE(1),
				.XY_SIZE(IQ_SIZE + 1),
				.W_SIZE(W_SIZE),
				.CONST_TAN(1 << (NUM_STAGES - 2))
				) S1 (
				// Inputs
				.xin(cor_x_s0[1]),
				.yin(cor_y_s0[1]),
				.win(cor_w_s0[1]),
				.validIn(valid_s0[1]),
				// Outputs
				.xout(cor_x_s0[2]),
				.yout(cor_y_s0[2]),
				.wout(cor_w_s0[2]),
				.validOut(valid_s0[2])
				);
				
	zigbee_cordic_stage_comb #(
				.NUM_STAGE(2),
				.XY_SIZE(IQ_SIZE + 1),
				.W_SIZE(W_SIZE),
				.CONST_TAN(1 << (NUM_STAGES - 3))
				) S2 (
				// Inputs
				.xin(cor_x_s1[2]),
				.yin(cor_y_s1[2]),
				.win(cor_w_s1[2]),
				.validIn(valid_s1[2]),
				// Outputs
				.xout(cor_x_s1[3]),
				.yout(cor_y_s1[3]),
				.wout(cor_w_s1[3]),
				.validOut(valid_s1[3])
				);
				
	zigbee_cordic_stage_comb #(
				.NUM_STAGE(3),
				.XY_SIZE(IQ_SIZE + 1),
				.W_SIZE(W_SIZE),
				.CONST_TAN(1 << (NUM_STAGES - 4))
				) S3 (
				// Inputs
				.xin(cor_x_s1[3]),
				.yin(cor_y_s1[3]),
				.win(cor_w_s1[3]),
				.validIn(valid_s1[3]),
				// Outputs
				.xout(),
				.yout(),
				.wout(cor_w_s1[4]),
				.validOut(valid_s1[4])
				);



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
			
			cor_x_s1[2] <= 0;
			cor_y_s1[2] <= 0;
			cor_w_s1[2] <= 0;
			valid_s1[2] <= 0;
		end
		else begin
			iValid_ibuff <= iValid;
			ibb_ibuff <= ibb;
			qbb_ibuff <= qbb;
			wout_obuff <= cor_w_s1[NUM_STAGES];
			oValid_obuff <= valid_s1[NUM_STAGES];

			cor_x_s1[2] <= cor_x_s0[2];
			cor_y_s1[2] <= cor_y_s0[2];
			cor_w_s1[2] <= cor_w_s0[2];
			valid_s1[2] <= valid_s0[2];
		end
	end
	
	assign valid_s0[0] = iValid_ibuff;

	assign cor_y_s0[0] = ibb_ibuff[IQ_SIZE-1] ? $signed({(!qbb_ibuff[IQ_SIZE-1]) && (qbb_ibuff != 0), -qbb_ibuff}) :
								  				$signed({qbb_ibuff[IQ_SIZE-1], qbb_ibuff});
				
	assign cor_x_s0[0] = $signed({1'b0, (ibb_ibuff[IQ_SIZE-1]) ? -ibb_ibuff : ibb_ibuff});

	assign cor_w_s0[0] = $signed({ibb_ibuff[IQ_SIZE-1], {W_SIZE-1{1'b0}}});

	// Output assignation
	assign wout = wout_obuff;
	assign oValid = oValid_obuff;
endmodule
