module auto_scaled_freq_cntr
(
   input  logic 	clk,
   input  logic 	rst_n,

   input  logic 	start,
   input  logic 	sig,
   
   output logic [7:0]   sseg,
   output logic [7:0]   an
);

   enum logic [1:0] { IDLE   = 2'b00,
                      COUNT  = 2'b01,
                      FRQ    = 2'b10,
                      B2B    = 2'b11
                    } state_reg, state_next;

   logic [19:0] prd;
   logic [19:0] dvsr, dvnd, quo;
   logic        prd_start, div_start, b2b_start;
   logic        prd_done, div_done, b2b_done;

   logic [3:0]  bcd [7:0];
   logic [2:0]  dp;

   period_counter u_prd_cnt
   (
      .clk             (clk),
      .rst_n           (rst_n),
      .start           (prd_start),
      .sig             (sig),
      .ready           (),
      .done            (prd_done),
      .period          (prd)
   ); 
          
   div
   # (
      .W               (20)
   ) u_div
   (
      .clk             (clk),
      .rst_n           (rst_n),
      .start           (div_start),
      .dvsr            (prd),
      .dvnd            (20'd1000000),
      .ready           (),
      .done            (div_done),
      .quo             (quo),
      .rmd             ()
   ); 

   bin2bcd_ext u_bin2bcd
   (
      .clk            (clk),
      .rst_n          (rst_n),
      .start          (b2b_start),
      .bin            (quo),
      .ready          (),
      .done           (b2b_done),
      .bcd            (bcd),
      .dp             (dp)
   );

   hex_sseg_disp u_hex_sseg_disp
   (
      .clk            (clk),
      .rst_n          (rst_n),
      .bcd0           (bcd[4]),
      .bcd1           (bcd[5]),
      .bcd2           (bcd[6]),
      .bcd3           (bcd[7]),
      .dp             (dp),
      .sseg           (sseg),
      .an             (an)
   ); 
   always_ff @(posedge clk)
   begin
      if (!rst_n)
         state_reg <= IDLE;
      else
         state_reg <= state_next;
   end

   always_comb
   begin
      state_next = state_reg;
      prd_start  = 1'b0;
      div_start  = 1'b0;
      b2b_start  = 1'b0;
      case(state_reg)
         IDLE:
         begin
            if (start)
            begin
               prd_start  = 1'b1;
               state_next = COUNT;
            end
         end
         COUNT:
         begin
            if (prd_done)
            begin
               div_start  = 1'b1;
               state_next = FRQ; 
            end
         end
         FRQ:
         begin
            if (div_done)
            begin
               b2b_start  = 1'b1; 
               state_next = B2B;
            end
         end
         B2B:
         begin
            if (b2b_done)
               state_next = IDLE; 
         end
      endcase
   end

   assign bcd3 = bcd[7];
   assign bcd2 = bcd[6];
   assign bcd1 = bcd[5];
   assign bcd0 = bcd[4];
   
endmodule
