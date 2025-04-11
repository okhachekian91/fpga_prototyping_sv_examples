module prog_sq_wave_gen
(
    input  logic          clk,
    input  logic          rst,

    input  logic [3:0]    m,
    input  logic [3:0]    n,

    output logic          sig

);

    logic [3:0] count_tick;
    logic       tick_100ns;
    logic [5:0] count_sig;
    logic [4:0] tick_sum;
    
    always_ff @(posedge clk)
    begin
        if (rst)
            tick_sum <= 'b0;
        else
            tick_sum <= m + n; 
    end
    
    always_ff @(posedge clk)
    begin
        if (rst)
            count_tick <= 'b0;
        else if (count_tick == 'd9)
            count_tick <= 'b0;
        else
            count_tick <= count_tick + 1; 
    end

    assign tick_100ns = (count_tick == 'd9);

    always_ff @(posedge clk)
    begin
        if (rst)
            count_sig <= 'b0;
        else if (tick_100ns)
        begin
            if (count_sig >= tick_sum-1)
                count_sig <= 'b0;
            else
                count_sig <= count_sig + 1; 
        end
    end

    assign sig = (count_sig <= m-1)? 1'b1: 1'b0;

endmodule