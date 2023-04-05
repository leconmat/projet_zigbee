`timescale 1ns/10ps

module zigbee_cordic_tb;

	parameter integer IQ_SIZE = 5;
	parameter integer W_SIZE = 6;
	parameter integer AMPLITUDE = 15;
	parameter real PI = 3.14159265359;
	
	real errors[$];
	
	// Inputs
	logic signed [IQ_SIZE-1:0] Ibb, Qbb;
	real IbbReal, QbbReal, angleRad, angleDeg, deltaError, WoutDeg;
	
	// Output
	logic signed [W_SIZE-1:0] Wout;

	zigbee_cordic_top CORDIC (.Ibb(Ibb), .Qbb(Qbb), .Wout(Wout));
	
	//always_comb begin
	//	if ($cos(angleRad) < 0)
	//		IbbReal = $cos(angleRad) * (AMPLITUDE + 1);
	//	else
	//		IbbReal = $cos(angleRad) * AMPLITUDE;
	//	
	//	if($sin(angleRad) < 0)
	//		QbbReal = $sin(angleRad) * (AMPLITUDE + 1);
	//	else
	//		QbbReal = $sin(angleRad) * AMPLITUDE;
	//end
	
	assign IbbReal = $cos(angleRad) * AMPLITUDE;
	assign QbbReal = $sin(angleRad) * AMPLITUDE;
	
	assign WoutDeg = $itor(Wout) * 5.625;
	
	assign Ibb = int'(IbbReal);
	assign Qbb = int'(QbbReal);
	
	always_comb begin
		deltaError = WoutDeg - angleDeg;
		// Unwrap condition
		if (deltaError > 180)
			deltaError -= 360;
		if (deltaError <= -180)
			deltaError += 360;
	end
	
	initial begin
		forever begin
			angleRad = $itor($urandom_range(2 * PI * 10000)) / 10000;
			//angleRad = 0.0916;
			angleDeg = (angleRad * 360) / (2 * PI);
			#10;
			errors.push_back(deltaError);
		end
	end
endmodule
