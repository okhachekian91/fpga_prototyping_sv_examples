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
    
    logic [6:0]     bcd2bin; 
    logic [4:0]     bin_i_next, bin_i_reg;

    enum logic [2:0] {  IDLE = 3'b000


    } ctl_state, ctl_next; 

    always_comb
    begin
        ctl_next        = ctl_state;
        bcd_i_next      = bcd_i_reg;
        start_bcd2bin   = 1'b0;
        bin_i_next      = bin_i_reg; 
        start_fib       = 1'b0;
        case(ctl_state)
            IDLE:
            begin
                if (start_db)
                begin
                    bcd_i_next    = sw;
                    op_next       = BCD2BIN; 
                end
            end
            BCD2BIN:
            begin
                start_bcd2bin = 1'b1;
                op_next       = FIB_GEN;
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
                start_fib = 1'b1;
                op_next   = WAIT_FIB_GEN; 
            end
            WAIT_FIB_GEN:
            begin
                if (done_fib)
                begin
                end
            end
        endcase
    end

    always_ff @(posedge clk)
    begin
        if (!rst_n)
        begin
            ctl_state       <= IDLE;
        end
        else
        begin
            ctl_state       <= ctl_next;
        end
    end


    // start button debouncer
    early_detection_debounce u_debounce
    (
        .clk                (clk),
        .rst_n              (rst_n),
        .sw                 (start),
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
        .ready              (ready),
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
        .bin                (fibo_out)
    );

    hex_sseg_disp u_hex_sseg_disp
    (
        .clk                (clk),
        .rst_n              (rst_n),
        .val1               (),
        .val2               (),
        .val3               (),
        .val4               (),

        .sseg               (),
        .an                 ()
    );


endmodule