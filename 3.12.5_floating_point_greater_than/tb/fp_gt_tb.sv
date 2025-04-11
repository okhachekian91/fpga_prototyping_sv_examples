module fp_gt_tb();


   logic         sign1, sign2;
   logic [3:0]   exp1, exp2;
   logic [7:0]   frac1, frac2;
   logic         gt;
   
   fp_gt u_fp_gt
   (
      .sign1       (sign1),
	  .exp1        (exp1),
	  .frac1       (frac1),
	  .sign2       (sign2),
	  .exp2        (exp2),
	  .frac2       (frac2),
	  .gt          (gt)
   );
   
   initial
   begin
      sign1 = 1'b0;
      frac1 = 'b0;
      exp1  = 'b0;
      sign2 = 1'b0;
      frac2 = 'b0;
      exp2  = 'b0;
      #10;
      sign1 = 1'b0; frac1 = 8'h54; exp1 = 4'h3; //+0.54E3
      sign2 = 1'b1; frac2 = 8'h87; exp2 = 4'h4; //-0.87E4
      #10;
      sign1 = 1'b1; frac1 = 8'h55; exp1 = 4'h3; //-0.55E3
      sign2 = 1'b0; frac2 = 8'h54; exp2 = 4'h3; //+0.54E3
      #10;
      sign1 = 1'b0; frac1 = 8'h54; exp1 = 4'h0; //+0.54E0
      sign2 = 1'b1; frac2 = 8'h55; exp2 = 4'h0; //-0.55E0
      #10;
      sign1 = 1'b0; frac1 = 8'h56; exp1 = 4'h3; //+0.56E3
      sign2 = 1'b0; frac2 = 8'h52; exp2 = 4'h3; //+0.52E3
      #10;
      sign1 = 1'b1; frac1 = 8'h56; exp1 = 4'h3; //-0.56E3
      sign2 = 1'b1; frac2 = 8'h52; exp2 = 4'h3; //-0.52E3
      #10;
   end
endmodule