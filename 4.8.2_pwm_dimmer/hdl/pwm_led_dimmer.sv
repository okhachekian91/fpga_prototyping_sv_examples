module pwm_led_dimmer
(
    input  logic        clk,
    input  logic        rst,

    input  logic [3:0]  w,
    output logic        pwm_sig
);


    logic [3:0] pwm_counter;

    always_ff @(posedge clk)
    begin
        if (rst)
            pwm_counter <= 'b0;
        else
            pwm_counter <= pwm_counter + 1; 
    end

    assign pwm_sig = (pwm_counter <= w) ? 1'b1 : 1'b0;

endmodule