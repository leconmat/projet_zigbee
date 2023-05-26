module tbench_filtre_bis ();

	timeunit      1ns;
	timeprecision 1ns;

	parameter real quantum = 0.03226;

	bit clk = 1'b1;
	bit reset;        
	bit in_valid;
	bit out_valid_I, out_valid_Q;

	logic [4:0] filter_in_I_digital;
	logic [4:0] filter_in_Q_digital;
	logic [4:0] filter_out_I_digital;
	logic [4:0] filter_out_Q_digital;

	real filter_in_I_real, filter_in_Q_real;
	real filter_out_I_real, filter_out_Q_real;

	real matlab_in_I_real, matlab_in_Q_real;
	real matlab_out_I_real, matlab_out_Q_real;

	typedef logic signed [4:0] sample_t;


	sample_t matlab_in_I_digital, matlab_in_Q_digital;
	sample_t matlab_out_I_digital, matlab_out_Q_digital;
	
	integer fd_I_in, fd_I_out, fd_Q_in, fd_Q_out;

	real out_error_I, out_error_Q, temp_error_Q_positif,temp_error_Q_negatif, temp_error_I;

	sin_wave sinus1(750,  filter_in_I_real);

	 // connexion avec le filtre
	filter dut_I (.clk(clk),         
		.resetn(reset),
		.data_in(filter_in_I_digital),
		.in_valid(in_valid),
		.out_valid(out_valid_I),
		.data_out(filter_out_I_digital)
	);

	filter dut_Q (.clk(clk),         
		.resetn(reset),
		.data_in(filter_in_Q_digital),
		.in_valid(in_valid),
		.out_valid(out_valid_Q),
		.data_out(filter_out_Q_digital)
	);


	always #10 clk = ~clk; //période 20 ns = 50Mhz

	initial //ouverture ficher
	begin
		fd_I_in = $fopen("../data/I_mid.csv", "r");
		fd_I_out = $fopen("../data/I_out.csv", "r");
		fd_Q_in = $fopen("../data/Q_mid.csv", "r");	
		fd_Q_out = $fopen("../data/Q_out.csv", "r");
		
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
			//$fscanf(fd_I_in, "%f\n", matlab_in_I_real);
			//$fscanf(fd_Q_in, "%f\n", matlab_in_Q_real);

			//filter_in_I_real = matlab_in_I_real;
			//filter_in_Q_real = matlab_in_Q_real;

			filter_in_I_digital = integer'(filter_in_I_real / quantum);
			filter_in_Q_digital = integer'(filter_in_Q_real / quantum);

			//filter_in_I_digital = sample_t'(filter_in_I_real / quantum);
			//filter_in_Q_digital = sample_t'(filter_in_Q_real / quantum);

			matlab_in_I_digital = sample_t'(matlab_in_I_real / quantum);
			matlab_in_Q_digital = sample_t'(matlab_in_Q_real / quantum);

			matlab_out_I_digital = sample_t'(matlab_out_I_real / quantum);
			matlab_out_Q_digital = sample_t'(matlab_out_Q_real / quantum);

			filter_out_I_real = (filter_out_I_digital * quantum);
			filter_out_Q_real = (filter_out_Q_digital * quantum);

			for(integer i  = 0; i < 5; i++) begin
				if (i==4) in_valid = 0;
				else in_valid = 1;
				@(posedge clk);
			end
		end
	end

	always @(posedge clk)
	begin
		if(out_valid_I)
		begin
			$fscanf(fd_I_out, "%f\n", matlab_out_I_real);

			//matlab_out_I_real = matlab_out_I_real / quantum;
			temp_error_I = matlab_out_I_real - filter_out_I_real;

			
		end

		if(out_valid_Q)
		begin
			$fscanf(fd_Q_out, "%f\n", matlab_out_Q_real);
			//matlab_out_Q_real = matlab_out_Q_real / quantum;
			temp_error_Q_positif = matlab_out_Q_real - filter_out_Q_real;
			temp_error_Q_negatif = filter_out_Q_real - matlab_out_Q_real;
				if (temp_error_Q_positif > temp_error_Q_negatif) out_error_Q = temp_error_Q_negatif;
				else out_error_Q = temp_error_Q_positif;		 	  
	
		end
	end
	
endmodule
