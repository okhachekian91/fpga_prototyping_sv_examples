module bcd2bin
(
    input  logic        clk,
    input  logic        rst_n,

    input  logic        start, 
    output logic        done,

    input  logic [7:0]  bcd_in,
    output logic [6:0]  bin_out
);

    enum logic [1:0] {  IDLE    = 2'b00,
                        LATCH   = 2'b01,
                        OP      = 2'b10,
                        DONE    = 2'b11
    } op_state, op_next; 


    logic [7:0] bcd0_reg, bcd0_next, bcd0_temp;
    logic [7:0] bcd1_reg, bcd1_next, bcd1_temp;
    
    logic [3:0] idx_next, idx_reg; 

    logic [6:0] bin_reg, bin_next; 

    always_comb
    begin
        op_next   = op_state;
        bcd0_next = bcd0_reg;
        bcd1_next = bcd1_reg;
        idx_next  = idx_reg; 
        done      = 1'b0; 
        case(op_state)
            IDLE:
            begin
                if (start)
                begin
                    bcd0_next = bcd_in[3:0];
                    bcd1_next = bcd_in[7:4];
                    idx_next  = 'd7; 
                    op_next   = LATCH;
                end
            end
            LATCH:
            begin
                op_next = OP;
            end
            OP:
            begin
                if (bcd1_temp > 'd7)
                    bcd1_next = bcd1_temp - 'd3;
                else
                    bcd1_next = bcd1_temp;

                if (bcd0_temp > 'd7)
                    bcd0_next = bcd0_temp - 'd3;
                else
                    bcd0_next = bcd0_temp;

                idx_next = idx_reg - 1; 
                if (idx_reg == 'd1)
                    op_next = DONE; 
            end
            DONE:
            begin
                done = 1'b1; 
                op_next = IDLE; 
            end
        endcase
    end

    always_ff @(posedge clk)
    begin
        if (!rst_n)
        begin
            bcd0_reg <= 'b0;
            bcd1_reg <= 'b0;
            bin_reg  <= 'b0; 
            idx_reg  <= 'b0;
            op_state <= IDLE;
        end
        else
        begin
            bcd0_reg <= bcd0_next;
            bcd1_reg <= bcd1_next;
            bin_reg  <= bin_next;
            idx_reg  <= idx_next;  
            op_state <= op_next; 
        end
    end

    assign bcd1_temp = (op_state == OP) ? {1'b0, bcd1_reg[3:1]} : bcd1_reg;
    assign bcd0_temp = (op_state == OP) ? {bcd1_reg[0], bcd0_reg[3:1]} : bcd0_reg;
    assign bin_next  = (op_state == OP) ? {bcd0_reg[0], bin_reg[6:1]} : bin_reg;

    assign bin_out   = bin_reg;
endmodule