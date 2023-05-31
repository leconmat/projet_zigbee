module tbench_demod ();
	timeunit      1ns;
	timeprecision 1ns;
	
	bit clk = 1'b1;
	bit reset;
	bit ADC_rdytb;
	bit demod_rdytb;
	
	parameter real quantum = 0.03226;
	parameter real quantum_sine = 0.03125;

	parameter real freq = 2500;


	typedef logic signed [4:0] demod_in;
	typedef logic signed [4:0] sine_in;

//liaison bloc
	logic signed [4:0] I_in_demod;
	logic signed [4:0] Q_in_demod;
	logic signed [4:0] I_out_demod;
	logic signed [4:0] Q_out_demod;
//donnée matlab
	real I_in_matlab, Q_in_matlab;
	real I_out_matlab, Q_out_matlab;
//conteneur des valeurs matlab	
	integer fd_I_in, fd_I_out, fd_Q_in, fd_Q_out;
//variable de differences
	real out_error_I, out_error_Q;
//cos sin
	logic signed [1:0] cosine, sine; 

demodulation demod_dut (	.clk(clk),
			.resetn(reset),
			.I_IF(I_in_demod),
			.Q_IF(Q_in_demod),
			.I_BB(I_out_demod),
			.Q_BB(Q_out_demod),
			.demod_rdy(demod_rdytb),
			.ADC_rdy(ADC_rdytb),
			.cosine_in(cosine),
			.sine_in(sine)
);

fsm gen_sin_dut(	.clk(clk),
			.resetn(reset),
			.cosine_out(sine),
			.sine_out(cosine)
);


/*sin_wave sineeeee (	.freq(freq),
			.sinus(sine_real)
);

cosine_wave cosineeeeee (.freq(freq),
			.sinus(cosine_real)
);*/


	always #10 clk = ~clk; //période 20 ns = 50Mhz

	initial //ouverture ficher
	begin
		fd_I_in = $fopen("../data/I_in.csv", "r");
		fd_I_out = $fopen("../data/I_mid.csv", "r");
		fd_Q_in = $fopen("../data/Q_in.csv", "r");	
		fd_Q_out = $fopen("../data/Q_mid.csv", "r");
		
		if(~fd_I_in) $display("I_in not opened");
		if(~fd_I_out) $display("I_out not opened");
		if(~fd_Q_in) $display("Q_in not opened");
		if(~fd_Q_out) $display("Q_out not opened");
	end

	initial //main 
	begin 
		reset = 0;
		#100;
		reset = 1;
		
		forever //ici c'est magique pas de comb ni de séquentiel
		begin
			$fscanf(fd_I_in, "%f\n", I_in_matlab);
			$fscanf(fd_Q_in, "%f\n", Q_in_matlab);

			I_in_demod = demod_in'(I_in_matlab / quantum);
			Q_in_demod = demod_in'((Q_in_matlab) / quantum);

			for(integer i  = 0; i < 5; i++) 
			begin
				if (i==4) ADC_rdytb = 1;
				else ADC_rdytb = 0;
				@(posedge clk);
			end
		end
	end
	
	always @(posedge clk)
	begin
		if(ADC_rdytb)
		begin
			$fscanf(fd_I_out, "%f\n", I_out_matlab);
			$fscanf(fd_Q_out, "%f\n", Q_out_matlab);

//			sine = sine_in'(sine_real / quantum_sine);
//			cosine = sine_in'(cosine_real / quantum_sine);

			I_out_matlab = I_out_matlab / quantum;
			Q_out_matlab = Q_out_matlab / quantum;

			out_error_I = I_out_matlab - I_out_demod;
			out_error_Q = Q_out_matlab - Q_out_demod;
		end
	end
endmodule
