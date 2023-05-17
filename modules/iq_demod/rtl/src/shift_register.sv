module shift_register #(parameter
  integer            p_depth = 8       // Number of element in delay line 
  )(
  input  logic                       clk,           // Main Clock
  input  logic                       reset,         // Synchronous Active High Reset (More Robust mapping on FPGA)
  input  logic                 [4:0] data_in,       // Input Byte
  input  logic                       data_shift_en, // Shift New byte in Delay Chain
  input  logic [$clog2(p_depth)-1:0] data_index,    // Index of the element in delay chain propagated to data_out
  output logic                 [4:0] data_out       // Data Register  
);

// == Variables Declaration ====================================================
logic [p_depth-1:0][7:0] data_line ;

// == Main Code ================================================================
// Ici on récupère les valeurs converties pas l'ADCpour les stockers avant de les envoyer au MAC
// pour le calcul. Pour ça, on stocke la dernière valeur récupéré à la position 31 et on décale
// toutes les valeurs d'une position pour laisser la position 31 de libre pour la valeur suivante.
always_ff @(posedge clk)
  if      (reset)         data_line <= '{default:8'h00};
  else if (data_shift_en) begin
                            data_line[p_depth-1]   <= data_in;                // We add next sample in MSB
                            data_line[p_depth-2:0] <= data_line[p_depth-1:1];
                          end

assign data_out = data_line[data_index];

endmodule
