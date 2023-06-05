module zigbee_top_pad(
  input wire clk,
  input wire resetn,
  input wire [1:0] sel,
  input wire [21:0] in,
  input wire [17:0] out
);

  wire clk_w, resetn_w;
  wire [1:0] sel_w;
  wire [21:0] in_w;
  wire [17:0] out_w;

  zigbee_platform(
    .clk_i(clk_w),
    .resetn_i(resetn_w),
    .mux_i(in_w),
    .mux_o(out_w),
    .sel_i(sel_w)
  );

  ITP io_clk (.PAD(clk), .Y(clk_w));
  ITP io_resetn (.PAD(resetn), .Y(resetn_w));

  BU12SP io_sel_1 (.A(sel_w[1]), .PAD(sel[1]));
  BU12SP io_sel_0 (.A(sel_w[0]), .PAD(sel[0]));

  genvar i;
  generate
    for(i=0; i < 22; i++) begin
      ITP io_in (.PAD(in[i]), .Y(in_w[i]));
    end
  endgenerate

  genvar j;
  generate
    for(j=0; j < 18; j++) begin
      BU12SP io_out (.A(out_w[j]), .PAD(out[j]));
    end
  endgenerate

endmodule
