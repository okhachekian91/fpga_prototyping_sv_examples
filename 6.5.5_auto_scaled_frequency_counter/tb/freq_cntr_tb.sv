module freq_cntr_tb ();


   logic		clk;
   logic 		rst_n;
   
   logic		start;
   logic 		sig, sig_10hz; 
   logic [7:0]  sseg;
   logic [7:0]  an;

   auto_scaled_freq_cntr u_freq_cntr
   (
      .clk                 (clk),
      .rst_n               (rst_n),
      .start               (start),
      .sig                 (sig_10hz),
      .sseg                (sseg),
      .an                  (an)
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