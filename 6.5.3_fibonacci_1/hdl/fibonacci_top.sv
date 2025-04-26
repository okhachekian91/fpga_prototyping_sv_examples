module fibonacci_top
(
    input  logic            clk,
    input  logic            rst_n,

    input  logic            start_btn,
    input  logic [7:0]      sw,

    output logic [7:0]      sseg,
    output logic [7:0]      an


);

    logic           start_db;

    logic [7:0]     bcd_i_next, bcd_i_reg;
    logic           start_bcd2bin;
    logic           done_bcd2bin; 

    logic [6:0]     bcd2bin; 
    logic [4:0]     bin_i_next, bin_i_reg;
    
    logic           start_fib;
    logic [19:0]    fibo_num, fibo_i_next, fibo_i_reg;
    logic           fibo_rdy;

    logic           bin2bcd_rdy; 
    logic           done_bin2bcd;
    logic           start_bin2bcd; 

    logic [3:0]     bcd0, bcd1, bcd2, bcd3; 

    enum logic [2:0] {  IDLE         = 3'b000,
                        BCD2BIN      = 3'b001, 
                        WAIT_BCD2BIN = 3'b010,
                        FIB_GEN      = 3'b011,
                        WAIT_FIB_GEN = 3'b100,
                        BIN2BCD      = 3'b101,
                        WAIT_BIN2BCD = 3'b110

    } op_state, op_next; 

    always_comb
    begin
        op_next         = op_state;
        bcd_i_next      = bcd_i_reg;
        start_bcd2bin   = 1'b0;
        bin_i_next      = bin_i_reg; 
        start_fib       = 1'b0;
        fibo_i_next     = fibo_i_reg;
        start_bin2bcd   = 1'b0; 
        case(op_state)
            IDLE:
            begin
                bcd_i_next  = 'b0;
                bin_i_next  = 'b0;
                fibo_i_next = 'b0;
                if (start_db)
                begin
                    bcd_i_next    = sw;
                    op_next       = BCD2BIN; 
                end
            end
            BCD2BIN:
            begin
                start_bcd2bin = 1'b1;
                op_next       = WAIT_BCD2BIN;
            end
            WAIT_BCD2BIN:
            begin
                if (done_bcd2bin)
                begin
                    if (bcd2bin > 'd31)
                        bin_i_next = 'd31; 
                    else
                        bin_i_next = bcd2bin[4:0];
                    
                    op_next = FIB_GEN; 
                end
            end
            FIB_GEN:
            begin
                if (fibo_rdy)
                begin
                   start_fib = 1'b1;
                   op_next   = WAIT_FIB_GEN;
                end 
            end
            WAIT_FIB_GEN:
            begin
                if (done_fib)
                begin
		    if (ovf)
		       fibo_i_next = 'd9999;
		    else
                       fibo_i_next = fibo_num; 
                op_next = BIN2BCD;
                end
            end
            BIN2BCD:
            begin
               if (bin2bcd_rdy)
               begin
                  start_bin2bcd = 1'b1;
                  op_next       = WAIT_BIN2BCD;
               end
            end
            WAIT_BIN2BCD:
            begin
               if (done_bin2bcd)
                  op_next = IDLE; 
            end
            default:
            begin
               bcd_i_next      = 'b0;
               start_bcd2bin   = 1'b0;
               bin_i_next      = 'b0; 
               start_fib       = 1'b0;
               fibo_i_next     = 'b0;
               start_bin2bcd   = 1'b0; 
            end
        endcase
    end

    always_ff @(posedge clk)
    begin
        if (!rst_n)
        begin
            op_state        <= IDLE;
            bcd_i_reg       <= 'b0;
            bin_i_reg       <= 'b0;
            fibo_i_reg      <= 'b0;
        end
        else
        begin
            op_state        <= op_next;
            bcd_i_reg       <= bcd_i_next;
            bin_i_reg       <= bin_i_next;
            fibo_i_reg      <= fibo_i_next;
        end
    end


    // start button debouncer
    early_detection_debounce u_debounce
    (
        .clk                (clk),
        .rst_n              (rst_n),
        .sw                 (!start_btn),
        .db                 (start_db)
    );

    // bcd to binary converter
    bcd2bin u_bcd2bin
    (
        .clk                (clk),
        .rst_n              (rst_n),
        .start              (start_bcd2bin),
        .done               (done_bcd2bin),
        .bcd_in             (bcd_i_reg),
        .bin_out            (bcd2bin)
    );
    
    // fibonacci generator
    fibonacci u_fibonacci
    (
        .clk                (clk),
        .rst_n              (rst_n),
        .ready              (fibo_rdy),
        .start              (start_fib),
        .done_tick          (done_fib),
        .i                  (bin_i_reg),
        .fibo_num           (fibo_num),
        .ovf                (ovf)
    );

    bin2bcd u_bin2bcd
    (
        .clk                (clk),
        .rst_n              (rst_n),

        .start              (start_bin2bcd),
        .bin                (fibo_i_reg[13:0]),
        .ready              (bin2bcd_rdy),
        .done_tick          (done_bin2bcd),
        .bcd3               (bcd3),
        .bcd2               (bcd2),
        .bcd1               (bcd1),
        .bcd0               (bcd0)
    );

    hex_sseg_disp u_hex_sseg_disp
    (
        .clk                (clk),
        .rst_n              (rst_n),
        .val1               (bcd0),
        .val2               (bcd1),
        .val3               (bcd2),
        .val4               (bcd3),

        .sseg               (sseg),
        .an                 (an)
    );


endmodule
