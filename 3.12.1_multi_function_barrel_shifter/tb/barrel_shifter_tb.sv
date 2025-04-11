module barrel_shifter_tb();

   logic [7:0] a;
   logic [2:0] amt;
   logic       lr;
   logic [7:0] y;
   
//   multi_func_barrel_shifter_mux u_mfbs_mux
//   (
//      .a       (a),
//      .amt     (amt),
//      .lr      (lr),
   
//      .y       (y)
//   );

   multi_func_barrel_shifter_rev u_mfbs_rev
   (
      .a       (a),
      .amt     (amt),
      .lr      (lr),
   
      .y       (y)
   );
   
   initial begin
      a   = 8'h11;
	  amt = 3'b000;
	  lr  = 0;
	  #8;
	  for (int i = 0; i < 8 ; i++)
	  begin
	     amt = i; 
		 #8;
	  end
	  lr = 1; 
	  for (int i = 0; i < 8 ; i++)
	  begin
	     amt = i; 
		 #8;
	  end
   end
endmodule