module bang_bang(
                input logic clk,
                input logic resetn,
                input logic data,
                output logic pd
                );

logic q1, q2, q3, q4;
logic a, b;

always_ff @(posedge clk, negedge resetn) begin
if(~resetn) begin
  q1 <= 0;
end else begin
  q1 <= data;
end
end

always_ff @(negedge clk, negedge resetn) begin
if(~resetn) begin
  q2 <= 0;
end else begin
  q2 <= data;
end
end

always_ff @(posedge q1, negedge resetn) begin
if(~resetn) begin
  q3 <= 0;
end else begin
  q3 <= ~q2;
end
end

always_ff @(negedge q1, negedge resetn) begin
if(~resetn) begin
  q4 <= 0;
end else begin
  q4 <= q2;
end
end

assign a = ~(q3&&q1);
assign b = ~(~q1&&q4);
assign pd = ~(a&&b);

endmodule
