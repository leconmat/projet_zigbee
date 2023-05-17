module bit_recovery(
                    input logic clk,
                    input logic resetn,
                    input logic signed [5:0] phase,
                    input logic ph_valid,
                    output logic data_bits
                    );

logic signed [5:0] phase_q;
logic signed [5:0] phase_r;
logic signed [5:0] phase_diff;
logic overflow;

typedef enum {IDLE, ENABLE, WAIT} state_t;
state_t curr_state, next_state;

always_ff @(posedge clk, negedge resetn) begin
  if(~resetn)
    curr_state <= IDLE;
  else
    curr_state <= next_state;
end

always_comb begin
  case(curr_state)
    IDLE: begin
      if(ph_valid)
        next_state = ENABLE;
      else
        next_state = IDLE;
    end
    ENABLE: begin
      if(~ph_valid)
        next_state = IDLE;
      else
        next_state = WAIT;
    end
    WAIT: begin
      if(~ph_valid)
        next_state = IDLE;
      else
        next_state = WAIT;
    end
    default : begin
	next_state = IDLE;
	end
  endcase
end

always_ff @(posedge clk, negedge resetn) begin
  if(~resetn) begin
    phase_q <= 0;
    phase_r <= 0;
  end else begin
    if(curr_state == ENABLE) begin
      phase_q <= phase;
      phase_r <= phase_q;
    end else begin
      phase_q <= phase_q;
      phase_r <= phase_r;
    end
  end
end

assign overflow = (phase_q[5]^phase_r[5]) ? 0:(phase_diff[5]^phase_q[5]);

always_comb begin  
  phase_diff = phase_q - phase_r;
  if(overflow)
    data_bits = data_bits;
  else if(phase_diff[5])
    data_bits = 0;
  else
    data_bits = 1;
end

endmodule
