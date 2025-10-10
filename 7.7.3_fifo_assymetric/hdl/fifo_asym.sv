module fifo_asym # 
(
   parameter DWIDTH = 8,
   parameter AWIDTH = 8
)
(
   input  logic                clk,
   input  logic                rstn,

   input  logic [2*DWIDTH-1:0] din,
   input  logic                w_en,
  
   output logic [DWIDTH-1:0]   dout,
   input  logic 	       r_en,

   output logic                full,
   output logic                empty
);

   logic [2*DWIDTH-1:0] ram [0:2**AWIDTH-1];
   logic [AWIDTH:0]       wr_ptr;
   logic [AWIDTH+1:0]     rd_ptr;

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
      if (w_en)
         ram[wr_ptr[AWIDTH-1:0]] <= din;
   end

   assign dout = rd_ptr[0] ? ram[rd_ptr[AWIDTH:1]][2*DWIDTH-1:DWIDTH] :ram[rd_ptr[AWIDTH:1]][DWIDTH-1:0] ;

   assign full  = ((wr_ptr[AWIDTH] != rd_ptr[AWIDTH+1]) && (wr_ptr[AWIDTH-1:0] == rd_ptr[AWIDTH:1])) ? 1'b1 : 1'b0;
   assign empty = ((wr_ptr[AWIDTH] == rd_ptr[AWIDTH+1]) && (wr_ptr[AWIDTH-1:0] == rd_ptr[AWIDTH:1])) ? 1'b1 : 1'b0;

endmodule
