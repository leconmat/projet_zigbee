`define Q1 -0.084486
`define Q2 0.013047
`define Q3 0.201273
`define Q4 0.377291


module filter(

	input logic clk,
	input logic resetn,

	input  logic [4:0] data_in,
	output logic [4:0] data_out
);

logic data_1, data_2, out_factor;
logic [5:0] mult;
logic [5:0] sum;
logic [1:0] sel;
logic [7:0] shift_reg [4:0];
logic validation, pret;
logic [2:0] indicateur;

mux data_reg1 (.in_0(shift_reg[0]),
	    .in_1(shift_reg[1]),
	    .in_2(shift_reg[2]),
	    .in_3(shift_reg[3]),
	    .sel(sel),
	    .out(data_1)
);
mux data_reg2 (.in_0(shift_reg[7]),
	    .in_1(shift_reg[6]),
	    .in_2(shift_reg[5]),
	    .in_3(shift_reg[4]),
	    .sel(sel),
	    .out(data_2)
);
mux factor (.in_0(`Q1),
	    .in_1(`Q2),
	    .in_2(`Q3),
	    .in_3(`Q4),
	    .sel(sel),
	    .out(out_factor)
);

enable valid (.clk(clk),
	      .resetn(resetn),
	      .valid_ADC(validation),
	      .ready_ADC(pret)
);

shift_register shift_r (.clk(clk),
			.reset(resetn),
			.data_in(data_in),
			.data_shift_en(validation),
			.data_index(indicateur),
			.data_out(shift_reg[0])
);

typedef enum  {
  INIT, ZERO, ONE, TWO, THREE, FOUR
   } fsm_t;

fsm_t current_state, next_state;

 always_ff @(posedge clk, negedge resetn)
	begin
	     if(~resetn) begin
		current_state <= INIT;
		data_out <= 5'b0; 
	     end
	     else
		current_state <= next_state;
		data_out <= data_out + mult;
	end 


always_comb
	begin
	     unique case(current_state)
		INIT:
		    begin
			shift_reg[0] = 5'b0;
			shift_reg[1] = 5'b0;	
			shift_reg[2] = 5'b0;
			shift_reg[3] = 5'b0;
			shift_reg[4] = 5'b0;	
			shift_reg[5] = 5'b0;
			shift_reg[6] = 5'b0;
			shift_reg[7] = 5'b0;
			next_state = ZERO;
		    end
		ZERO:
		     begin
			sel = 2'b00;
			next_state = ONE;
			end
		ONE:
		     begin
			sel = 2'b01;
			next_state = TWO;			
			end
		TWO:
		     begin
			sel = 2'b10;
			next_state = THREE;		
			end
		THREE:
		     begin
			sel = 2'b11;
			next_state = ZERO;
			end
		endcase
	end
	assign sum = data_1 + data_2;
	assign mult = out_factor * sum; 
endmodule
