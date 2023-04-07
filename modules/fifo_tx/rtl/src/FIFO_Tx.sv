/** FIFO TX **/
module FIFO_Tx (data_in, PADDR, PSEL, PWRITE, PENABLE, en_IQ, PREADY, PSLVERR, data_out, IQ_rate, mem_state)
///////////////////////// IO Declaration ///////////////////////////
// IO global  
input logic clk; // horloge système 
input logic PCLK; // horloge APB
input logic reset;
// Input Tx (APB)
input [7:0] data_in;
input [7:0] PADDR;
input logic PSEL;
input logic PWRITE;
input logic en_IQ;
input logic PENABLE;
// Output Tx
output logic [7:0] data_out; //(* parallel_encoding = "none" *)
output IQ_rate;
output reg [1:0] mem_state;
output logic PREADY;
output logic PSLVERR;
// Variables internes
parameter WIDTH = 8;
parameter DEPTH = 64;
reg cnt_full; // Flag mémoire pleine
reg cnt_empty; // Flag mémoire vide
//pointeurs wr et rd
logic [WIDTH-1:0] wr_ptr, rd_ptr;
logic [WIDTH-1:0] next_wr_ptr, next_rd_ptr;
// compteur de l'espace dans la fifo
logic [WIDTH:0] count; // nombre d'éléments stockés dans la mémoire
logic [WIDTH:0] next_count;
// Mémoire FIFO
logic [WIDTH-1:0] mem [DEPTH-1:0];
// Assign
assign PREADY = 1;
///////////////////////////////////////////////////////////////////
//Declaration FSM
typedef enum logic [2:0] {
    Idle_Write,
    Start_Write,
    Write,
    } fsm_wr;

fsm_wr state_wr, next_state_wr;

typedef enum logic [1:0] {
    Idle_Read,
    Read
    } fsm_rd;

fsm_rd state_rd, next_state_rd;

// FSM d'écriture dans la mémoire
always_ff @(posedge PCLK, negedge reset) 
begin
	if (reset) begin
	    state_wr <= Idle_Write;
	    cnt_full <= 0;
	    cnt_empty <= DEPTH;
	end else begin
	    state_wr <= next_state_wr;
	end
end
always_comb begin
    next_state_wr=state_wr; // Synchro des états
	case (state_wr)
		Idle_Write: begin 
			if (PENABLE=1 && PSEL=1 && PWRITE=1) begin // Vérif protocole APB
				next_state = Start_Write;
			end
			else if (PENABLE=0 || PSEL=0 || PWRITE=0) begin 
				next_state = Idle_Write;
			end
		end
		Start_Write : begin
			if (PADDR=8'h0 && cnt_full != 1) begin // Vérif adresse FIFO + Mémoire 8'h0
				next_state_wr = Write;
			end
			else if (PADDR!=8'h0 || cnt_full = 1) begin
				next_state_wr = Start_Write;
			end	
		end
		Write : begin 
			next_wr_ptr = wr_ptr + 1'b1; // incrémenter pointeur écriture
			next_count = count + 1'b1; // incrémenter count
			mem[wr_ptr] = data_in; // Ecriture de la data dans la mémoire
			wr_ptr = next_wr_ptr; // MàJ de wr_ptr
			count = next_count; // MàJ de count
			next_state_wr = Idle_Write;
			if (count == DEPTH) begin
				cnt_full <= 1'b1;
			end
	end case
end 		
// FSM lecture depuis la mémoire 
always_ff @(posedge PCLK, negedge reset) begin
		if (reset) begin
		    state_rd <= Idle_Read;
		    cnt_full <= 0;
		    cnt_empty <= DEPTH;
		end else begin
		    state_rd <= next_state_rd;
		end
end
always_comb begin
	next_state_rd=state_rd; // Synchro des états 
	case (state_rd)
		Idle_Read: begin 
			if (cnt_empty != 1 && en_IQ = 1) begin 
				next_state_rd = Read;
			end
			else if (cnt_empty = 1 || en_IQ = 0) begin 
				next_state_rd = Idle_Read;
			end
		end
		Read : begin 
			next_rd_ptr = rd_ptr + 1'b1;
			next_count = count - 1'b1;
			data_out = mem [rd_ptr];
			rd_ptr = next_rd_ptr; // MàJ de wr_ptr
			count = next_count; // MàJ de count
			next_state_rd = Idle_Read;
		end
		if (count==1'b0) begin 
			cnt_empty = 1;
		end		
	end case		
end 		
// Blocs Gestion Mémoire 
always_comb begin 
	if (count == 0) begin
		mem_state <= 2'b01; // Mémoire vide 
	end else if ( count == DEPTH) 
		mem_state <= 2'b10; // Mémoire pleine 
	end 
end
always_ff @(posedge clk, negedge reset) begin 
	if (reset) begin 
		wr_ptr <= 0;
		rd_ptr <= 0;
		count <= 0;
	end else begin 
		if (next_wr_ptr != wr_ptr) // écriture en cours
			cnt_empty <= 0; // la fifo n'est plus vide
		end
		wr_ptr <= next_wr_ptr;  
		count <= next_count; 
		if (next_rd_ptr != rd_ptr) // lecture en cours
			cnt_full <= 0; // la fifo n'est plus vide
		end
		rd_ptr <= next_rd_ptr;  
		count <= next_count; 
end


    

