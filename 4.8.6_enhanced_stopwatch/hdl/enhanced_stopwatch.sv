module enhanced_stopwatch
(
    input  logic            clk,
    input  logic            rst_n,

    input  logic            go,
    input  logic            clr, 
    input  logic            up,

    output logic [7:0]      sseg,
    output logic [7:0]      an

);

    localparam TENTHS_SECOND = 10000000;

    logic [23:0] counter;
    logic        tenths_tick;
    logic [3:0]  min, sec0, sec1, d;
    logic [3:0]  hex;
    
    always_ff @(posedge clk)
    begin
        if (!rst_n)
            counter <= 'b0;
        else if (clr)
            counter <= 'b0;   
        else if (counter >= TENTHS_SECOND)
            counter <= 'b0;
        else
            counter <= counter + 1; 
    end

    assign tenths_tick = (counter == TENTHS_SECOND) ? 1'b1: 1'b0;

    always_ff @(posedge clk)
    begin
        if (!rst_n)
        begin
            min     <= 'b0;
            sec0    <= 'b0;
            sec1    <= 'b0;
            d       <= 'b0;
        end
        else if (clr)
        begin
            min  <= 'b0;
            sec0 <= 'b0;
            sec1 <= 'b0;
            d    <= 'b0;
        end
        else if (tenths_tick && go)
        begin
            if (up)
            begin
                if (d == 'd9)
                begin
                    d <= 'd0;
                    if (sec0 == 'd9)
                    begin
                        sec0 <= 'd0;
                        if (sec1 == 'd5)
                        begin
                            sec0 <= 'd0;
                            sec1 <= 'd0;
                            if (min == 'd9)
                                min <= 'd0;
                            else
                                min <= min + 1;
                        end
                        else
                            sec1 <= sec1 + 1;
                    end
                    else
                        sec0 <= sec0 + 1;
                end
                else
                    d <= d + 1;
            end
            else
            begin
                if (d == 'd0)
                begin
                    d <= 'd9;
                    if (sec0 == 'd0)
                    begin
                        sec0 <= 'd9;
                        if (sec1 == 'd0)
                        begin
                            sec0 <= 'd9;
                            sec1 <= 'd5;
                            if (min == 'd0)
                                min <= 'd9;
                            else
                                min <= min - 1;
                        end
                        else
                            sec1 <= sec1 - 1;
                    end
                    else
                        sec0 <= sec0 - 1;
                end
                else
                    d <= d - 1;
            end
        end
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


    always_comb
    begin
        case(counter[18:17])
        2'b00:
        begin
            hex      = d;
            an[3:0]  = 4'b1110;
        end
        2'b01:
        begin
            hex      = sec0;
            an[3:0]  = 4'b1101;
        end
        2'b10:
        begin
            hex     = sec1;
            an[3:0] = 4'b1011;
        end
        2'b11:
        begin
            hex      = min;
            an[3:0]  = 4'b0111;
        end
        endcase
    end
    
    assign an[7:4] = 4'b1111;
endmodule