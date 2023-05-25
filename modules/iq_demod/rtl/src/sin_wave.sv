// https://community.cadence.com/cadence_blogs_8/b/fv/posts/create-a-sine-wave-generator-using-systemverilog

// This block support Frequency in khz
module sin_wave #(parameter
  real offset = 0,
  real ampl   = 0.3
 )(
  input  real freq,
  output real sinus
 );

 timeunit      1us;
 timeprecision 1ns;
 
 import "DPI-C" pure function real sin (input real rTheta);

 localparam  sampling_time = 0.1; // timeunit in us then period is 100ns

 const real pi = 3.14159265359;

 always #(sampling_time) sinus = offset + (ampl * sin(2*pi*freq*($realtime/1000)));


endmodule
