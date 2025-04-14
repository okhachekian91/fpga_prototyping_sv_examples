module bin2bcd
(
    input  logic            clk,
    input  logic            rst_n,

    input  logic            start,
    input  logic [12:0]     bin,
    output logic            ready,
    output logic            done_tick,
    output logic [3:0]      bcd3,
    output logic [3:0]      bcd2,
    output logic [3:0]      bcd1,
    output logic [3:0]      bcd0
);


enum logic [1:0] {  IDLE = 2'b00,
                    OP   = 2'b01,
                    DONE = 2'b10
} op_state, op_next; 

logic [12:0] p2s_reg, p2s_next; 
logic [3:0]  n_reg, n_next; 
logic [3:0]  bcd3_reg, bcd2_reg, bcd1_reg, bcd0_reg; 
logic [3:0]  bcd3_next, bcd2_next, bcd1_next, bcd0_next; 
logic [3:0]  bcd3_temp, bcd2_temp, bcd1_temp, bcd0_temp; 

always_ff @(posedge clk)
begin
    if (!rst_n)
    begin
        op_state        <= IDLE; 
        p2s_reg         <= 'b0;
        n_reg           <= 'b0;
        bcd3_reg        <= 'b0;
        bcd2_reg        <= 'b0;
        bcd1_reg        <= 'b0;
        bcd0_reg        <= 'b0;
    end
    else
    begin
        op_state        <= op_next;
        p2s_reg         <= p2s_next;
        n_reg           <= n_next;
        bcd3_reg        <= bcd3_next;
        bcd2_reg        <= bcd2_next;
        bcd1_reg        <= bcd1_next;
        bcd0_reg        <= bcd0_next;
    end
end

always_comb
begin
    op_next     = IDLE;
    ready       = 1'b0;
    done_tick   = 1'b0;
    p2s_next    = 'b0;
    bcd0_next   = bcd0_reg;
    bcd1_next   = bcd1_reg;
    bcd2_next   = bcd2_reg;
    bcd3_next   = bcd3_reg;
    n_next      = n_reg;
    case(op_state)
        IDLE:
        begin
            ready = 1'b1;

            if (start)
            begin
                op_next     = OP;
                bcd3_next   = 'b0;
                bcd2_next   = 'b0;
                bcd1_next   = 'b0;
                bcd0_next   = 'b0;
                n_next      = 4'b1101;
                p2s_next    = bin;
            end
        end
        OP:
        begin
            p2s_next    = ps2_reg << 1; 

            bcd0_next   = {bcd0_temp[2:0], p2s_reg[12]};
            bcd1_next   = {bcd1_temp[2:0], bcd0_temp[3]};
            bcd2_next   = {bcd2_temp[2:0], bcd1_temp[3]};
            bcd3_next   = {bcd3_temp[2:0], bcd2_temp[3]};
            n_next      = n_reg - 1; 
            if (n_next == 0)
                op_next     = DONE; 
        end
        DONE:
        begin
            done_tick   = 1'b1;
            op_next     = IDLE;
        end
        default: op_next = IDLE; 
    endcase
end

assign bcd0_temp = (bcd0_reg > 4) ? bcd0_reg + 3 : bcd0_reg;
assign bcd1_temp = (bcd1_reg > 4) ? bcd1_reg + 3 : bcd1_reg; 
assign bcd2_temp = (bcd2_reg > 4) ? bcd2_reg + 3 : bcd2_reg;
assign bcd3_temp = (bcd3_reg > 4) ? bcd3_reg + 3 : bcd3_reg;

assign bcd0 = bcd0_reg;
assign bcd1 = bcd1_reg;
assign bcd2 = bcd2_reg;
assign bcd3 = bcd3_reg;

endmodule