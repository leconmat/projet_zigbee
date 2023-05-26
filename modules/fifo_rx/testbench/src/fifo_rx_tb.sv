`timescale 1ns/1ps

module fifo_rx_tb ();

//System Inputs
logic clk, reset_n, en_cdr;

// APB signals
logic data_in, psel, pwrite, penable, pready, pslverr,a;
integer y = 0 ;
integer j = 0 ;
// Output Tx
logic [7:0] prdata;
reg mem_state; // 0 memoire vide, 1 memoire remplie ou partiellement remplie

fifo_rx DUT(.clk(clk),.reset_n(reset_n), .en_cdr(en_cdr), 
	    .data_in(data_in), .psel(psel), .pwrite(pwrite), .penable(penable), .pready(pready), .pslverr(pslverr),
	    .prdata(prdata), .mem_state(mem_state));

	//reset
	initial begin
		reset_n = 0;
		#20; 
		reset_n = 1;
		#20; 
	end

	// Write bench
	initial begin
		data_in = 0;
		clk = 0;
		forever begin
			clk = 0;
			#10;
			clk = 1;
			#10;
			data_in = $urandom;
		end
	end
	initial begin
		en_cdr = 0;
		forever begin
			#250;
			en_cdr = ~en_cdr;	
		end
	end

	//Test Lecture
	initial begin
		prdata = 'h0;
		psel = 1'b0;
		pwrite = 1'b0;
		penable = 1'b0;
		#500;
	 	psel = 1'b1;
		pwrite = 1'b0;
		penable = 1'b1;
	end 

endmodule
