`define PERIOD 20ns

module tb_fsm();

timeunit 1ns;
timeprecision 1ns;

bit clk;
bit reset;

logic [1:0] sine, cosine;

fsm dut (.clk(clk),
	 .resetn(reset),
	 .sine_out(sine),
	 .cosine_out(cosine)
	);

initial $timeformat(-8,1," ns",10);
initial reset = 0;
initial clk = 1'b0;


always #(`PERIOD/2) clk=~clk;

initial begin
#500
reset <=1 ;

#927
reset <=0 ;

end

endmodule
