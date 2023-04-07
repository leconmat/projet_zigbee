`timescale 1ns/10ps

module zigbee_cordic_tb;

	parameter integer IQ_SIZE = 5;
	parameter integer W_SIZE = 6;
	parameter integer AMPLITUDE = 15;
	parameter real PI = 3.14159265359;
	
	real errors[$];
	real maxError;

	logic Clk;
	initial begin
		Clk = 0;
		forever #(100 / 2) Clk = !Clk;
	end

	// Inputs
	logic signed [IQ_SIZE-1:0] Ibb, Qbb;
	real IbbReal, QbbReal, angleRad, angleDeg, deltaError, WoutDeg;
	
	// Output
	logic signed [W_SIZE-1:0] Wout;

	// DUT
	zigbee_cordic_top CORDIC (.Ibb(Ibb), .Qbb(Qbb), .Wout(Wout), .Clk(Clk));
	
	// DUT input stimuli
	assign IbbReal = $cos(angleRad) * AMPLITUDE;
	assign QbbReal = $sin(angleRad) * AMPLITUDE;
	
	assign Ibb = int'(IbbReal);
	assign Qbb = int'(QbbReal);

	// DUT output result
	assign WoutDeg = $itor(Wout) * 5.625;
	
	// DUT output unwrapper
	always_comb begin
		deltaError = WoutDeg - angleDeg;
		if (deltaError > 180)
			deltaError -= 360;
		if (deltaError <= -180)
			deltaError += 360;
	end
	
	// DUT random stimuli angle generator
	initial begin
		forever begin
			angleRad = $itor($urandom_range(2 * PI * 10000)) / 10000;
			angleDeg = (angleRad * 360) / (2 * PI);
			#200;
			errors.push_back(deltaError);

			if((deltaError > 0 ? deltaError : -deltaError) > maxError)
				maxError = deltaError > 0 ? deltaError : -deltaError;
		end
	end
endmodule
