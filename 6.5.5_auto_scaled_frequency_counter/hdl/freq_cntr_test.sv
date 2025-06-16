module freq_cntr_test 
(
   input  logic 	clk,
   input  logic 	rst_n,

   input  logic         start,
   //input  logic [1:0]   sig_sel,
   
   output logic [7:0]   sseg,
   output logic [7:0]   an
);

   localparam TOGGLE_5MS  = 5000000;
   localparam TOGGLE_1MS  = 1000000;
   localparam TOGGLE_50MS = 50000000;
   localparam TOGGLE_50NS = 50000;

   logic [23:0] sig_cntr_10ms; 
   logic [23:0] sig_cntr_2ms;
   logic [23:0] sig_cntr_100ms;
   logic [23:0] sig_cntr_100ns;

   logic        sig_10ms;
   logic        sig_2ms;
   logic        sig_100ms;
   logic        sign_100ns;


   auto_scaled_freq_cntr u_dut
   (
      .clk		(clk),
      .rst_n            (rst_n),
      .start            (!start),
      .sig              (sig_10ms),
      .sseg             (sseg),
      .an               (an)
   );


   always_ff @(posedge clk)
   begin
      if (!rst_n)
      begin
         sig_cntr_10ms <= 'b0;
         sig_10ms      <= 'b0;
      end
      else if (sig_cntr_10ms == TOGGLE_5MS)
      begin
         sig_cntr_10ms <= 'b0;
         sig_10ms      <= 1'b1;
      end
      else
      begin
         sig_10ms      <= 1'b0;
         sig_cntr_10ms <= sig_cntr_10ms + 1;
      end
   end
/*
   always_ff @(posedge clk)
   begin
      if (!rst_n)
      begin
         sig_cntr <= 'b0;
         sig_10ms <= 'b0;
      end
      else if (sig_cntr == TOGGLE_5MS)
      begin
         sig_cntr <= 'b0;
         sig_10ms <= ~sig_10ms;
      end
      else
         sig_cntr <= sig_cntr + 1;  
   end
   always_ff @(posedge clk)
   begin
      if (!rst_n)
      begin
         sig_cntr <= 'b0;
         sig_10ms <= 'b0;
      end
      else if (sig_cntr == TOGGLE_5MS)
      begin
         sig_cntr <= 'b0;
         sig_10ms <= ~sig_10ms;
      end
      else
         sig_cntr <= sig_cntr + 1;  
   end
   always_ff @(posedge clk)
   begin
      if (!rst_n)
      begin
         sig_cntr <= 'b0;
         sig_10ms <= 'b0;
      end
      else if (sig_cntr == TOGGLE_5MS)
      begin
         sig_cntr <= 'b0;
         sig_10ms <= ~sig_10ms;
      end
      else
         sig_cntr <= sig_cntr + 1;  
   end
*/
endmodule
