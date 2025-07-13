module babbage_engine_v2
(
   input  logic		clk,
   input  logic         rst_n,
   
   input  logic [5:0]   n,
   input  logic         start,
   output logic         done,

   output logic [31:0]  f
);

   logic [5:0]  n_next, n_reg;
   logic [31:0] f_next, f_reg, f_temp, g_next, g_reg, g_temp, h_next,h_reg, h_temp;
   
   enum logic [1:0] { IDLE = 2'b00,
                      OP   = 2'b01,
                      DONE = 2'b10
                    } state_next, state_reg;
                    
   always_comb
   begin
      state_next = state_reg;
      f_next     = f_reg;
      g_next     = g_reg;
      h_next     = h_reg;
      n_next     = n_reg;
      done       = 1'b0;
      case(state_reg)
         IDLE:
         begin
            if (start)
            begin
               n_next     = 'd0;
               f_next     = 'd0;
               g_next     = 'd0;
               h_next     = 'd0;
               state_next = OP;
            end
         end
         OP: 
         begin
            f_next = f_temp;
            g_next = g_temp;
            h_next = h_temp;
            n_next = n_reg + 1; 
            if (n_reg < n)
               state_next = OP;
            else
               state_next = DONE;
         end
         DONE:
         begin
            done       = 1'b1;
            state_next = IDLE; 
         end
         default:
         begin
            state_next = IDLE;
            f_next     = 'b0;
            g_next     = 'b0;
            h_next     = 'b0;
            n_next     = 'b0;
            done       = 1'b0;
         end
      endcase
   end

   always_comb
   begin
      if (n_reg == 'd0)
         f_temp = 'd1;
      else if (n_reg > 'd0)
         f_temp = f_reg + g_temp;
      else
         f_temp = 'd0;
   end

   always_comb
   begin
      if (n_reg == 'd1)
         g_temp = 'd5;
      else if (n_reg > 'd1)
         g_temp = g_reg + h_temp;
      else
         g_temp = 'd0; 
   end

   always_comb
   begin
      if (n_reg == 'd2)
         h_temp = 'd10;
      else if (n_reg > 'd2)
         h_temp = h_reg + 'd6;
      else
         h_temp = 'd0;
   end

   always_ff @(posedge clk)
   begin
      if (!rst_n)
      begin
         f_reg     <= 'b0;
         g_reg     <= 'b0;
         h_reg     <= 'b0;
         n_reg     <= 'b0;
         state_reg <= IDLE;
      end
      else
      begin
         f_reg     <= f_next;
         g_reg     <= g_next;
         h_reg     <= h_next; 
         n_reg     <= n_next;
         state_reg <= state_next;
      end
   end

   assign f = f_reg;
   
endmodule
