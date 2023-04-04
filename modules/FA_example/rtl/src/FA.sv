module FA(input logic A,
          input logic B,
          input logic Cin,
          output logic Cout,
          output logic S);

assign Cout = (A&B) | (A&Cin) | (B&Cin);
assign S = A^B^Cin;

endmodule
