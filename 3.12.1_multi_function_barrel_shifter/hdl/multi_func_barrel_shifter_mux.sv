module multi_func_barrel_shifter_mux
(
   input  logic [7:0] a,
   input  logic [2:0] amt,
   input  logic       lr,
   
   output logic [7:0] y
);
   logic [7:0] ls0, ls1, ls2;
   logic [7:0] rs0, rs1, rs2;
   
   // right shift
   assign rs0 = amt[0] ? {a[0], a[7:1]} : a;
   assign rs1 = amt[1] ? {rs0[1:0], rs0[7:2]} : rs0;
   assign rs2 = amt[2] ? {rs1[3:0], rs1[7:4]} : rs1;
   
   // left shift
   assign ls0 = amt[0] ? {a[6:0], a[7]} : a;
   assign ls1 = amt[1] ? {ls0[5:0], ls0[7:6]} : ls0;
   assign ls2 = amt[2] ? {ls1[3:0], ls1[7:4]} : ls1;

   assign y = lr ? ls2 : rs2;    
endmodule