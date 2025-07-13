module babbage_engine_tb ();

   logic           clk;
   logic           rst_n;
   
   logic [5:0]     n;
   logic           start;
   logic           done;
   logic [31:0]    f;
   
   babbage_engine_v2 dut
   (
      .clk           (clk),
      .rst_n         (rst_n),
      .n             (n),
      .start         (start),
      .done          (done),
      .f             (f)
   );
   
   initial 
   begin
      clk <= 1'b0;
      forever #5 clk <= ~clk;
   end
   
   initial
   begin
      n     = 'd5;
      start = 1'b0;
      rst_n = 1'b0;
      #100;
      @(negedge clk)
      rst_n = 1'b1;
      start = 1'b1;
      #20;
      start = 1'b0;
      @(posedge clk)
      #100;
      n     = 'd3;
      start = 1'b1;
      #10;
      start = 1'b0;
      #100;    
   end
endmodule
