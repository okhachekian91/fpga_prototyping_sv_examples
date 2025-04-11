module hex_sseg_disp
(
    input  logic        clk,
    input  logic        rst_n,

    input  logic [7:0]  val1,
    input  logic [7:0]  val2,
    input  logic [7:0]  val3, 
    input  logic [7:0]  val4,

    output logic [7:0]  sseg,
    output logic [7:0]  an

);

    logic [18:0] counter; 
    logic [3:0]  hex; 

    always_ff @(posedge clk)
    begin
        if (!rst_n)
            counter <= 'b0;
        else
            counter <= counter + 1;
    end

    always_comb
    begin
        case(counter[18:15])
            3'b000:
            begin
                hex     = val1[3:0];
                an      = 8'b11111110;
            end
            3'b001:
            begin
                hex     = val1[7:4];
                an      = 8'b11111101;
            end
            3'b010:
            begin
                hex     = val2[3:0];
                an      = 8'b11111011;
            end
            3'b011:
            begin
                hex     = val2[7:4];
                an      = 8'b11110111;
            end
            3'b100:
            begin
                hex     = val3[3:0];
                an      = 8'b11101111;
            end
            3'b101:
            begin
                hex     = val3[7:4];
                an      = 8'b11011111;
            end
            3'b110:
            begin
                hex     = val4[3:0];
                an      = 8'b10111111;
            end
            3'b111:
            begin
                hex     = val4[7:4];
                an      = 8'b01111111;
            end
        endcase
    end

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
	    sseg[7] = 1'b1;
   end
endmodule