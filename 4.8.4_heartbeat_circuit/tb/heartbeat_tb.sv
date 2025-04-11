module heartbeat_tb
();

    logic clk;
    logic rst_n;

    logic [7:0] sseg;
    logic [7:0] an;

    always
    begin
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #5;
    end

    initial begin
        rst_n = 1'b0;
        #100;
        rst_n = 1'b1;
        #1000000;
    end
    
    heartbeat u_heartbeat
    (
        .clk                (clk),
        .rst_n              (rst_n),

        .sseg               (sseg),
        .an                 (an)

    );
endmodule