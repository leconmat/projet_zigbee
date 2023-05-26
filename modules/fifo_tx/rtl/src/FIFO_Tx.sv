/** FIFO TX **/
module FIFO_Tx #(
					parameter WIDTH = 8,
					parameter DEPTH = 64
)				
(					input logic clk, // horloge système 
					input logic reset_n,
					input logic en_IQ,
					// APB signals
					input logic [7:0] pwdata,
					input logic psel,
					input logic pwrite,
					input logic penable,
					output logic pready,
					output logic pslverr,
					// Output Tx
					output logic data_out, 
					output logic IQ_rate,
					output reg mem_state // 0 mémoire vide, 1 mémoire remplie ou partiellement remplie
);

//////////////////////////////////// Internal signals ///////////////////////////////////
// Write & Read enable
logic wr_en, rd_en;
// Memory signals 
parameter PTR_WIDTH = $clog2(DEPTH);
logic [WIDTH-1:0] mem [DEPTH-1:0] ;
// Memory pointers	
logic [PTR_WIDTH:0] wr_ptr, rd_ptr;
// Memory flag
logic full;  
logic empty; 
// Rate change counters 50 MHz -> 2 MHz
reg [4:0] counter_clock;
reg [2:0] compteur;

/////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// BEGIN MEMORY LOGIC ////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

always_comb begin
	if((wr_ptr[PTR_WIDTH-1:0]) == (rd_ptr[PTR_WIDTH-1:0])) begin
		full = (wr_ptr[PTR_WIDTH]) ^ (rd_ptr[PTR_WIDTH]); // carry différent => full 
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
		mem_state = 1'b0; // Mémoire vide 
	end
	else
		mem_state = 1'b1;
end

// APB Error logic
always_comb begin
	if (full == 1) begin 
		pslverr = 1'b1; // Mémoire pleine 
	end
	else 
		pslverr =1'b0;
end

/////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// END MEMORY LOGIC //////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// BEGIN WRITE LOGIC /////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

assign pready = 1;
assign wr_en = psel && penable && pwrite && !full;

typedef enum logic {
    Idle_Write,
    Write
    } fsm_wr;
fsm_wr state_wr, next_state_wr;

always_ff @(posedge clk, negedge reset_n) begin
	if (~reset_n)
		for(integer i = 0; i < DEPTH; i++)
			mem[i] <= 0;
	else if(wr_en)
		mem[wr_ptr[PTR_WIDTH-1:0]] <= pwdata;
	else
		mem[wr_ptr[PTR_WIDTH-1:0]] <= mem[wr_ptr[PTR_WIDTH-1:0]];
end

// Write pointer logic
always_ff @(posedge clk, negedge reset_n) begin
	if(~reset_n) begin
		wr_ptr <= 'h0;
	end
	else begin
		if(wr_en)
			wr_ptr <= wr_ptr + 1;
		else
			wr_ptr <= wr_ptr;
	end
end

/////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// END WRITE LOGIC ////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// BEGIN READ LOGIC //////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

assign rd_en = en_IQ && !empty;

typedef enum logic {
    Idle_Read,
    Read
    } fsm_rd;
fsm_rd state_rd, next_state_rd;

always_ff @(posedge clk, negedge reset_n) begin
		if (~reset_n) 
		    state_rd <= Idle_Read;
		else
		    state_rd <= next_state_rd;
end

always_comb begin
	unique case (state_rd)
		Idle_Read: begin 
			if (rd_en) 
				next_state_rd = Read;
			else  
				next_state_rd = Idle_Read;
		end
		Read : begin 
			if (rd_en) 
				next_state_rd = Read;
			else
				next_state_rd = Idle_Read;
		end
		default : begin
			next_state_rd = Idle_Read;
		end
	endcase		
end

always_comb begin
	case (state_rd)
		Idle_Read: begin 
			data_out = 'b0; 
		end
		Read : begin 
			data_out = mem[rd_ptr[PTR_WIDTH-1:0]][compteur];
		end
	endcase		
end

// Output generation at 2MHz
always @(posedge clk, negedge reset_n) begin 
	if (~reset_n) begin
		counter_clock <= 0;
		compteur <= 0;
		IQ_rate <=  0;
		rd_ptr <= 'h0;
	end
	else if (state_rd == Read) begin
		if(counter_clock == 13) begin
			IQ_rate <= 1;
			counter_clock <= counter_clock + 1;
		end
		else if (counter_clock==24) begin 
			IQ_rate <= 0;
			counter_clock <= 'b0;
			if(compteur == 7) begin
				compteur <= 'b0;
				rd_ptr <= rd_ptr + 1;
			end
			else
				compteur <= compteur + 1;
		end 
		else  
			counter_clock <= counter_clock + 1;
	end
	else begin
		counter_clock <= 0;
		compteur <= 0;
		IQ_rate <= 0;
	end
end 

////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// END READ LOGIC ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
endmodule 
