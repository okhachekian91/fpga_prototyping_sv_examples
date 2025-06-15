module period_counter
(
   input  logic 	clk,
   input  logic 	rst_n,

   input  logic      	start,
   input  logic 	sig,

   output logic 	ready,
   output logic 	done,

   output logic [19:0]  period
);

   localparam CLK_US_COUNT = 100;

   enum logic [1:0] { IDLE  = 2'b00,
                      WAIT  = 2'b01,
                      COUNT = 2'b10,
                      DONE  = 2'b11
                    } state_reg, state_next;

   logic                       	    edge_tick; 
   logic 			                sig_dly; 
   logic [$clog2(CLK_US_COUNT)-1:0] t_next,t_reg;
   logic [19:0]                     p_next,p_reg;

   always_ff @(posedge clk)
   begin
      if (!rst_n)
         sig_dly <= 1'b0;
      else
         sig_dly <= sig;
    end

    assign edge_tick = sig && (!sig_dly); 
    
    always_comb
    begin
       state_next = state_reg;
       ready      = 1'b0; 
       done  = 1'b0;
       t_next     = t_reg;
       p_next     = p_reg;
       case(state_reg)
          IDLE:
          begin
             ready = 1'b1; 
             if (start)
             begin
                p_next     = 'b0;
                t_next     = 'b0;
                state_next = WAIT;
             end
          end
          WAIT:
          begin
             if (edge_tick)
                state_next = COUNT;
          end
          COUNT:
          begin
             t_next = t_reg + 1; 
             if (edge_tick)
                state_next = DONE;
             else if (t_reg == CLK_US_COUNT-1)
             begin
                t_next = 'b0;
                p_next = p_reg + 1;
             end 
          end
          DONE:
          begin
             done       = 1'b1;
             state_next = IDLE;
          end
       endcase
    end

    always_ff @(posedge clk)
    begin
       if (!rst_n)
       begin
          state_reg <= IDLE;
          t_reg     <= 'b0;
          p_reg     <= 'b0;
       end
       else
       begin
          state_reg <= state_next;
          t_reg     <= t_next;
          p_reg     <= p_next;
       end
    end

    assign period = p_reg + 1;

endmodule
