`timescale 1 ns/10 ps

module bit_recovery_CDR_tb();

logic clk = 1;
logic valid = 1;
logic resetn = 0;
logic signed [5:0] phase = 'b0;
logic data_bits;
logic output_wanted = 0;
logic test = 1;
logic data_en;
int variance = 0;
int count = 0;


bit_recovery_CDR dut(
			.clk_i(clk),
           		.resetn_i(resetn),
			.phase_i(phase),
			.ph_valid_i(valid),
			.data_en_o(data_en),
           		.data_o(data_bits)
			);

always #10 clk = ~clk;

always #50 valid = ~valid;

initial begin
  #100 resetn = ~resetn;
end

always @(negedge data_en) begin
if(output_wanted !== data_bits) test = 0;
end

initial begin
  $display("start");
  #100
  #33
  for(int i = 0; i<100;i++)begin
    output_wanted = $urandom(i)%2;
    variance = 1 - $urandom(i)%3;
    if(output_wanted == 0) begin
      for(int j = 0; j <5 ; j++) begin
        phase -=4+variance;
        #100;
      end
    end
    else begin
      for(int j = 0; j<5; j++) begin
        phase += 4+variance;
        #100;
      end
    end

    // test error works
    /*if(i == 30) begin
       for(int j = 0; j < 5; j++) begin
	  if(output_wanted == 0) begin
	     phase += 4;
	     #100;
	     if(j == 3) begin
                if(output_wanted != data_bits) test = 0;
             end
          end
          else begin
             phase -= 4;
	     #100;
	     if(j == 3) begin
                if(output_wanted != data_bits) test = 0;
             end
          end
       end 
    end*/

    if(test == 0)begin
	$display("data_bits != output_wanted at t = %t ",$realtime);
	count = count + 1;
    end
    test = 1;
  end
  if(count != 0) begin
  	$display("test failed");
  end
  else begin
  	$display("test passed");
  end
  $finish;
end
endmodule
