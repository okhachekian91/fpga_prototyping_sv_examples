module babbage_top
(
    input  logic        clk,
    input  logic        rst_n,

    input  logic        start,
    input  logic [5:0]  n,

    output logic [7:0]  sseg,
    output logic [7:0]  an,
    output logic [13:0] result

);

    //logic [31:0]    result;
    logic           start_db;
    logic           babbage_done;
    
    logic [3:0]     bcd3, bcd2, bcd1, bcd0;
    `ifdef V2
    babbage_engine_v2 u_babbage
    (
        .clk        (clk),
        .rst_n      (rst_n),
        .n          (n),
        .start      (start_db),
        .done       (babbage_done),
        .f          (result)
    );
    `else
    babbage_engine u_babbage
    (
        .clk        (clk),
        .rst_n      (rst_n),
        .n          (n),
        .start      (start_db),
        .done       (babbage_done),
        .f          (result)
    );
    `endif
    
    early_detection_debounce u_debounce
    (
        .clk        (clk),
        .rst_n      (rst_n),
        .sw         (start),
        .db         (start_db)
    );
    
    bin2bcd u_bin2bcd
    (
        .clk        (clk),
        .rst_n      (rst_n),
        .start      (babbage_done),
        .bin        (result[13:0]),
        .ready      (ready),
        .done_tick  (),
        .bcd3       (bcd3),
        .bcd2       (bcd2),
        .bcd1       (bcd1),
        .bcd0       (bcd0)
    );
    
    hex_sseg_disp u_hex_sseg
    (
        .clk        (clk),
        .rst_n      (rst_n),
        .bcd0       (bcd0),
        .bcd1       (bcd1),
        .bcd2       (bcd2),
        .bcd3       (bcd3),
        .sseg       (sseg),
        .an         (an)
    );
endmodule