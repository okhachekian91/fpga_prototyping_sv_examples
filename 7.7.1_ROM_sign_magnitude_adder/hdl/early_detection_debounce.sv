module early_detection_debounce
(
    input  logic                clk,
    input  logic                rst_n,

    input  logic                sw,
    output logic                db

);

    localparam TIMER_20MS_PERIOD = 2000000;

    logic [20:0] timer_20ms;
    logic        tick_20ms;

    enum logic [1:0] { DB_IDLE    = 2'b00,
                       DB_HIGH    = 2'b01,
                       DB_WAIT    = 2'b10,
                       DB_LOW     = 2'b11
                     } db_state, db_next; 

    always_ff @(posedge clk)
    begin
        if (!rst_n)
            timer_20ms <= 'b0;
        else if (timer_20ms >= TIMER_20MS_PERIOD)
            timer_20ms <= 'b0;
        else if ((db_state == DB_HIGH) || (db_state == DB_LOW))
            timer_20ms <= timer_20ms + 1; 
    end

    assign tick_20ms = (timer_20ms == TIMER_20MS_PERIOD);

    always_comb
    begin
        db_next = db_state; 
        case(db_state)
            DB_IDLE:
            begin
                if (sw)
                    db_next = DB_HIGH;
            end
            DB_HIGH:
            begin
                if (tick_20ms)
                begin
                    if (sw)
                        db_next = DB_WAIT;
                    else
                        db_next = DB_LOW; 
                end
            end
            DB_WAIT:
            begin
                if (!sw)
                    db_next = DB_LOW;
            end
            DB_LOW:
            begin
                if (tick_20ms)
                begin
                    if (sw)
                        db_next = DB_HIGH;
                    else
                        db_next = DB_IDLE;
                end
            end
        endcase
    end

    always_ff @(posedge clk)
    begin
        if (!rst_n)
            db_state <= DB_IDLE;
        else
            db_state <= db_next;
    end
    
    always_ff @(posedge clk)
    begin
        if (!rst_n)
            db <= 1'b0;
        else if ((db_state == DB_IDLE) && (db_next == DB_HIGH))
            db <= 1'b1;
        else
            db <= 1'b0;
    end
    
endmodule