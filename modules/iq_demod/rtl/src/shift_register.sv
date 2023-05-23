module shift_register #(parameter
  integer            p_depth = 8       // Number of element in delay line 
  )(
  input  logic                       clk,           // Main Clock
  input  logic                       reset,         // Synchronous Active High Reset (More Robust mapping on FPGA)
  input  logic                 [4:0] data_in,       // Input Byte
  input  logic                       data_shift_en, // Shift New byte in Delay Chain
  input  logic                 [2:0] index, 
  output logic                 [4:0] data_out0, data_out1,  data_out2,  data_out3,  data_out4,  data_out5,  data_out6,  data_out7,  data_out8,  data_out9       // Data Register  
);

logic [2:0] sstate = 3'b101;

// == Main Code ================================================================
// Ici on récupère les valeurs converties pas l'ADCpour les stockers avant de les envoyer au MAC
// pour le calcul. Pour ça, on stocke la dernière valeur récupéré à la position 31 et on décale
// toutes les valeurs d'une position pour laisser la position 31 de libre pour la valeur suivante.
always_ff @(posedge clk) begin
  if      (~reset)         begin
                            data_out9<=0;
			    data_out8<=0;
                            data_out7<=0;
			    data_out6<=0;
                            data_out5<=0;
			    data_out4<=0;
                            data_out3<=0;
			    data_out2<=0;
                            data_out1<=0;
			    data_out0<=0;
			    sstate <= 3'b101;
			  end
 
  else if (data_shift_en) begin

			    if (sstate == 3'b101) sstate<= 3'b110;
			    else if (sstate==3'b110) begin 
				    if (index == 3'b000) sstate <= 3'b100;
				    else if (index == 3'b100) sstate <= 3'b000;
				    else sstate<=index+1;
                            end
			    else if (index == sstate) begin 
		                    data_out9<=data_out8;
				    data_out8<=data_out7;
		                    data_out7<=data_out6;
				    data_out6<=data_out5;
		                    data_out5<=data_out4;
				    data_out4<=data_out3;
		                    data_out3<=data_out2;
				    data_out2<=data_out1;
		                    data_out1<=data_out0;
				    data_out0<=data_in;
		                  end
			   
                          end

end
endmodule
