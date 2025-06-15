module freq_cntr_tb ();


   logic		clk;
   logic 		rst_n;
   
   logic		start;
   logic 		sig, sig_10hz; 
   logic [3:0] 		bcd0;
   logic [3:0] 		bcd1;
   logic [3:0] 		bcd2;
   logic [3:0] 		bcd3;

   auto_scaled_freq_cntr u_freq_cntr
   (
      .clk                 (clk),
      .rst_n               (rst_n),
      .start               (start),
      .sig                 (sig_10hz),
      .bcd3                (bcd3),
      .bcd2                (bcd2),
      .bcd1                (bcd1),
      .bcd0                (bcd0)
   );


   initial
   begin
      clk = 1'b0;
      forever #5 clk = ~clk;
   end

   initial
   begin
      sig_10hz = 1'b0;
      forever #5000000 sig_10hz = ~sig_10hz;
   end
   initial
   begin
      rst_n = 1'b0;
      start = 1'b0;
      sig   = 1'b0; 
      #100; @(negedge clk) rst_n = 1'b1;
      #20;  @(posedge clk) start = 1'b1; 
      #10;  @(posedge clk) start = 1'b0;
      #1000000000;  
   end 

endmodule