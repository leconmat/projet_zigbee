`define Q1 6'h3E
`define Q2 6'h3E
`define Q3 6'h01
`define Q4 6'h07
`define Q5 6'h0C

module filter(

	input logic clk,
	input logic resetn,
	input bit in_valid,
	input logic [4:0] data_in,
	output logic [4:0] data_out,
	output bit pret,
	output bit out_valid
);

logic [4:0] data_1, data_2;
logic [5:0] out_factor;
logic [12:0] mult;
logic [5:0] sum;
logic [2:0] sel;
logic [12:0] temp;
logic [4:0] shift_reg0, shift_reg1, shift_reg2, shift_reg3, shift_reg4, shift_reg5, shift_reg6, shift_reg7, shift_reg8, shift_reg9;
logic [2:0] shift_count;

mux2 data_reg1 (.in_0(shift_reg0),
	    .in_1(shift_reg1),
	    .in_2(shift_reg2),
	    .in_3(shift_reg3),
	    .in_4(shift_reg4),
	    .sel(sel),
	    .out(data_1)
);
mux2 data_reg2 (.in_0(shift_reg9),
	    .in_1(shift_reg8),
	    .in_2(shift_reg7),
	    .in_3(shift_reg6),
	    .in_4(shift_reg5),
	    .sel(sel),
	    .out(data_2)
);
mux factor (.in_0(`Q1),
	    .in_1(`Q2),
	    .in_2(`Q3),
	    .in_3(`Q4),
	    .in_4(`Q5),
	    .sel(sel),
	    .out(out_factor)
);

enable valid (.clk(clk),
	      .resetn(resetn),
	      .valid_ADC(in_valid),
	      .ready_ADC(pret)
);

shift_register shift_r (.clk(clk),
			.reset(resetn),
			.data_in(data_in),
			.data_shift_en(in_valid),
			.data_out0(shift_reg0),
			.data_out1(shift_reg1),
			.data_out2(shift_reg2),
			.data_out3(shift_reg3),
			.data_out4(shift_reg4),
			.data_out5(shift_reg5),
			.data_out6(shift_reg6),
			.data_out7(shift_reg7),
			.data_out8(shift_reg8),
			.data_out9(shift_reg9),
			.cpt_shift(shift_count)
);

typedef enum  {
  INIT, ZERO, ONE, TWO, THREE, FOUR
   } fsm_t;

fsm_t current_state, next_state;

 always_ff @(posedge clk, negedge resetn)
	begin
	     if(~resetn) begin
		current_state <= INIT;
		data_out <= 0;
		temp <= 0;
	     end
	     else 
		begin
			if (shift_count == 3'b100) begin 
				data_out <= temp[12:8];				
				temp <= mult;
			end
			else begin
				temp <= temp + mult;
			end
		current_state <= next_state;
		end
	end 


always_comb
	begin
	     unique case(current_state)
		INIT:
		    begin
			next_state = ZERO;
		    end
		ZERO:
		     begin
			sel = 3'b000;
			next_state = ONE;
			end
		ONE:
		     begin
			sel = 3'b001;
			next_state = TWO;			
			end
		TWO:
		     begin
			sel = 3'b010;
			next_state = THREE;		
			end
		THREE:
		     begin
			sel = 3'b011;
			next_state = FOUR;
			end
		FOUR:
		     begin
			sel = 3'b100;
			next_state = ZERO;
			end
		endcase
	end
	assign sum = data_1 + data_2;
	assign mult = out_factor * sum; 
endmodule
