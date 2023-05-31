//==============================================================================
//  Filename    : SINE GENERATION Finite-State-Machine                                              
//  Designer    : --
//  Description : Main FSM Used to generate sines. 
//==============================================================================
module fsm (
  input  logic       clk,               // Main Clock
  input  logic       resetn,             // Synchronous Active High Reset (More Robust mapping on FPGA)

  // Sine Signals
  output logic [1:0] cosine_out,        
  output logic [1:0] sine_out
   
);

// == Variables Declaration ====================================================

// On déclare l'ensemble des états possibles de la fsm. Les variables next_state
// et current_state permettent de connaitre l'état actuel et l'état suivant de la fsm.
// La variable i permet de connaitre l'étape de calcul en cours du MAC.

logic  [1:0] cosine_out_prev;
logic [2:0] counter;

typedef enum  {
  INIT, ONE, TWO, THREE, FOUR
   } fsm_t;

  fsm_t current_state, next_state;

// == Main Code ================================================================
 
// == Always FF ================================================================
// Ici on gère les états de la fsm. A chaque front montant de l'horloge ou lors
// d'un reset, on passe à l'état suivant.
  always_ff @(posedge clk, negedge resetn)
	begin
	     if(~resetn) begin
		current_state <= INIT;
		counter=0;
	     end
	     else if (counter==4) begin
		current_state <= next_state;
		counter=0;
		end
	     else
		counter++;
	end

// == Always comb ==============================================================
// Ici on décrit l'ensemble des états de la fsm, à savoir la valeur des sorties dans 
// chaque cas, ainsi que le positionnement de l'état suivant, en fonction des entrées 
// et de l'état dans lequel on se trouve actuellement.

always_comb
	begin
	     unique case(current_state)
		INIT:
		     begin
			cosine_out_prev = 2'b00; 
			cosine_out = 2'b00;
			sine_out = 2'b00;
			next_state = ONE;
			end
		ONE:
		     begin
			cosine_out = 2'b01;
			sine_out = cosine_out_prev;
			cosine_out_prev = cosine_out;
			next_state = TWO;
			end

		TWO:
		     begin
			cosine_out = 2'b00;
			sine_out = cosine_out_prev;
			cosine_out_prev = cosine_out;
			next_state = THREE;
		     end
			
		THREE:
		     begin
			cosine_out = 2'b11;
			sine_out = cosine_out_prev;
			cosine_out_prev = cosine_out;
			next_state = FOUR;
		     end
			
		FOUR:
		     begin
			cosine_out = 2'b00;
			sine_out = cosine_out_prev;
			cosine_out_prev = cosine_out;
			next_state = ONE;
		     end

		endcase
	end
endmodule
