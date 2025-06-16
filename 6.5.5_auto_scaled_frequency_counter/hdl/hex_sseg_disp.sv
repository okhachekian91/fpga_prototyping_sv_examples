module hex_sseg_disp
(
    input  logic        clk,
    input  logic        rst_n,

    input  logic [3:0]  bcd0,
    input  logic [3:0]  bcd1,
    input  logic [3:0]  bcd2, 
    input  logic [3:0]  bcd3,
    input  logic [2:0]  dp,

    output logic [7:0]  sseg,
    output logic [7:0]  an

);

    logic [16:0] counter; 
    logic [3:0]  hex; 
    logic [3:0]  dp_decode;
    logic        dp_bit;

    always_ff @(posedge clk)
    begin
        if (!rst_n)
            counter <= 'b0;
        else
            counter <= counter + 1;
    end

    always_comb
    begin
        case(counter[16:15])
            2'b00:
            begin
                hex     = bcd0;
                an      = 8'b11111110;
                dp_bit  = !dp_decode[0];
            end
            2'b01:
            begin
                hex     = bcd1;
                an      = 8'b11111101;
                dp_bit  = !dp_decode[1];
            end
            2'b10:
            begin
                hex     = bcd2;
                an      = 8'b11111011;
                dp_bit  = !dp_decode[2];
            end
            2'b11:
            begin
                hex     = bcd3;
                an      = 8'b11110111;
                dp_bit  = !dp_decode[3];
            end
        endcase
    end

    assign dp_decode = dp[2] ? 1 << dp[1:0] : 'b0;

    always_comb
    begin
        case(hex)
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
	   4'hf: sseg[6:0] = 7'b0001110;
	endcase
	sseg[7] = dp_bit;
   end
endmodule
