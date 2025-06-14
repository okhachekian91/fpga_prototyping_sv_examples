module div#
(
   parameter W = 8
)
(
   input  logic 		clk,
   input  logic 		rst_n,

   input  logic 		start,
   input  logic [W-1:0] 	dvsr,
   input  logic [W-1:0]		dvnd,
   
   output logic                 ready,
   output logic                 done, 
   output logic [W-1:0]         quo,
   output logic [W-1:0]         rmd
);

   enum logic [1:0] { IDLE    = 2'b00, 
                      OP      = 2'b01,
                      LAST    = 
endmodule
