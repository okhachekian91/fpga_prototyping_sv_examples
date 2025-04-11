module greater_than_4b
(
   input  logic [3:0] a,
   input  logic [3:0] b,
   
   output logic       y
);

logic y1, y2, eq;

greater_than_2b g2b_u (.a (a[3:2]), .b (b[3:2]), .y(y1));
eq2b eq2_u (.a (a[3:2]), .b (b[3:2]), .eq (eq));
greater_than_2b g2b_l (.a (a[1:0]), .b (b[1:0]), .y (y2));

assign y = y1 || (eq && y2);


endmodule