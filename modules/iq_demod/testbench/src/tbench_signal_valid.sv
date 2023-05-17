module tbench_signal_valid();

timeunit	1ns;
timeprecision	1ns;

bit clk = 1'b1;
bit reset;
bit E;
bit S;


//signal_valid
enable dut(
 .clk		(clk	),
 .resetn	(reset	),
 .valid_ADC	(E	),
 .ready_ADC	(S	)
);

initial
	begin
		$timeformat ( -9, 1, " ns", 12 );
		reset = 1'b0;
		#60 reset = 1'b1;
	end

always
	begin
		#10 clk = ~clk;
	end
initial
	begin

		E = 1'b0;
		#100
		E = 1'b1;
		#100
		E = 1'b0;
	end

endmodule
