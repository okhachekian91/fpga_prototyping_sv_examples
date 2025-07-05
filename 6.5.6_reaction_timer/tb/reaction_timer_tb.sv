module reaction_timer_tb();

   logic 	clk;
   logic 	rst_n;
   
   logic 	start, stop, clear;
   logic 	stim_led;

   reaction_timer dut
   (
      .clk              (clk),
      .rst_n            (rst_n),
      .start            (start),
      .stop             (stop),
      .clear            (clear),
      .stim_led         (stim_led),
      .sseg             (),
      .an               ()
   );

   initial
   begin
      clk = 1'b0;
      forever #5 clk = ~clk;
   end

   initial
   begin
      rst_n = 1'b0;
      start = 1'b0;
      stop  = 1'b0;
      clear = 1'b0;
      #100;
      rst_n = 1'b1;
      #40;
      @(posedge clk) start = 1'b1;
      #10 @(negedge clk) start = 1'b0;
      #400000; stop = 1'b1;
      #10; @(negedge clk) stop = 1'b0;
      #400;
   end
endmodule
