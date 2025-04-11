module disp_mux_pwm
(
    input  logic        clk,
    input  logic        rst,

    input  logic [3:0]  hex0,
    input  logic [3:0]  hex1,
    input  logic [3:0]  hex2, 
    input  logic [3:0]  hex3, 

    input  logic [3:0]  dp_in,

    output logic [3:0]  an_out,
    output logic [7:0]  sseg,
	
	input  logic [3:0]  w_in
);

    // constant declaration
    // refreshing rate around 1600 Hz (100 MHz/2^16)
    localparam N = 18;

    // signal declaration
    logic [N-1:0] count;
    logic [3:0]   hex_in;
	logic         pwm_sig;
	logic [3:0]   an;
	logic         dp;
	
    // N-bit counter
    // register
    always_ff @(posedge clk)
    begin
        if (rst)
            count <= 'b0;
        else
            count <= count + 1;
    end

    always_comb
    begin
        case(count[N-1:N-2])
            2'b00:
            begin
                an = 4'b1110;
                hex_in = hex0;
                dp = dp_in;
            end
            2'b01:
            begin
                an = 4'b1101;
                hex_in = hex1; 
                dp = dp_in[1];
            end
            2'b10:
            begin
                an = 4'b1011;
                hex_in = hex2;
                dp = dp_in[2];
            end
            2'b11:
            begin
                an = 4'b0111;
                hex_in = hex3;
                dp = dp_in[3];
            end
        endcase
    end

    always_comb
    begin
        case(hex_in)
            4'h0: sseg[6:0] = 7'b1000000;
            4'h1: sseg[6:0] = 7'b1111001;
            4'h2: sseg[6:0] = 7'b0100100;
            4'h3: sseg[6:0] = 7'b0110000;
            4'h4: sseg[6:0] = 7'b0011001;
            4'h5: sseg[6:0] = 7'b0010010;
            4'h6: sseg[6:0] = 7'b0000010;
            4'h7: sseg[6:0] = 7'b1111000;
            4'h8: sseg[6:0] = 7'b0000000;
			4'h9: sseg[6:0] = 7'b0010000;
			4'ha: sseg[6:0] = 7'b0001000;
			4'hb: sseg[6:0] = 7'b0000011;
			4'hc: sseg[6:0] = 7'b1000110;
			4'hd: sseg[6:0] = 7'b0100001;
			4'he: sseg[6:0] = 7'b0000110;
			default: sseg[6:0] = 7'b0001110;
        endcase
		sseg[7] = dp;
    end
	
	pwm_led_dimmer u_pwm_led_dimmer
	(
		.clk           (clk),
		.rst		   (rst),
		.w             (w_in),
		.pwm_sig       (pwm_sig)
	);
	
	assign an_out = an | {4{!pwm_sig}};
	
endmodule