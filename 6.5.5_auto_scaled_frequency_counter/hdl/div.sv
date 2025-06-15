module div#
(
   parameter W = 8
)
(
   input  logic 		clk,
   input  logic 		rst_n,

   input  logic 		        start,
   input  logic [W-1:0] 	    dvsr,
   input  logic [W-1:0]		    dvnd,
   
   output logic                 ready,
   output logic                 done, 
   output logic [W-1:0]         quo,
   output logic [W-1:0]         rmd
);

   enum logic [1:0] { IDLE    = 2'b00, 
                      OP      = 2'b01,
                      LAST    = 2'b10,
                      DONE    = 2'b11
		    } state_reg, state_next;

   localparam CBIT = $clog2(W+1);

   logic [W-1:0]    rh_reg, rh_next, rl_reg, rl_next, rh_tmp;
   logic [W-1:0]    d_reg, d_next;
   logic [CBIT-1:0] n_reg, n_next;
   logic            qbit;

   always_ff @(posedge clk)
   begin
      if (!rst_n)
      begin
         state_reg <= IDLE;
         rh_reg    <= 'b0;
         rl_reg    <= 'b0;
         d_reg     <= 'b0;
         n_reg     <= 'b0;
      end
      else
      begin
         state_reg <= state_next;
         rh_reg    <= rh_next;
         rl_reg    <= rl_next;
         d_reg     <= d_next;
         n_reg     <= n_next;
      end
   end

   always_comb
   begin
      state_next = state_reg;
      ready      = 1'b0;
      done       = 1'b0;
      rh_next    = rh_next;
      rl_next    = rl_next;
      d_next     = d_reg;
      n_next     = n_reg;
      case(state_reg)
         IDLE: 
         begin
            ready = 1'b1;
            if (start)
            begin
               rh_next    = 'b0;
               rl_next    = dvnd;
               d_next     = dvsr;
               n_next     = W + 1;
               state_next = OP;
            end
         end
         OP:
         begin
            rl_next = {rl_reg[W-2:0], qbit};
            rh_next = {rh_tmp[W-2:0], rl_reg[W-1]};
            n_next  = n_reg - 1;
            if (n_next == 1)
               state_next = LAST;
         end
         LAST:
         begin
            rl_next = {rl_reg[W-2:0], qbit};
            rh_next = rh_tmp;
            state_next = DONE;
         end
         DONE:
         begin
            done       = 1'b1;
            state_next = IDLE;
         end
      endcase
   end

   always_comb
   begin
      if (rh_reg >= d_reg)
      begin
         rh_tmp = rh_reg - d_reg;
         qbit  = 1'b1;
      end
      else
      begin
         rh_tmp = rh_reg;
         qbit   = 1'b0;
      end
   end

   assign quo = rl_reg;
   assign rmd = rh_reg;

endmodule    
