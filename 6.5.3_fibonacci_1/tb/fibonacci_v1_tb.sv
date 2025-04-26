module fibonacci_v1_tb();

   logic          clk;
   logic          rst_n; 

   logic          start_btn;
   logic [7:0]    sw; 

   fibonacci_top u_fibo_v1
   (
      .clk              (clk),
      .rst_n            (rst_n),
      .start_btn        (start_btn),
      .sw               (sw),
      .sseg             (),
      .an               ()
   );

   always
   begin
      clk <= 1'b1;
      #5;
      clk <= 1'b0;
      #5;
   end

   initial
   begin
      rst_n     = 1'b0;
      sw        = 'b0;
      start_btn = 1'b0;
      #100;
      rst_n     = 1'b1;
      #10;
      @(posedge clk) sw        = 8'h0a;
      @(posedge clk) start_btn = 1'b1;
      #100;
      @(posedge clk) start_btn = 1'b0;
      #1000;
      @(posedge clk) sw        = 8'h15;
      @(posedge clk) start_btn = 1'b1;
      #100;
      @(posedge clk) start_btn = 1'b0;
      #1000;
      @(posedge clk) sw        = 8'h20;
      @(posedge clk) start_btn = 1'b1;
      #100;
      @(posedge clk) start_btn = 1'b0;
      #1000;
      @(posedge clk) sw        =  8'h21;
      @(posedge clk) start_btn = 1'b1;
      #100;
      @(posedge clk) start_btn = 1'b0;
      #1000;
      @(posedge clk) sw        = 8'h25;
      @(posedge clk) start_btn = 1'b1;
      #100;
      @(posedge clk) start_btn = 1'b0;
      #1000;
   end


endmodule
