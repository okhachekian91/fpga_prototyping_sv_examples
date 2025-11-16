module stack_tb();

   localparam AWIDTH = 8;
   localparam DWIDTH = 8;

   logic              clk;
   logic              rstn;

   logic [DWIDTH-1:0] data_in;
   logic              push;
   logic [DWIDTH-1:0] data_out;
   logic              pop;
   logic              stack_full;
   logic              stack_empty;
   
   logic [DWIDTH-1:0] data_buf [0:2**(AWIDTH+1)];
   logic [DWIDTH-1:0] data_col [0:2**(AWIDTH+1)];
   
   logic [2*AWIDTH-1:0] err_cnt;
   initial
   begin
      clk = 1'b0;
      forever #4 clk = ~clk;
   end


   stack # (
      .AWIDTH         (AWIDTH),
      .DWIDTH         (DWIDTH)
   ) dut
   (
      .clk            (clk),
      .rstn           (rstn),
      .din            (data_in),
      .push           (push),
      .dout           (data_out),
      .pop            (pop),
      .full           (stack_full),
      .empty          (stack_empty)	
   );

   initial
   begin
      data_in = 'b0;
      push    = 1'b0;
      pop     = 1'b0;
      rstn    = 1'b0;
      err_cnt = 'b0;
      #80;
      rstn    = 1'b1;
      #16;
      for (int i=0 ; i < 2**AWIDTH ; i = i + 1)
      begin
         data_in = i;
         data_buf[i] = i;
         @(posedge clk) push  = 1'b1;
         #8;
         @(posedge clk) push  = 1'b0;
         #8;
      end
      #16;
      for (int i=0 ; i < 2**AWIDTH ; i = i + 1)
      begin
         $display("index %d : expected data %h - actual data %h",i,data_buf[255-i], data_out);
         if (data_out != data_buf[255-i])
         begin
            $display("error number %d", err_cnt);
            err_cnt = err_cnt + 1;
         end
         @(posedge clk) pop   = 1'b1;
         #8;
         @(posedge clk) pop   = 1'b0;
         #8;
      end
      #80;
      if (err_cnt != 'b0)
         $display("erroneous data");
      else
         $display("No errors - Test Passed");
   end

endmodule
