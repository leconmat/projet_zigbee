`define PERIOD 100ns

module tb_demod();

timeunit 1ns;
timeprecision 1ns;

bit clk;
bit clk_del;
bit reset;

logic [1:0] sine, cosine;

logic [4:0] I_IF_tb;
logic [4:0] Q_IF_tb;

logic [4:0] I_BB_tb;
logic [4:0] Q_BB_tb;

fsm sines (.clk(clk),
	 .resetn(reset),
	 .sine_out(sine),
	 .cosine_out(cosine)
	);


demod dut1 (.clk(clk),
	 .resetn(reset),
	 .I_IF(I_IF_tb),
	 .Q_IF(Q_IF_tb),
	 .sine_in(sine),
	 .cosine_in(cosine),	 
	 .I_BB(I_BB_tb),
	 .Q_BB(Q_BB_tb)
	);

initial $timeformat(-8,1," ns",10);
initial reset = 0;
initial clk = 1'b0;
initial clk_del = 1'b0;


always #(`PERIOD/2) begin
clk=~clk;
#2
clk_del=~clk_del;
end

initial begin
#500
reset = 1;

I_IF_tb = 4;
Q_IF_tb = -4;

#927
reset = 0;

end

endmodule
