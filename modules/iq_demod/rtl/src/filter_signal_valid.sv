module enable
	(input logic clk,
	input logic resetn,
	input logic ADC_rdy,
	output logic demod_rdy);

typedef enum {IDLE,S_ENABLE,WAIT}fsm_valid;
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
				if (~ADC_rdy)
					next_state_valid <= IDLE;
				else 
					next_state_valid <= S_ENABLE;
			end
		S_ENABLE: 
		     	begin
				next_state_valid <= WAIT; 
			end
		WAIT: 
		     	begin
				if (ADC_rdy)
 					next_state_valid <= WAIT; 
				else
					next_state_valid <= IDLE; 
			end
		default:
			begin
				next_state_valid <= IDLE;
			end
		endcase
	end //always_comb
	assign demod_rdy = current_state_valid == S_ENABLE ? 1 : 0;
endmodule

