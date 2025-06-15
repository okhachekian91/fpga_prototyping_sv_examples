module bin2bcd_ext
(
    input  logic            clk,
    input  logic            rst_n,

    input  logic            start,
    input  logic [19:0]     bin,
    output logic            ready,
    output logic            done,
    output logic [3:0]      bcd [7:0]
);


enum logic [1:0] {  IDLE       = 2'b00,
                    OP         = 2'b01,
                    DONE       = 2'b10,
                    BCD_ADJUST = 2'b11
} op_state, op_next; 

logic [19:0] p2s_reg, p2s_next; 
logic [4:0]  n_reg, n_next; 
logic [3:0]  bcd_reg [7:0]; 
logic [3:0]  bcd_next [7:0];
logic [3:0]  bcd_temp [7:0]; 

logic [2:0]  dp_reg, dp_next;

always_ff @(posedge clk)
begin
    if (!rst_n)
    begin
        op_state        <= IDLE; 
        p2s_reg         <= 'b0;
        n_reg           <= 'b0;
        bcd_reg         <= '{default: 'b0};
        dp_reg          <= 'b0;
    end
    else
    begin
        op_state        <= op_next;
        p2s_reg         <= p2s_next;
        n_reg           <= n_next;
        dp_reg          <= dp_next;
        for (int i = 0; i < 8 ; i = i +1)
           bcd_reg[i] = bcd_next[i];
    end
end

always_comb
begin
    op_next     = op_state;
    ready       = 1'b0;
    done   = 1'b0;
    p2s_next    = 'b0;
    dp_next     = dp_reg;
    n_next      = n_reg;
    for (int i = 0 ; i < 8 ; i = i + 1)
       bcd_next[i] = bcd_reg[i];
    case(op_state)
        IDLE:
        begin
            ready = 1'b1;
            if (start)
            begin
                op_next     = OP;
                bcd_next    = '{default: 'b0};
                n_next      = 5'b10100;
                p2s_next    = bin;
                dp_next     = 'd0;
            end
        end
        OP:
        begin
            p2s_next    = p2s_reg << 1; 
            for (int i = 0; i < 8 ; i = i + 1)
            begin
               if (i == 0)
                  bcd_next[i] = {bcd_temp[i][2:0], p2s_reg[19]};
               else
                  bcd_next[i] = {bcd_temp[i][2:0], bcd_temp[i-1][3]};
            end
            n_next      = n_reg - 1; 
            if (n_next == 0)
                op_next     = DONE; 
        end
	    BCD_ADJUST:
        begin
           dp_next = dp_reg + 1;
           bcd_next = {bcd_reg[6:0], 4'b0};
           op_next = DONE;
        end
        DONE:
        begin
            if (bcd_reg[7] == 'b0)
               op_next = BCD_ADJUST;
            else
            begin
               done   = 1'b1;
               op_next     = IDLE;
            end
        end
        default: op_next = IDLE; 
    endcase
end

generate 
   for (genvar i = 0; i < 8 ; i = i + 1)
   begin
      assign bcd_temp[i] = (bcd_reg[i] > 4) ? bcd_reg[i] + 3 : bcd_reg[i];
      assign bcd[i] = bcd_reg[i];
   end
endgenerate

endmodule
