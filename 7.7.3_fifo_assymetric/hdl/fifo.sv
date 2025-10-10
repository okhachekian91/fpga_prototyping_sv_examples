module fifo # 
(
   parameter DWIDTH = 8,
   parameter AWIDTH = 8
)
(
   input  logic              clk,
   input  logic              rstn,

   input  logic [DWIDTH-1:0] din,
   input  logic              w_en,
  
   output logic [DWIDTH-1:0] dout,
   input  logic 	     r_en,

   output logic              full,
   output logic              empty
);

   logic [DWIDTH-1:0] ram [0:2**AWIDTH-1];
   logic [AWIDTH:0]   wr_ptr;
   logic [AWIDTH:0]   rd_ptr;

   always_ff @(posedge clk)
   begin
      if (!rstn)
      begin
         wr_ptr   <= 'b0;
         rd_ptr   <= 'b0;
         dout     <= 'b0;
      end
      else
      begin
         if ((w_en) && (!full))
            wr_ptr      <= wr_ptr + 1;
 
         if ((r_en) && (!empty))
         begin
            rd_ptr     <= rd_ptr + 1;
            dout       <= ram[rd_ptr[AWIDTH-1:0]];
         end
      end
   end

   always_ff @(posedge clk)
   begin
      if (w_en)
         ram[wr_ptr[AWIDTH-1:0]] <= din;
   end

   assign full  = ((wr_ptr[AWIDTH] != rd_ptr[AWIDTH]) && (wr_ptr[AWIDTH-1:0] == rd_ptr[AWIDTH-1:0])) ? 1'b1 : 1'b0;
   assign empty = ((wr_ptr[AWIDTH] == rd_ptr[AWIDTH]) && (wr_ptr[AWIDTH-1:0] == rd_ptr[AWIDTH-1:0])) ? 1'b1 : 1'b0;

endmodule
