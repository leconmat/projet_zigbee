module FA_tb();

logic A, B, Cin, S, Cout;

FA dut(
      .A(A),
      .B(B),
      .Cin(Cin),
      .Cout(Cout),
      .S(S)
      );

initial begin
  A = 1'b0;
  B = 1'b0;
  Cin = 1'b0;
  #20
  A = 1'b1;
  #20
  B = 1'b1;
  #20
  A = 1'b0;
  #20
  A = 1'b0;
  B = 1'b0;
  Cin = 1'b1;
  #20
  A = 1'b1;
  #20
  B = 1'b1;
  #20
  A = 1'b0;

end

endmodule
