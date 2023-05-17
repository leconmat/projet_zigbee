//////////////////////////////////////////////////////////////////////////////////////////////
// File: zigbee_cordic_stage.sv
// Authors: Nathan Hocquette
//          Romain Plumaugat
// Description: Rotate the vector of coordinates xin & yin with an angle of CONST_TAN
//              Give the new coordinates xout & yout with the new angle value wout
//////////////////////////////////////////////////////////////////////////////////////////////
module zigbee_cordic_stage_comb 
	#(parameter integer NUM_STAGE = 1, XY_SIZE = 1, W_SIZE = 0,
	  parameter [W_SIZE-1:0] CONST_TAN = 4) 
        (
	// Inputs
	xin,
	yin,
	win,
	validIn,

	// Outputs
	xout,
	yout,
	wout,
	validOut
	);



	//////////////////////////////////////////////////////////////////////////////////////////////
	// IOs declarations
	//////////////////////////////////////////////////////////////////////////////////////////////
	input wire signed [XY_SIZE-1:0] xin, yin; // Starting vector coordinates
	input wire signed [W_SIZE-1:0] win; // Starting phase
	input wire validIn;

	output wire signed [XY_SIZE-1:0] xout, yout; // New vector coordinates
	output wire signed [W_SIZE-1:0] wout; // New phase, rotate from CONST_TAN
	output wire validOut;

	wire signed [XY_SIZE-1:0] xin_shifted, yin_shifted; // xin/2 & yin/2



	//////////////////////////////////////////////////////////////////////////////////////////////
	// Wiring of the CORDIC STAGE
	//////////////////////////////////////////////////////////////////////////////////////////////
	// Signed right shift
	assign xin_shifted = xin >>> NUM_STAGE;
	assign yin_shifted = yin >>> NUM_STAGE;

	// If yin is positive
	assign xout = !yin[XY_SIZE-1] ? xin + yin_shifted :
									xin - yin_shifted;

	assign yout = !yin[XY_SIZE-1] ? yin - xin_shifted :
									yin + xin_shifted;

	assign wout = !yin[XY_SIZE-1] ? win + CONST_TAN :
									win - CONST_TAN;
									
	assign validOut = validIn;
endmodule
