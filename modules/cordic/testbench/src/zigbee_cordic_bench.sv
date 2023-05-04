// File: zigbee_cordic_bench.sv
// Authors: Nathan Hocquette
//          Romain Plumaugat
// Description: Testbench for the cordic module

module zigbee_cordic_tb;

	parameter integer IQ_SIZE = 5;
	parameter integer W_SIZE = 6;
	parameter integer AMPLITUDE = 15;
	parameter real PI = 3.14159265359;
	
	real errors[$];
	real maxError;

	// Inputs
	logic signed [IQ_SIZE-1:0] ibb, qbb;
	logic clk, reset_n;
	real ibbReal, qbbReal, angleRad, angleDeg, deltaError, woutDeg;

	// Output
	logic signed [W_SIZE-1:0] wout;

	// DUT instantiation
	zigbee_cordic_top CORDIC (.clk(clk), .reset_n(reset_n), // Clock and reset
							  .ibb(ibb), .qbb(qbb), // Inputs
							  .wout(wout)); // Outputs
	
	// DUT input stimuli
	assign ibbReal = $cos(angleRad) * AMPLITUDE;
	assign qbbReal = $sin(angleRad) * AMPLITUDE;
	assign ibb = int'(ibbReal);
	assign qbb = int'(qbbReal);



	// DUT output result
	assign woutDeg = $itor(wout) * 5.625;
	
	// DUT output unwrapper
	always_comb begin
		deltaError = woutDeg - angleDeg;
		if (deltaError > 180)
			deltaError -= 360;
		if (deltaError <= -180)
			deltaError += 360;
	end

	// Initialize the clock at 50MHz
	initial begin
		clk = 0;
		forever #20ns clk = !clk;
	end
	
	// DUT random stimuli angle generator
	initial begin
		reset_n = 1'b0;
		#750ns reset_n = 1'b1;
		forever begin
			angleRad = $itor($urandom_range(2 * PI * 10000)) / 10000;
			angleDeg = (angleRad * 360) / (2 * PI);
			#200ns;
			errors.push_back(deltaError);

			if((deltaError > 0 ? deltaError : -deltaError) > maxError)
				maxError = deltaError > 0 ? deltaError : -deltaError;
		end
	end
endmodule
