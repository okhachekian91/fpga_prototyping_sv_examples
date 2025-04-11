module greater_than_2b
(
   input  logic [1:0] a,
   input  logic [1:0] b,
   
   output logic       y
);

   assign y = ((a[1] && !b[1]) || (a[0] && !b[1] && !b[0]) || (a[1] && a[0] && !b[0]));
endmodule