//==============================================================================
//  Filename    : SINE GENERATION Finite-State-Machine                                              
//  Designer    : --
//  Description : Main FSM Used to generate sines. On tourne dans le sens horaire
//==============================================================================
module fsm (
  input  logic       clk,               // Main Clock
  input  logic       resetn,             // Synchronous Active High Reset (More Robust mapping on FPGA)

  // Sine Signals
  output logic signed [1:0] cosine_out,        
  output logic signed [1:0] sine_out
   
);

// == Variables Declaration ====================================================

// On déclare l'ensemble des états possibles de la fsm. Les variables next_state
// et current_state permettent de connaitre l'état actuel et l'état suivant de la fsm.
// La variable i permet de connaitre l'étape de calcul en cours du MAC.

//logic signed [1:0] sine_out_prev;
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
	counter <= 0;
     end
     else if (counter==4) begin
	current_state <= next_state;
	counter <= 0;
	end
     else
	counter <= counter + 1;
end

// == Always comb ==============================================================
// Ici on décrit l'ensemble des états de la fsm, à savoir la valeur des sorties dans 
// chaque cas, ainsi que le positionnement de l'état suivant, en fonction des entrées 
// et de l'état dans lequel on se trouve actuellement.

/*always_comb
	begin
	     unique case(current_state)
		INIT:
		     begin
			//sine_out_prev <= 0; 
			sine_out = 0;
			cosine_out = 0;
			next_state = ONE;
			end
		ONE:
		     begin
			cosine_out = sine_out;
			sine_out = 1;
			//sine_out_prev <= 1;
			next_state = TWO;
			end

		TWO:
		     begin
			cosine_out = sine_out;
			sine_out = 0;
			//sine_out_prev <= 0;
			next_state = THREE;
		     end
			
		THREE:
		     begin
			cosine_out = sine_out;
			sine_out = -1;
			//sine_out_prev <= -1;
			next_state = FOUR;
		     end
			
		FOUR:
		     begin
			cosine_out = sine_out;
			sine_out = 0;
			//sine_out_prev <= 0;
			next_state = ONE;
		     end

		endcase
	end*/

always_comb
	begin
	     unique case(current_state)
		INIT:
		     begin
			sine_out = 0;
			cosine_out = 1;
			next_state = ONE;
			end
		ONE:
		     begin
			cosine_out = 0;
			sine_out = 1;
			next_state = TWO;
			end

		TWO:
		     begin
			cosine_out = -1;
			sine_out = 0;
			next_state = THREE;
		     end
			
		THREE:
		     begin
			cosine_out = 0;
			sine_out = -1;
			next_state = FOUR;
		     end
			
		FOUR:
		     begin
			cosine_out = 1;
			sine_out = 0;
			next_state = ONE;
		     end
		default :
			begin
			sine_out = 0;
			cosine_out = 1;
			next_state = INIT;
			end
		endcase
	end

endmodule
