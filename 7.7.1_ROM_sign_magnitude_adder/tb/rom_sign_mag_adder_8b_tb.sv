module rom_sign_mag_adder_tb();

logic       clk, rst_n;

logic [7:0] a,b;
logic       start;

initial
begin
    clk = 1'b0;
    forever begin
        #4 clk = ~clk;
    end
end

initial
begin
    rst_n = 1'b0;
    a     = 'b0;
    b     = 'b0;
    start = 1'b0;
    #40;
    a     = 'd1;
    b     = 'd1;
    rst_n = 1'b1;
    start = 1'b1;
    #8;
    start = 1'b0;
    #40;
    a     = 'd1;
    b     = 'b1010;
end

rom_sign_mag_adder_8b dut 
(
    .clk            (clk),
    .rst_n          (rst_n),
    .a              (a),
    .b              (b),
    .start          (start),
    .sseg           (),
    .an             (an)
);

endmodule