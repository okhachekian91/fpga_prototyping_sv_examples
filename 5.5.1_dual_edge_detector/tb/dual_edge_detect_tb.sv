module dual_edge_detect_tb();

    logic clk;
    logic rst_n;
    
    logic level;
    logic edge_tick;
    

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
        #100;
        rst_n = 1'b1;
        #20;
        level = 1'b1;
        #20;
        level = 1'b0;
        #20;
        level = 1'b1;
        #40;
        level = 1'b0;
        #20;
        level = 1'b1;
        #10;
        level = 1'b0;
        #100;
    end

    dual_edge_detect u_dual_edge_detect
    (
        .clk            (clk),
        .rst_n          (rst_n),

        .level          (level),
        .edge_tick      (edge_tick)
    );


endmodule