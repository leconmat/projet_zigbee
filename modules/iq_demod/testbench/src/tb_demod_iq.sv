module tb_demod_iq ();

	timeunit      1ns;
	timeprecision 1ns;

	parameter real quantum = 0.03226;

	bit clk = 1'b1;
	bit reset = 0;        
	bit in_valid = 0;
	bit out_valid;

	logic [4:0] filter_out_I_digital;
	logic [4:0] filter_out_Q_digital;

	real filter_out_I_real, filter_out_Q_real;

	real matlab_in_I_real, matlab_in_Q_real;
	real matlab_out_I_real, matlab_out_Q_real;

	typedef logic signed [4:0] sample_t;

	sample_t matlab_in_I_digital, matlab_in_Q_digital;
	sample_t matlab_out_I_digital, matlab_out_Q_digital;
	
	integer fd_I_in, fd_I_out, fd_Q_in, fd_Q_out;

	real out_error_I, out_error_Q, temp_error_Q_positif,temp_error_Q_negatif, temp_error_I,temp_error_I_positif,temp_error_I_negatif;

	//sin_wave sinus(1,  filter_in_I_real);

	 // connexion avec le filtre
	top_iq_demod dut_top(
	.clk(clk),
	.resetn(reset),
	.ADC_rdy_i(in_valid), // on reçoit ça de l'ADC
	.I_IF(matlab_in_I_digital),
	.Q_IF(matlab_in_Q_digital),
	.demod_iq_valid(out_valid), // on envoie ça au cordiq
	.I_BB(filter_out_I_digital),
	.Q_BB(filter_out_Q_digital)
	);

	always #10 clk = ~clk; //période 20 ns = 50Mhz

	initial //ouverture ficher
	begin
		fd_I_in = $fopen("../data/I_in.csv", "r");
		fd_I_out = $fopen("../data/I_out.csv", "r");
		fd_Q_in = $fopen("../data/Q_in.csv", "r");	
		fd_Q_out = $fopen("../data/Q_out.csv", "r");
		
		if(~fd_I_in) $display("I_in not opened");
		if(~fd_I_out) $display("I_out not opened");
		if(~fd_Q_in) $display("Q_in not opened");
		if(~fd_Q_out) $display("Q_out not opened");
	end

	initial //main 
	begin
		reset = 0;
		in_valid = 0;

		matlab_in_I_digital = 0;
		matlab_in_Q_digital = 0;

		#100;
		reset = 1;
		
		
		forever //ici c'est magique pas de comb ni de séquentiel
		begin
			$fscanf(fd_I_in, "%f\n", matlab_in_I_real);
			$fscanf(fd_Q_in, "%f\n", matlab_in_Q_real);

			matlab_in_I_digital = sample_t'(matlab_in_I_real / quantum);
			matlab_in_Q_digital = sample_t'(matlab_in_Q_real / quantum);

			$fscanf(fd_I_out, "%f\n", matlab_out_I_real);
			$fscanf(fd_Q_out, "%f\n", matlab_out_Q_real);

			matlab_out_I_digital = sample_t'((matlab_out_I_real*0.90) / quantum);
			matlab_out_Q_digital = sample_t'((matlab_out_Q_real*0.90) / quantum);

			filter_out_I_real = (filter_out_I_digital * quantum);
			filter_out_Q_real = (filter_out_Q_digital * quantum);

			for(integer i  = 0; i < 5; i++) begin
				if (i == 0) in_valid = 1;
				else in_valid = 0;
				@(posedge clk);
			end
		end
	end

	/*always @(posedge clk)
	begin
		if(out_valid)
		begin
			$fscanf(fd_I_out, "%f\n", matlab_out_I_real);
			temp_error_I_positif = matlab_out_I_real - filter_out_I_real;
			temp_error_I_negatif = filter_out_I_real - matlab_out_I_real;
				if (temp_error_I_positif > temp_error_I_negatif) out_error_I = temp_error_I_negatif;
				else out_error_I = temp_error_I_positif;		 	  
	
		end

		if(out_valid)
		begin
			$fscanf(fd_Q_out, "%f\n", matlab_out_Q_real);
			//matlab_out_Q_real = matlab_out_Q_real / quantum;
			temp_error_Q_positif = matlab_out_Q_real - filter_out_Q_real;
			temp_error_Q_negatif = filter_out_Q_real - matlab_out_Q_real;
				if (temp_error_Q_positif > temp_error_Q_negatif) out_error_Q = temp_error_Q_negatif;
				else out_error_Q = temp_error_Q_positif;		 	  
	
		end
	end */
	
endmodule
