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

  ITP io_CLK (.PAD(clk), .Y(clk_w));
  ITP io_RESETN (.PAD(resetn), .Y(resetn_w));

  BU12SP io_sel_1 (.A(sel_w[1]), .PAD(sel[1]));
  BU12SP io_sel_0 (.A(sel_w[0]), .PAD(sel[0]));

  ITP io_in_21 (.PAD(in[21]), .Y(in_w[21]));
  ITP io_in_20 (.PAD(in[20]), .Y(in_w[20]));
  ITP io_in_19 (.PAD(in[19]), .Y(in_w[19]));
  ITP io_in_18 (.PAD(in[18]), .Y(in_w[18]));
  ITP io_in_17 (.PAD(in[17]), .Y(in_w[17]));
  ITP io_in_16 (.PAD(in[16]), .Y(in_w[16]));
  ITP io_in_15 (.PAD(in[15]), .Y(in_w[15]));
  ITP io_in_14 (.PAD(in[14]), .Y(in_w[14]));
  ITP io_in_13 (.PAD(in[13]), .Y(in_w[13]));
  ITP io_in_12 (.PAD(in[12]), .Y(in_w[12]));
  ITP io_in_11 (.PAD(in[11]), .Y(in_w[11]));
  ITP io_in_10 (.PAD(in[10]), .Y(in_w[10]));
  ITP io_in_09 (.PAD(in[9]), .Y(in_w[9]));
  ITP io_in_08 (.PAD(in[8]), .Y(in_w[8]));
  ITP io_in_07 (.PAD(in[7]), .Y(in_w[7]));
  ITP io_in_06 (.PAD(in[6]), .Y(in_w[6]));
  ITP io_in_05 (.PAD(in[5]), .Y(in_w[5]));
  ITP io_in_04 (.PAD(in[4]), .Y(in_w[4]));
  ITP io_in_03 (.PAD(in[3]), .Y(in_w[3]));
  ITP io_in_02 (.PAD(in[2]), .Y(in_w[2]));
  ITP io_in_01 (.PAD(in[1]), .Y(in_w[1]));
  ITP io_in_00 (.PAD(in[0]), .Y(in_w[0]));

  BU12SP io_out_17 (.A(out_w[17]), .PAD(out[17]));
  BU12SP io_out_16 (.A(out_w[16]), .PAD(out[16]));
  BU12SP io_out_15 (.A(out_w[15]), .PAD(out[15]));
  BU12SP io_out_14 (.A(out_w[14]), .PAD(out[14]));
  BU12SP io_out_13 (.A(out_w[13]), .PAD(out[13]));
  BU12SP io_out_12 (.A(out_w[12]), .PAD(out[12]));
  BU12SP io_out_11 (.A(out_w[11]), .PAD(out[11]));
  BU12SP io_out_10 (.A(out_w[10]), .PAD(out[10]));
  BU12SP io_out_09 (.A(out_w[9]), .PAD(out[9]));
  BU12SP io_out_08 (.A(out_w[8]), .PAD(out[8]));
  BU12SP io_out_07 (.A(out_w[7]), .PAD(out[7]));
  BU12SP io_out_06 (.A(out_w[6]), .PAD(out[6]));
  BU12SP io_out_05 (.A(out_w[5]), .PAD(out[5]));
  BU12SP io_out_04 (.A(out_w[4]), .PAD(out[4]));
  BU12SP io_out_03 (.A(out_w[3]), .PAD(out[3]));
  BU12SP io_out_02 (.A(out_w[2]), .PAD(out[2]));
  BU12SP io_out_01 (.A(out_w[1]), .PAD(out[1]));
  BU12SP io_out_00 (.A(out_w[0]), .PAD(out[0]));

endmodule
