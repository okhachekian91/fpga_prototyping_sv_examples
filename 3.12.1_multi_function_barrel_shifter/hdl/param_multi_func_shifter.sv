module param_multi_func_shifter #
(
   parameter N = 8
)
(
   input  logic [N-1:0]           a,
   input  logic [($clog2(N))-1:0] amt,
   input  logic                   lr,
   
   output logic [N-1:0]           y
);

   logic [N-1:0] a_rev, y_rev;
   logic [N-1:0] a_pre, y_pre;
   
   barrel_shifter_stage_param #
   (
      .N           (N)
   )
   u_barrel_shifter
   (
      .a           (a_pre),
	  .amt         (amt),
	  .lr          (lr),
	  .y           (y_pre)
   );
   
    genvar i;
    generate
       for (i = 0; i < N; i++)
       begin
          assign a_rev[i] = a[N-i-1];
          assign y_rev[i] = y_pre[N-i-1];
       end
    endgenerate
    
	assign a_pre = lr ? a_rev : a; 
	assign y     = lr ? y_rev : y_pre;
	
endmodule