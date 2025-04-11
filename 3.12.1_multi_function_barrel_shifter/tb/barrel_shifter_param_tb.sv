module barrel_shifter_param_tb();

   localparam N = 8;
   logic [N-1:0]           a;
   logic [($clog2(N))-1:0] amt;
   logic                   lr;
   logic [N-1:0]           y;
   
//   multi_func_barrel_shifter_mux u_mfbs_mux
//   (
//      .a       (a),
//      .amt     (amt),
//      .lr      (lr),
   
//      .y       (y)
//   );
   
   
   param_multi_func_shifter #
   (
      .N       (N)
   )
   u_mfbs_rev
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
	  for (int i = 0; i < N ; i++)
	  begin
	     amt = i; 
		 #8;
	  end
	  lr = 1; 
	  for (int i = 0; i < N ; i++)
	  begin
	     amt = i; 
		 #8;
	  end
   end
endmodule