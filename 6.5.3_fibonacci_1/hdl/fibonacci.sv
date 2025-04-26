module fibonacci
(
    input  logic            clk,
    input  logic            rst_n,

    output logic            ready,
    input  logic            start,
    output logic            done_tick,

    input  logic [4:0]      i,
    output logic [19:0]     fibo_num,
    output logic            ovf
);

    logic [4:0] n_next, n_reg;
    logic [19:0] t0_reg, t0_next, t1_reg, t1_next; 

    enum logic [1:0] {  IDLE     = 2'b00,
                        OP       = 2'b01,
                        DONE     = 2'b10
    } op_state, op_next; 

    always_comb
    begin
        op_next   = op_state;
        t0_next   = t0_reg;
        t1_next   = t1_reg;
        n_next    = n_reg; 
        done_tick = 1'b0; 
        ready     = 1'b0;
        case(op_state)
            IDLE:
            begin
                t0_next   = 'b0;
                t1_next   = 'b0;
                done_tick = 1'b0; 
                n_next    = 'b0;
                ready     = 1'b1;
                if (start)
                begin
                    t0_next = 'd0; 
                    t1_next = 'd1;
                    n_next  = i; 
                    op_next = OP; 
                end
            end
            OP:
            begin
                ready = 1'b0;
                if (n_reg == 'b0)
                begin
                    t1_next = 'b0;
                    op_next = DONE;
                end
                else if (n_reg == 1'b1)
                    op_next = DONE;
                else
                begin
                    t1_next = t0_reg + t1_reg;
                    t0_next = t1_reg;
                    n_next  = n_reg - 1;
                    op_next = OP;
                end     
            end
            DONE:
            begin
                done_tick = 1'b1;
                op_next   = IDLE;
            end
            default: op_next = IDLE;
        endcase
    end

    always_ff @(posedge clk)
    begin
        if (!rst_n)
        begin
            op_state <= IDLE;
            n_reg    <= 'b0;
            t1_reg   <= 'b0;
            t0_reg   <= 'b0;
        end
        else
        begin
            op_state <= op_next;
            n_reg    <= n_next;
            t1_reg   <= t1_next;
            t0_reg   <= t0_next;
        end
    end

    assign fibo_num = t1_reg;
    assign ovf = (fibo_num > 'd9999) ? 1'b1 : 1'b0; 
    
endmodule