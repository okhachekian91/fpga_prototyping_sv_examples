module dual_edge_detect
(
    input  logic            clk,
    input  logic            rst_n,

    input  logic            level,
    output logic            edge_tick
);

//    `ifdef MOORE
//    enum logic [1:0] { DETECT_WAIT   = 2'b00,
//                       DETECT_HIGH   = 2'b01,
//                       DETECT_WAIT_0 = 2'b10,
//                       DETECT_LOW    = 2'b11
//    } detect_state, detect_next;

//    always_comb
//    begin
//        detect_next = detect_state;
//        case(detect_state)
//            DETECT_WAIT:
//            begin
//                if (level)
//                    detect_next = DETECT_HIGH;
//            end
//            DETECT_HIGH:
//            begin
//                detect_next = DETECT_WAIT_0;
//            end
//            DETECT_WAIT_0:
//            begin
//                if (level == 1'b0)
//                    detect_next = DETECT_LOW;
//            end
//            DETECT_LOW:
//            begin
//                detect_next = DETECT_WAIT;
//            end
//        endcase
//    end

//    always_ff @(posedge clk)
//    begin
//        if (!rst_n)
//            detect_state <= DETECT_WAIT;
//        else
//            detect_state <= detect_next; 
//    end

//    always_comb
//    begin
//        if (detect_state == DETECT_HIGH)
//            edge_tick = 1'b1;
//        else if (detect_state == DETECT_LOW)
//            edge_tick = 1'b1;
//        else
//            edge_tick = 1'b0;
//    end

//    `elsif MEALY
    enum logic {DETECT_LOW  = 1'b0,
                DETECT_HIGH = 1'b1   
               } detect_state, detect_next; 

    always_comb
    begin
        detect_next = detect_state;
        edge_tick   = 1'b0;
        case(detect_state)
            DETECT_LOW: 
            begin
                if (level)
                begin
                    detect_next = DETECT_HIGH;
                    edge_tick   = 1'b1;
                end
            end
            DETECT_HIGH:
            begin
                if (!level)
                begin
                    detect_next = DETECT_LOW;
                    edge_tick   = 1'b1;
                end
            end
        endcase
    end

    always_ff @(posedge clk)
    begin
        if (!rst_n)
            detect_state <= DETECT_LOW;
        else
            detect_state <= detect_next; 
    end
    
//    `endif
endmodule