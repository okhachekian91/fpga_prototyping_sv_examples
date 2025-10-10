module fifo_asym_tb();

   localparam AWIDTH = 8;
   localparam DWIDTH = 8;

   logic              clk;
   logic              rstn;

   logic [2*(DWIDTH)-1:0] data_in;
   logic              wr_en;
   logic [DWIDTH-1:0] data_out;
   logic              rd_en;
   logic              fifo_full;
   logic              fifo_empty;
   
   logic [DWIDTH-1:0] data_buf [0:2**(AWIDTH+1)];
   logic [DWIDTH-1:0] data_col [0:2**(AWIDTH+1)];
   
   logic [2*AWIDTH-1:0] err_cnt;
   initial
   begin
      clk = 1'b0;
      forever #4 clk = ~clk;
   end


   fifo_asym # (
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
      err_cnt = 'b0;
      #80;
      rstn    = 1'b1;
      #16;
      for (int i=0 ; i < 2**AWIDTH ; i = i + 1)
      begin
         data_in = {~(i[7:0]), i[7:0]};
         data_buf[2*i] = data_in[7:0];
         data_buf[2*i+1] = data_in[15:8];
         @(posedge clk) wr_en   = 1'b1;
         #8;
         @(posedge clk) wr_en   = 1'b0;
         #8;
      end
      #16;
      for (int i=0 ; i < 2**(AWIDTH+1) ; i = i + 1)
      begin
         $display("index %d : expected data %h - actual data %h",i,data_buf[i], data_out);
         if (data_out != data_buf[i])
         begin
            $display("error number %d", err_cnt);
            err_cnt = err_cnt + 1;
         end
         @(posedge clk) rd_en   = 1'b1;
         #8;
         @(posedge clk) rd_en   = 1'b0;
         #8;
      end
      #80;
      if (err_cnt != 'b0)
         $display("erroneous data");
      else
         $display("No errors - Test Passed");
   end

endmodule
