module fp_gt
(
   input  logic         sign1,
   input  logic [3:0]   exp1,
   input  logic [7:0]   frac1,
   
   input  logic         sign2,
   input  logic [3:0]   exp2,
   input  logic [7:0]   frac2,
   
   output logic         gt
);
 
   always_comb
   begin
      if (sign2 > sign1)
	     gt = 1'b1;
	  else if (sign1 > sign2)
	     gt = 1'b0;
	  else
	  begin
	     if ((sign1 == 1'b1) && (sign2 == 1'b1))
	     begin
	     	if ({exp1,frac1} > {exp2,frac2})
		       gt = 1'b0;
		 else
		       gt = 1'b1;
	     end
	     else 
	     begin
	        if ({exp1,frac1} > {exp2,frac2})
		       gt = 1'b1;
		    else
		       gt = 1'b0;
		 end
	  end
   end
   
endmodule