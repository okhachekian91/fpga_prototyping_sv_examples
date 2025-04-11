module debounce_test_tb();


    logic clk;
    logic rst_n;

    logic [7:0] sseg;
    logic [7:0] an;

    logic btn;
    
    debounce_test u_debounce_test
    (
        .clk            (clk),
        .rst_n          (rst_n),

        .btn            (btn),
        .sseg           (sseg),
        .an             (an)
    );

    always
    begin
        clk = 1'b0;
        #5; 
        clk = 1'b1;
        #5;
    end


    initial
    begin
        btn   = 1'b1;
        rst_n = 1'b0;
        #100;
        rst_n = 1'b1;
        #25;
        btn = 1'b0;
        #10;
        btn = 1'b1;
        #10;
        btn = 1'b0;
        #10;
        btn = 1'b1;
        #10000;
        btn = 1'b0;
        #10;
        btn = 1'b1;
        #10;
        btn = 1'b0;
        #10;
        btn = 1'b1;
    end
endmodule