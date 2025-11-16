module stack #
(
   parameter DWIDTH = 8,
   parameter AWIDTH = 8
)
(
   input  logic              clk,
   input  logic              rstn,
  
   input  logic [DWIDTH-1:0] din,
   input  logic              push,

   output logic [DWIDTH-1:0] dout,
   input  logic              pop,

   output logic              full,
   output logic              empty
);

   logic [DWIDTH-1:0] ram [0:2**AWIDTH -1];
   logic [AWIDTH-1:0] stack_ptr; 

   always_ff @(posedge clk)
   begin
      if (!rstn)
         stack_ptr <= 'b0;
      else
      begin
         if ((push && !full) && (pop && !empty))
            stack_ptr <= stack_ptr;
         else if (push && !full)
            stack_ptr <= stack_ptr + 1;
         else if (pop && !empty)
            stack_ptr <= stack_ptr - 1;
      end
   end

   always_ff @(posedge clk)
   begin
      if (push)
         ram[stack_ptr] <= din;
   end

   assign dout = ram[stack_ptr];

   assign full  = stack_ptr == 2**AWIDTH - 1; 
   assign empty = stack_ptr == 'b0;

endmodule
