module reaction_timer
(
    input  logic        clk,
    input  logic        rst_n,

    input  logic        start,
    input  logic        stop,
    input  logic        clear,

    output logic        stim_led,
    output logic [7:0]  sseg,
    output logic [7:0]  an
);
    localparam MS_COUNT  = 100000;
    //localparam MS_COUNT  = 10;
    localparam SEC_COUNT = 100000000;
    //localparam SEC_COUNT = 1000;
    
    logic [16:0]    timer;
    logic [13:0]    ms_count;
    logic [3:0]     lfsr;

    logic [26:0]    stim_timer;
    logic [4:0]     sec_count;

    logic           stim_next;
	
	logic 			start_db, stop_db, clr_db;
	
	logic [3:0] 	bcd0, bcd1, bcd2, bcd3;
	
	logic           start_b2b;
	
    always_ff @(posedge clk)
    begin
        if (!rst_n)
        begin
            timer    <= 'b0;
            ms_count <= 'b0;
        end
        else if (clr_db)
        begin
            timer    <= 'b0;
            ms_count <= 'b0;
        end
        else if (state_reg == WAIT)
        begin
            if (timer == MS_COUNT-1)
            begin
                timer <= 'b0;
                if (ms_count < 'd9999)
                    ms_count <= ms_count + 1; 
            end
            else
                timer <= timer + 1; 
        end
    end

    always_ff @(posedge clk)
    begin
        if (!rst_n)
            lfsr = 4'hF;
        else if (state_reg == IDLE)
            lfsr = {lfsr[2:0], lfsr[3] ^ lfsr[2]};
    end

    always_ff @(posedge clk)
    begin
        if (!rst_n)
        begin
            stim_timer <= 'b0;
            sec_count  <= 'b0;
        end
        else if (state_reg == IDLE)
        begin
           stim_timer <= 'b0;
           sec_count  <= 'b0;
        end
        else if (state_reg == START)
        begin
            if (stim_timer == SEC_COUNT-1)
            begin
                stim_timer <= 'b0;
                sec_count  <= sec_count + 1;
            end
            else
                stim_timer <= stim_timer + 1;
        end
        else
        begin
            stim_timer <= 'b0;
            sec_count  <= 'b0;
        end
    end

    enum logic [2:0] { IDLE  = 3'b000,
                       START = 3'b001,
                       STIM  = 3'b010,
                       WAIT  = 3'b011,
                       DONE  = 3'b100
   } state_reg, state_next;
   
   always_comb
   begin
        state_next = state_reg;
        stim_next  = stim_led;
        start_b2b  = 1'b0;
        case(state_reg)
            IDLE:
            begin

                if (start_db)
                    state_next = START;
            end
            START:
            begin
                if ((sec_count == lfsr) && (sec_count >= 'd2))
                    state_next = STIM;
            end
            STIM:
            begin
                stim_next  = 1'b1;
                state_next = WAIT;
            end
            WAIT:
            begin
                if (stop_db)
                begin
                    stim_next = 1'b0;
                    start_b2b = 1'b1;
                    state_next = DONE;
                end
            end
            DONE:
            begin
                if (clr_db)
                    state_next = IDLE;
            end
            default:
            begin
                state_next = IDLE;
                stim_next  = 1'b0;
                start_b2b  = 1'b0;
            end
        endcase
    end

    always_ff @(posedge clk)
    begin
        if (!rst_n)
        begin
            state_reg <= IDLE;
            stim_led  <= 1'b0;
        end
        else
        begin
            state_reg <= state_next;
            stim_led  <= stim_next;
        end
    end

   early_detection_debounce u_start_db
   (
      .clk		(clk),
      .rst_n	(rst_n),
      .sw		(start),
      .db		(start_db)
   );
   
   early_detection_debounce u_stop_db
   (
      .clk		(clk),
      .rst_n		(rst_n),
      .sw 		(stop),
      .db		(stop_db)
   );
   
   early_detection_debounce u_clr_db
   (
      .clk 		(clk),
      .rst_n		(rst_n),
      .sw		(clear),
      .db		(clr_db)
   );
   
   bin2bcd u_bin2bcd
   (
       .clk             (clk),
       .rst_n           (rst_n),
       .start           (start_b2b),
       .bin             (ms_count),
       .ready           (),
       .done_tick       (),
       .bcd3            (bcd3),
       .bcd2            (bcd2),
       .bcd1            (bcd1),
       .bcd0            (bcd0)
   );
    
   hex_sseg_disp u_hex_sseg_disp
   (
      .clk		(clk),
      .rst_n 		(rst_n),
      .bcd3		(bcd3),
      .bcd2		(bcd2),
      .bcd1		(bcd1),
      .bcd0		(bcd0),
      .sseg		(sseg),
      .an		(an)
    );
endmodule
