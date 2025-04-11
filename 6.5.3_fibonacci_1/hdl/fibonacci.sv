module fibonacci
(
    input  logic            clk,
    input  logic            rst_n,

    output logic            ready,
    input  logic            start,
    output logic            done,

    input  logic [4:0]      i,
    output logic [19:0]     f
);

    logic [4:0] n_next, n_reg;
    logic [19:0] t0_reg, t0_next, t1_reg, t1_next; 

    enum logic [1:0] {  IDLE     = 2'b00,
                        OP       = 2'b01,
                        DONE     = 2'b10
    } op_state, op_next; 

    always_comb
    begin
        op_next = op_state;
        t0_next = t0_reg;
        t1_next = t1_reg;
        n_next  = n_reg; 
        case(op_state)
            IDLE:
            begin
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
                if (n_reg == 'b0)
            end
        endcase
    end

endmodule