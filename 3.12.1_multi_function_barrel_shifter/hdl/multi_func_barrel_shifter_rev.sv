module multi_func_barrel_shifter_rev
(
   input  logic [7:0] a,
   input  logic [2:0] amt,
   input  logic       lr,
   
   output logic [7:0] y
);

   logic [7:0] a_rev, y_rev;
   logic [7:0] a_pre, y_pre;
   
   barrel_shifter_stage u_barrel_shifter
   (
      .a           (a_pre),
	  .amt         (amt),
	  .y           (y_pre)
   );
   
    genvar i;
    generate
       for (i = 0; i < 8; i++)
       begin
          assign a_rev[i] = a[7-i];
          assign y_rev[i] = y_pre[7-i];
       end
    endgenerate
    
	assign a_pre = lr ? a_rev : a; 
	assign y     = lr ? y_rev : y_pre;
	
endmodule