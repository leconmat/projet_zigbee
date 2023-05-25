module fifo_rx #(
	// Parameters
	parameter WIDTH = 8,
	parameter DEPTH = 64
)				
(
	clk, // horloge systeme 
	reset_n,
	cdr_en,

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
output logic [WIDTH-1:0] data_out, 
// output logic IQ_rate,
output reg mem_state // 0 memoire vide, 1 memoire remplie ou partiellement remplie

reg i = 0;

// Store one bit data into shift register
always @(posedge clk, negedge reset_n) begin
	if (!reset_n) begin
			shift_regiter <= 8'b00000000;
	end
	else begin
		if (i >= WIDTH) begin
			i <= 0;
		end
		else begin
			shift_regiter[i] <= pwdata;
			i <= i + 1;
	end
end



//////////////////////////////////////////////
// Internal signals
//////////////////////////////////////////////
// Memory signals 
parameter PTR_WIDTH = $clog2(DEPTH);
logic [WIDTH-1:0] mem [DEPTH-1:0];
// Memory pointers	
logic [PTR_WIDTH:0] wr_ptr, rd_ptr;
// Memory flag
logic full;  
logic empty; 
// Rate change counters 50 MHz -> 2 MHz
reg [4:0] counter_clock;
reg [2:0] compteur;
reg [7:0] shift_register;
integer i;
logic load;

//////////////////////////////////////////////
// BEGIN MEMORY LOGIC 
//////////////////////////////////////////////
// Pointers managing
always_comb begin
	if((wr_ptr[PTR_WIDTH-1:0]) == (rd_ptr[PTR_WIDTH-1:0])) begin
		full = (wr_ptr[PTR_WIDTH]) ^ (rd_ptr[PTR_WIDTH]); // carry different => full 
		empty = wr_ptr[PTR_WIDTH] ~^ rd_ptr[PTR_WIDTH]; // carry identique => empty
	end
	else begin
		full = 0;
		empty = 0;
	end
end

// Memory state logic 
always_comb begin 
	if (empty == 1'b1) begin
		mem_state = 1'b0; // Memoire vide 
	end
	else
		mem_state = 1'b1;
end

// APB Error logic
always_comb begin
	if (full == 1) begin 
		pslverr = 1'b1; // Memoire pleine 
	end
	else 
		pslverr =1'b0;
end

//////////////////////////////////////////////
// END MEMORY LOGIC 
//////////////////////////////////////////////



//////////////////////////////////////////////
// BEGIN WRITE LOGIC 
//////////////////////////////////////////////
assign pready = 1;
assign paddr = 8'b00000000;

always_ff @(posedge clk) begin
	if(!en_cdr)
		mem[wr_ptr] <= shift_register;
	else
		mem[wr_ptr] <= mem[wr_ptr];
end	

// Write pointer logic
always_ff @(posedge clk, negedge reset_n) begin
	if(!reset_n) begin
		wr_ptr <= 'h0;
	end
	else begin
		if(!en_cdr)
			wr_ptr <= wr_ptr + 1;
		else
			wr_ptr <= wr_ptr;
	end
end
//////////////////////////////////////////////
// END WRITE LOGIC 
//////////////////////////////////////////////



//////////////////////////////////////////////
// BEGIN READ LOGIC
//////////////////////////////////////////////
assign rd_en = psel && penable && !pwrite && !empty;

always_ff @(posedge clk) begin
	if(rd_en)
		data_out[rd_ptr] <= mem[rd_ptr];
	else
		data_out[rd_ptr] <= data_out[rd_ptr];
end	

always_ff @(posedge clk, negedge reset_n) begin
	if(!reset_n) begin
		rd_ptr <= 'h0;
	end
	else begin
		if (rd_en) begin
			rd_ptr <= rd_ptr + 1;
		end
		else begin
			rd_ptr <= rd_ptr;
		end
	end
end
//////////////////////////////////////////////
// END READ LOGIC
//////////////////////////////////////////////
endmodule
