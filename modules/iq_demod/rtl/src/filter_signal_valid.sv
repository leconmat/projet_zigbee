module enable
	(input logic clk,
	input logic resetn,
	input logic valid_ADC,
	output logic ready_ADC);

typedef enum {IDLE,ENABLE,WAIT}fsm_valid;
fsm_valid next_state_valid, current_state_valid;

 always_ff @(posedge clk, negedge resetn)
	begin
		if(~resetn) begin
			current_state_valid <= IDLE;
		end
		else
		begin
			current_state_valid <= next_state_valid;
		end
	end //always_ff

always_comb
	begin
	unique case(current_state_valid)
		IDLE: 
			begin
				if (~valid_ADC)
					next_state_valid <= IDLE;
				else 
					next_state_valid <= ENABLE;
			end
		ENABLE: 
		     	begin
				ready_ADC <= 1'b1;
				next_state_valid <= WAIT; 
			end
		WAIT: 
		     	begin
				if (valid_ADC)
 					next_state_valid <= WAIT; 
				else
					next_state_valid <= IDLE; 
			end
		endcase
	end //always_comb
endmodule

