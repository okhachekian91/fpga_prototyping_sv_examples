module fibonacci_top
(
    input  logic            clk,
    input  logic            rst_n,

    input  logic            start,
    input  logic [7:0]      i_bcd,

    output logic [7:0]      sseg,
    output logic [7:0]      an,


);

    // start button debouncer
    early_detection_debounce u_debounce
    (
        .clk                (clk),
        .rst_n              (rst_n),
        .sw                 (start),
        .db                 (start_bcd)
    );

    bcd2bin u_bcd2bin
    (
    );
    
    // fibonacci generator
    fibonacci u_fibonacci
    (
        .clk                (clk),
        .rst_n              (rst_n),
        .ready              (ready),
        .start              (start_fib),
        .done_tick          (done_fib),
        .i                  (i),
        .fibo_num           (fibo_num),
        .ovf                (ovf)
    );



endmodule