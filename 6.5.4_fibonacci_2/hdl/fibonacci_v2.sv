module fibonacci_v2
(
    input  logic            clk,
    input  logic            rst_n,

    input  logic            start_btn,
    input  logic [7:0]      sw,

    output logic [7:0]      sseg,
    output logic [7:0]      an
);


    logic           start_db;

    logic [3:0]     bcd0_reg, bcd0_next, bcd0_temp;
    logic [3:0]     bcd1_reg, bcd1_next, bcd1_temp;
    logic [3:0]     bcd2_reg, bcd2_next, bcd2_temp;
    logic [3:0]     bcd3_reg, bcd3_next, bcd3_temp;

    logic [4:0]     idx_next, idx_reg; 
    logic [6:0]     bin_reg, bin_next; 

    logic [19:0]    t0_reg, t0_next, t1_reg, t1_next;

    logic [13:0]    p2s_reg, p2s_next; 

    logic [3:0]     mask; 
    enum logic [1:0] {  IDLE    = 2'b00,
                        BCD2BIN = 2'b01,
                        FIBO    = 2'b10,
                        BIN2BCD = 2'b11

                 }  op_state, op_next; 


    always_comb
    begin
        op_next     = op_state; 
        bcd0_next   = bcd0_reg;
        bcd0_temp   = bcd0_reg;
        bcd1_next   = bcd1_reg;
        bcd1_temp   = bcd1_reg;
        bcd2_next   = bcd2_reg;
        bcd2_temp   = bcd2_reg;
        bcd3_next   = bcd3_reg;
        bcd3_temp   = bcd3_reg;
        idx_next    = idx_reg;
        bin_next    = bin_reg;

        t0_next     = t0_reg;
        t1_next     = t1_reg;

        p2s_next    = p2s_reg;
        case(op_state)
            IDLE:
            begin   
                if (start_db)
                begin
                    bcd0_next = sw[3:0];
                    bcd1_next = sw[7:4];
                    idx_next  = 'd7;
                    op_next   = BCD2BIN;
                end
            end
            BCD2BIN:
            begin
                bcd1_temp = {1'b0, bcd1_reg[3:1]};
                bcd0_temp = {bcd1_reg[0], bcd0_reg[3:1]};
                bin_next  = {bcd0_reg[0], bin_reg[6:1]};
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
                begin
                    t0_next = 'd0;
                    t1_next = 'd1;
                    if (bin_next > 'd31)
                        idx_next = 'd31;
                    else
                        idx_next = bin_next[4:0];
                    op_next = FIBO;
                end
            end
            FIBO:
            begin
                if (idx_reg <= 'd1)
                begin
                    if (idx_reg == 0)
                        t1_next  = 'b0;

                    if (t1_next >= 'd9999)
                        p2s_next = 'd9999;
                    else
                        p2s_next = t1_next[13:0];
                    idx_next = 4'b1110;
                    bcd0_next = 'b0;
                    bcd0_temp = 'b0;
                    bcd1_next = 'b0;
                    bcd1_temp = 'b0;
                    bcd2_next = 'b0;
                    bcd2_temp = 'b0;
                    bcd3_next = 'b0;
                    bcd3_temp = 'b0;
                    op_next = BIN2BCD;
                end
                else
                begin
                    t1_next = t0_reg + t1_reg;
                    t0_next = t1_reg;
                    idx_next  = idx_reg - 1;
                    op_next = FIBO;
                end
            end
            BIN2BCD:
            begin
                if (bcd0_temp > 'd4)
                   bcd0_temp = bcd0_reg + 'd3;
                if (bcd1_temp > 'd4)
                   bcd1_temp = bcd1_reg + 'd3;
                if (bcd2_temp > 'd4)
                   bcd2_temp = bcd2_reg + 'd3;
                if (bcd3_temp > 'd4)
                   bcd3_temp = bcd3_reg + 'd3;                     
                p2s_next    = p2s_reg << 1; 
                bcd0_next   = {bcd0_temp[2:0], p2s_reg[13]};
                bcd1_next   = {bcd1_temp[2:0], bcd0_temp[3]};
                bcd2_next   = {bcd2_temp[2:0], bcd1_temp[3]};
                bcd3_next   = {bcd3_temp[2:0], bcd2_temp[3]};
                idx_next      = idx_reg - 1; 
                if (idx_next == 0)
                    op_next     = IDLE; 
            end
        endcase
    end

    always_ff @(posedge clk)
    begin
        if (!rst_n)
        begin
            op_state <= IDLE;
            bcd0_reg <= 'b0;
            bcd1_reg <= 'b0;
            bcd2_reg <= 'b0;
            bcd3_reg <= 'b0;
            idx_reg  <= 'b0;
            bin_reg  <= 'b0;
            t0_reg   <= 'b0;
            t1_reg   <= 'b0;
            p2s_reg  <= 'b0;
        end
        else
        begin
            op_state <= op_next;
            bcd0_reg <= bcd0_next;
            bcd1_reg <= bcd1_next;
            bcd2_reg <= bcd2_next;
            bcd3_reg <= bcd3_next;
            idx_reg  <= idx_next;
            bin_reg  <= bin_next;
            t0_reg   <= t0_next;
            t1_reg   <= t1_next;
            p2s_reg  <= p2s_next;
        end
    end




    // start button debouncer   
    early_detection_debounce u_debounce
    (
        .clk                (clk),
        .rst_n              (rst_n),
        .sw                 (start_btn),
        .db                 (start_db)
    );

    hex_sseg_disp u_hex_sseg_disp
    (
        .clk                (clk),
        .rst_n              (rst_n),
        .val1               ({bcd1_reg, bcd0_reg}),
        .val2               ({bcd3_reg, bcd2_reg}),
        .val3               ('b0),
        .val4               ('b0),

        .sseg               (sseg),
        .an                 (an)
    );

endmodule