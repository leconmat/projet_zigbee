module fifo_rx #(
	// Parameters
	parameter WIDTH = 8,
	parameter DEPTH = 64
)				
(
	clk, // horloge systeme 
	pclk, // horloge APB
	reset_n,

	// APB signals
	pwdata,
	paddr,
	psel,
	pwrite,
	penable,
	pready,
	pslverr,

	// Output Tx
	data_out, 
	IQ_rate,
	mem_state // 0 memoire vide, 1 memoire remplie ou partiellement remplie
);



//////////////////////////////////////////////
// IO declarations
//////////////////////////////////////////////
input logic clk, // horloge systeme 
input logic pclk, // horloge APB
input logic reset_n,

// APB signals
input logic pwdata,
input logic [7:0] paddr,
input logic psel,
input logic pwrite,
input logic penable,
output logic pready,
output logic pslverr,

// Output Tx
output logic [7:0] data_out, 
// output logic IQ_rate,
output reg mem_state // 0 memoire vide, 1 memoire remplie ou partiellement remplie








endmodule
