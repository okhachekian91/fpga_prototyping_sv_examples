module bcd2bin_tb();


    logic [7:0] bcd_in;
    logic [6:0] bin_out;
    logic       clk;
    logic       rst_n;
    logic       start;
    logic       done;
    
    always
    begin
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
    end

    initial
    begin
        rst_n = 1'b0;
        start = 1'b0;
        bcd_in = 'b0;
        #100;
        rst_n = 1'b1;
        #100;
        bcd_in = 8'h93;
        @(negedge clk) start  = 1'b1;
        #10;
        start  = 1'b0;
        #1000;
        bcd_in = 8'h85;
        @(negedge clk) start  = 1'b1;
        #10;
        start = 1'b0;
        #1000;
        bcd_in = 8'h13;
        @(negedge clk) start  = 1'b1;
        #10;
        start = 1'b0;
        #10000;
    end

    bcd2bin dut 
    (
        .clk            (clk),
        .rst_n          (rst_n),

        .start          (start),
        .done           (done),

        .bcd_in         (bcd_in),
        .bin_out        (bin_out)
    );


endmodule