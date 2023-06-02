module TL_codeur_IQ_io ( resetn, clk, en_2MHz, b_in, mem_state, dac_ready, IBB, QBB, ready, en_dac );

	input resetn, clk, en_2MHz, b_in, mem_state, dac_ready;

	output [3:0] IBB, QBB;

	output ready, en_dac;

	wire resetn_w, clk_w, en_2MHz_w, b_in_w, mem_state_w, dac_ready_w;
	wire ready_w, en_dac_w;
	
	wire [3:0] IBB_w;
	wire [3:0] QBB_w;

TL_codeur_IQ t_op( .resetn(resetn_w),
		   .clk(clk_w),
		   .en_2MHz(en_2MHz_w),
		   .b_in(b_in_w),
		   .mem_state(mem_state_w),
		   .dac_ready(dac_ready_w),
		   .IBB(IBB_w),
		   .QBB(QBB_w),
		   .ready(ready_w),
		   .en_dac(en_dac_w));

	ITP io_CLK(.PAD(clk), .Y(clk_w));
	ITP io_resetn(.PAD(resetn), .Y(resetn_w));
	ITP io_en_2MHz(.PAD(en_2MHz), .Y(en_2MHz_w));
	ITP io_b_in(.PAD(b_in), .Y(b_in_w));
	ITP io_mem_state(.PAD(mem_state), .Y(mem_state_w));
	ITP io_dac_ready(.PAD(dac_ready), .Y(dac_ready_w));

	BU12SP io_IBB_3(.A(IBB_w[3]), .PAD(IBB[3]));
	BU12SP io_IBB_2(.A(IBB_w[2]), .PAD(IBB[2]));
	BU12SP io_IBB_1(.A(IBB_w[1]), .PAD(IBB[1]));
	BU12SP io_IBB_0(.A(IBB_w[0]), .PAD(IBB[0]));

	BU12SP io_QBB_3(.A(QBB_w[3]), .PAD(QBB[3]));
	BU12SP io_QBB_2(.A(QBB_w[2]), .PAD(QBB[2]));
	BU12SP io_QBB_1(.A(QBB_w[1]), .PAD(QBB[1]));
	BU12SP io_QBB_0(.A(QBB_w[0]), .PAD(QBB[0]));

	BU12SP io_ready(.A(ready_w), .PAD(ready));
	BU12SP io_en_dac(.A(en_dac_w), .PAD(en_dac));

endmodule
