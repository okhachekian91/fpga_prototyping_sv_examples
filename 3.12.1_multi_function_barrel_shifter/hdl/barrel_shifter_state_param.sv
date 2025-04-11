module barrel_shifter_stage_param #
(
   parameter N  = 8
)
(
   input  logic [N-1:0] a,
   input  logic [($clog2(N))-1:0] amt,
   input  logic lr,
   
   output logic [N-1:0] y
);

   localparam NUM_STATE = $clog2(N);
   logic [N-1:0] s [0:NUM_STATE-1];
   genvar i;
   generate
      for (i = 0; i < NUM_STATE; i = i + 1)
	  begin
	     if (i == 0)
	        assign s[i] = amt[i] ? {a[(2**i)-1:0], a[N-1:(2**i)]} : a;
		 else
		    assign s[i] = amt[i] ? {s[i-1][(2**i)-1:0], s[i-1][N-1:(2**i)]} : s[i-1];
	  end
   endgenerate
   
   assign y = s[NUM_STATE-1];
endmodule