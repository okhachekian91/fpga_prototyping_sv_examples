module fifo_tb();

   localparam AWIDTH = 8;
   localparam DWIDTH = 8;

   logic              clk;
   logic              rstn;

   logic [DWIDTH-1:0] data_in;
   logic              wr_en;
   logic [DWIDTH-1:0] data_out;
   logic              rd_en;
   logic              fifo_full;
   logic              fifo_empty;

   initial
   begin
      clk = 1'b0;
      forever #4 clk = ~clk;
   end


   fifo_fwft_wrap # (
      .AWIDTH         (AWIDTH),
      .DWIDTH         (DWIDTH)
   ) dut
   (
      .clk            (clk),
      .rstn           (rstn),
      .din            (data_in),
      .w_en           (wr_en),
      .dout           (data_out),
      .r_en           (rd_en),
      .full           (fifo_full),
      .empty          (fifo_empty)	
   );

   initial
   begin
      data_in = 'b0;
      wr_en   = 1'b0;
      rd_en    = 1'b0;
      rstn    = 1'b0;
      #80;
      rstn    = 1'b1;
      #16;
      for (int i=1 ; i < 2**AWIDTH +2 ; i = i + 1)
      begin
         data_in = i;
         @(posedge clk)wr_en   = 1'b1;
         #8;
         wr_en   = 1'b0;
         #8;
      end
      #16;
      for (int i=0 ; i < 2**AWIDTH ; i = i + 1)
      begin
         rd_en   = 1'b1;
         #8;
         rd_en   = 1'b0;
         #8;
      end
   end

endmodule
