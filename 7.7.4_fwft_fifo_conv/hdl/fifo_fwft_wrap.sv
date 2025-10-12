module fifo_fwft_wrap #
(
   parameter DWIDTH = 8,
   parameter AWIDTH = 8
)
(
   input  logic               clk,
   input  logic               rstn,

   input  logic [DWIDTH-1:0]  din,
   input  logic               w_en,

   output logic [DWIDTH-1:0]  dout,
   input  logic               r_en,

   output logic               full,
   output logic               empty
);
   
   logic         empty_dly;
   logic         fwft_rd_en;
   logic         first_rd;

   always_ff @(posedge clk)
   begin
      if (!rstn)
         empty_dly <= 1'b0;
      else
         empty_dly <= empty;
   end

   always_ff @(posedge clk)
   begin
      if (!rstn)
         first_rd <= 1'b1;
      else if (fwft_rd_en)
         first_rd <= 1'b0;
   end
   
   assign fwft_rd_en = (!empty && empty_dly && first_rd) || r_en; 
    
   fifo #
   (
      .DWIDTH          (DWIDTH),
      .AWIDTH          (AWIDTH)
   ) u_fifo
   (
      .clk             (clk),
      .rstn            (rstn),
      .din             (din),
      .w_en            (w_en),
      .dout            (dout),
      .r_en            (fwft_rd_en),
      .full            (full),
      .empty           (empty)
   );

endmodule
