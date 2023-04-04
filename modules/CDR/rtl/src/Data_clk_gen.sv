module Data_clk_gen(
                   input logic clk,
                   input logic resetn,
                   input logic pd,
                   output logic data_clk
                   );

logic [4:0] count_pos;
logic [4:0] count_neg;

always_ff @(posedge clk, negedge resetn) begin
  if(~resetn) begin
    data_clk <= 0;
    count_pos <= 0;
  end  
  else begin
    if(count_pos < 24) begin
      count_pos += 1;
    end
    else begin
      count_pos <= 0;
      data_clk <= 1;
    end
  end
end

always_ff @(negedge clk, negedge resetn) begin
  if(~resetn) begin
    data_clk <= 0;
    count_neg <= 5'b01100;
  end
  else begin
    if(count_neg < 24) begin
     count_neg += 1;
    end
    else begin
      count_neg <= 0;
      data_clk <= 0;
    end
  end
end

endmodule
