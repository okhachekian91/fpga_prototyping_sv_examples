module fifo_fwft_extended # 
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
   output logic              empty,
   
   output logic              almost_full,
   output logic              almost_empty,
   output logic [AWIDTH:0] word_cnt
);

   localparam ALMOST_EMPTY_THRESH = 2**AWIDTH >> 2;
   localparam ALMOST_FULL_THRESH   = 3 * ALMOST_EMPTY_THRESH;

   logic [DWIDTH-1:0] ram [0:2**AWIDTH-1];
   logic [AWIDTH:0]   wr_ptr;
   logic [AWIDTH:0]   rd_ptr;

   always_ff @(posedge clk)
   begin
      if (!rstn)
      begin
         wr_ptr   <= 'b0;
         rd_ptr   <= 'b0;
      end
      else
      begin
         if ((w_en) && (!full))
            wr_ptr      <= wr_ptr + 1;
 
         if ((r_en) && (!empty))
            rd_ptr     <= rd_ptr + 1;
      end
   end

   always_ff @(posedge clk)
   begin
      if (!rstn)
         word_cnt <= 'b0;
      else if (((w_en) && (!full)) && ((r_en) && (!empty)))
         word_cnt <= word_cnt;
      else if ((w_en) && (!full))
         word_cnt <= word_cnt + 1;
      else if ((r_en) && (!empty))
         word_cnt <= word_cnt - 1;
   end

   always_ff @(posedge clk)
   begin
      if (w_en)
         ram[wr_ptr[AWIDTH-1:0]] <= din;
   end

   assign dout = ram[rd_ptr[AWIDTH-1:0]];

   assign full  = ((wr_ptr[AWIDTH] != rd_ptr[AWIDTH]) && (wr_ptr[AWIDTH-1:0] == rd_ptr[AWIDTH-1:0])) ? 1'b1 : 1'b0;
   assign empty = ((wr_ptr[AWIDTH] == rd_ptr[AWIDTH]) && (wr_ptr[AWIDTH-1:0] == rd_ptr[AWIDTH-1:0])) ? 1'b1 : 1'b0;

   assign almost_empty = (word_cnt <= ALMOST_EMPTY_THRESH);
   assign almost_full  = (word_cnt >= ALMOST_FULL_THRESH);
endmodule
