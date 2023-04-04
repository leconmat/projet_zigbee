`timescale 1 ns/10 ps

module Data_clk_gen_tb();

logic clk = 0;
logic resetn = 0;
logic data = 0;
logic rdata;
logic pd;
logic data_clk;

Data_clk_gen dut(
                .clk(clk),
                .resetn(resetn),
                .data_clk(data_clk)
                );

bang_bang bb1(
             .clk(data_clk),
             .resetn(resetn),
             .data(data),
             .pd(pd)
             );



always #10 clk = ~clk;

initial begin
  #20
  resetn = ~resetn;
end

initial begin
  #470
  data = 1;
  #500
  data = 0;
/*  #1000
  data = 1;
  #1500
  data = 0; */
end

endmodule
