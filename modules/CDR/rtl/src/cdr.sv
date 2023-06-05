module cdr(
           input logic clk,
           input logic resetn_i,
           input logic data_i,
           output logic data_en_o,
           output logic data_o
           );

logic data_en_w;
logic T_w;
logic E_w;
logic q1, q2, q3, q4;
logic [4:0] count;
logic [4:0] cycles;

typedef enum {IDLE, UP, DOWN} state_t;
state_t curr_state, next_state;

//bang bang
always_ff @(posedge data_en_w, negedge resetn_i) begin
  if(~resetn_i) begin
    q1 <= 0;
    q2 <= 0;
    q4 <= 0;
  end else begin
    q1 <= data_i;
    q2 <= q1;
    q4 <= q3;
  
  end
end

always_ff @(negedge data_en_w, negedge resetn_i) begin
  if(~resetn_i) begin
    q3 <= 0;
  end else begin
    q3 <= data_i;
  end
end

assign T_w = q1 ^ q2;
assign E_w = q2 ^ q4;
// fin bang bang
// debut data gen

/*********************************************************/
/* FSM for perdiod control
/*********************************************************/

always_ff @(posedge clk, negedge resetn_i) begin
  if(~resetn_i)
    curr_state <= IDLE;
  else
    curr_state <= next_state;
end

always_comb begin
  case(curr_state)
    IDLE: begin
      if(T_w && E_w)
        next_state = DOWN;
      else if(T_w && ~E_w)
        next_state = UP;
      else
        next_state = IDLE;
    end
    UP: begin
      if(~T_w)
        next_state = IDLE;
      else if(E_w)
        next_state = DOWN;
      else
        next_state = UP;
    end
    DOWN: begin
      if(~T_w)
        next_state = IDLE;
      else if(~E_w)
        next_state = UP;
      else
        next_state = DOWN;
    end
    default : begin
	next_state = IDLE;
    end
  endcase
end

always_comb begin
  case(curr_state)
    IDLE: begin
      cycles = 24;
    end
    UP: begin
      cycles = 23;
    end
    DOWN: begin
      cycles = 25;
    end
    default : begin
      cycles = 24;
    end
  endcase
end

/*********************************************************/
/* End of FSM
/*********************************************************/

always_ff @(posedge clk, negedge resetn_i) begin
  if(~resetn_i) begin
    data_en_w <= 1;
    count <= 24;
  end else begin
    if(count == cycles) begin
      count <= 0;
      data_en_w <= ~data_en_w;
    end else
      count <= count + 1;
      if(count == 12)
        data_en_w <= ~data_en_w;
  end  
end

//fin data gen


// Decision
logic data_en_w_q;

always_ff @(posedge clk, negedge resetn_i) begin
  if(~resetn_i) begin
    data_en_w_q <= 'b0;
    data_en_o <= 'b0;
    data_o <= 'b0;
  end
  else begin
    data_en_w_q <= data_en_w;
    if(~data_en_w && data_en_w_q) begin
      data_o <= data_i;
      data_en_o <= 1'b1;
    end
    else begin
      data_o <= data_o;
      data_en_o <= 'b0;
    end
  end
end

endmodule
