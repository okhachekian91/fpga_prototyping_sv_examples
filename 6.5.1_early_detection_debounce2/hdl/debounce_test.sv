module debounce_test
(
    input  logic            clk,
    input  logic            rst_n,

    input  logic            btn,
    output logic [7:0]      sseg,
    output logic [7:0]      an
    
);

    logic           db;
    logic           btn_dly, btn_tick, btn_tick_dual;
    logic           db_dly, db_tick, db_tick_dual;

    logic [7:0]     db_cnt, btn_cnt, db_cnt_dual, btn_cnt_dual;

    early_detection_debounce u_early_detection_debounce
    (
        .clk            (clk),
        .rst_n          (rst_n),

        .sw             (btn),
        .db             (db)
    );

    always_ff @(posedge clk)
    begin
        btn_dly <= btn;
        db_dly  <= db;      
    end

    assign btn_tick = btn && !btn_dly;
    assign db_tick  = db && !db_dly;

    always_ff @(posedge clk)
    begin
        if (!rst_n)
            db_cnt <= 'b0;
        else if (db_tick)
            db_cnt <= db_cnt + 1; 
    end

    always_ff @(posedge clk)
    begin
        if (!rst_n)
            btn_cnt <= 'b0;
        else if (btn_tick)
            btn_cnt <= btn_cnt + 1; 
    end

    hex_sseg_disp u_hex_sseg_disp
    (
        .clk            (clk),
        .rst_n          (rst_n),

        .val1           (db_cnt),
        .val2           (btn_cnt),
        .val3           (db_cnt_dual),
        .val4           (btn_cnt_dual),

        .sseg           (sseg),
        .an             (an)
    );

    dual_edge_detect u_dual_edge_detect_1
    (
        .clk            (clk),
        .rst_n          (rst_n),

        .level          (btn),
        .edge_tick      (btn_tick_dual)
    );

    dual_edge_detect u_dual_edge_detect_2
    (
        .clk            (clk),
        .rst_n          (rst_n),
        
        .level          (db),
        .edge_tick      (db_tick_dual)
    );

    always_ff @(posedge clk)
    begin
        if (!rst_n)
            db_cnt_dual <= 'b0;
        else if (db_tick_dual)
            db_cnt_dual <= db_cnt_dual + 1; 
    end

    always_ff @(posedge clk)
    begin
        if (!rst_n)
            btn_cnt_dual <= 'b0;
        else if (btn_tick_dual)
            btn_cnt_dual <= btn_cnt_dual + 1; 
    end
endmodule