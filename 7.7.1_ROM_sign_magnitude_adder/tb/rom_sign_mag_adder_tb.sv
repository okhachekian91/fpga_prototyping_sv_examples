module rom_sign_mag_adder_tb();

logic       clk, rst_n;

logic [3:0] a,b;


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
    #40;
    a     = 'd1;
    b     = 'd1;
    rst_n = 1'b1;
    #40;
    a     = 'd1;
    b     = 'b1010;
end

rom_sign_mag_adder dut 
(
    .clk            (clk),
    .rst_n          (rst_n),
    .a              (a),
    .b              (b),

    .sseg           (),
    .an             (an)
);

endmodule