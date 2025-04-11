module rotating_led_banner
(
    input  logic            clk,
    input  logic            rst_n,

    input  logic            en,
    input  logic            dir,

    output logic [7:0]      sseg,
    output logic [7:0]      an

);

    logic [25:0] counter;

    logic [3:0] digit [3:0];
    logic [3:0] hex;

    always_ff @(posedge clk)
    begin
        if (!rst_n)
            counter <= 'b0;
        else
            counter <= counter + 1;
    end

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1)
        begin
            always_ff @(posedge clk)
            begin
                if (!rst_n)
                    digit[i] <= i;
                else if (en)
                begin
                    if (counter == 'b0)
                    begin
                        if (dir)
                        begin
                            if (digit[i] == 'd9)
                                digit[i] <= 'd0;
                            else
                                digit[i] <= digit[i] + 1;
                        end
                        else
                        begin
                            if (digit[i] == 'd0)
                                digit[i] <= 'd9;
                            else
                                digit[i] <= digit[i] - 1;
                        end
                    end
                end
            end
        end
    endgenerate

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

    always_comb
    begin
        case(counter[18:17])
        2'b00:
        begin
            hex      = digit[0];
            an[3:0]  = 4'b1110;
        end
        2'b01:
        begin
            hex      = digit[1];
            an[3:0]  = 4'b1101;
        end
        2'b10:
        begin
            hex     = digit[2];
            an[3:0] = 4'b1011;
        end
        2'b11:
        begin
            hex      = digit[3];
            an[3:0]  = 4'b0111;
        end
        endcase
    end

    assign an[7:4] = 4'b1111;
    
endmodule