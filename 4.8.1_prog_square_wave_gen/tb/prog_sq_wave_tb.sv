module prog_sq_wave_tb();

logic               clk;
logic               rst;

logic   [3:0]       m, n;
logic               sig;


always
begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
end

initial
begin
    rst = 1'b1;
    #100;
    rst = 1'b0;
    #20;
    m = 'd2;
    n = 'd2;
    #20000;
    m = 'd3;
    n = 'd2;
    #20000;
    m = 'd7;
    n = 'd5;
    #20000;
end

prog_sq_wave_gen u_sq_wave_gen
(
    .clk            (clk),
    .rst            (rst),
    .m              (m),
    .n              (n),
    .sig            (sig)
);

endmodule