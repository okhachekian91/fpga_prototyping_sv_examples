module heartbeat
(
    input  logic            clk,
    input  logic            rst_n,

    output logic [7:0]      sseg,
    output logic [7:0]      an
    
);

    localparam COUNT_1SEC  = 100000000;
    localparam COUNT_216HZ = 462962; // at 100MHz, 72 Hz x 3 - pattern of 3 symbols repeated at 72Hz
    localparam N = $clog2(COUNT_216HZ);
    logic [28:0] sec_counter;
    logic [1:0]  sec_tick;
    logic [N:0] count;
    logic [1:0] count_tick;

    logic [6:0] disp_0, disp_1, disp_2, disp_3;

    always_ff @(posedge clk)
    begin
        if (!rst_n)
            count <= 'b0;
        else if (count >= COUNT_216HZ)
            count <= 'b0;
        else
            count <= count + 1;
    end

    always_ff @(posedge clk)
    begin
        if (!rst_n)
            sec_counter <= 'b0;
        else if (sec_counter == COUNT_1SEC)
            sec_counter <= 'b0;
        else
            sec_counter <= sec_counter + 1;
    end
   
   
    always_ff @(posedge clk)
    begin
        if (!rst_n)
            sec_tick <= 'b0;
        else if (sec_tick == 'd3)
            sec_tick <= 'b0;
        else if (sec_counter == COUNT_1SEC)
            sec_tick <= sec_tick + 1;
    end
    
    always_ff @(posedge clk)
    begin
        if (!rst_n)
            count_tick <= 'b0;
        else if (count == COUNT_216HZ)
            count_tick <= count_tick + 1; 
    end

    always_comb
    begin
        case(sec_tick)
        2'b00: 
        begin 
            disp_0 = 7'b1111111;
            disp_1 = 7'b1001111;
            disp_2 = 7'b1111001;
            disp_3 = 7'b1111111;
        end
        2'b01:
        begin
            disp_0 = 7'b1111111;
            disp_1 = 7'b1111001;
            disp_2 = 7'b1001111;
            disp_3 = 7'b1111111;
        end
        2'b10:
        begin
            disp_0 = 7'b1111001;
            disp_1 = 7'b1111111;
            disp_2 = 7'b1111111;
            disp_3 = 7'b1001111; 
        end
        default:
        begin
            disp_0 = 7'b1111111;
            disp_1 = 7'b1111111;
            disp_2 = 7'b1111111;
            disp_3 = 7'b1111111;  
        end
        endcase
    end

    always_comb
    begin
        case(count_tick)
        2'b00:
        begin
            sseg[6:0] = disp_0;
            an[3:0]   = 4'b1110;
        end
        2'b01:
        begin
            sseg[6:0] = disp_1;
            an[3:0]   = 4'b1101;
        end
        2'b10:
        begin
            sseg[6:0] = disp_2;
            an[3:0]   = 4'b1011;
        end
        2'b11:
        begin
            sseg[6:0] = disp_3;
            an[3:0]   = 4'b0111;
        end
        endcase
    end

    assign sseg[7] = 1'b1;    // turn off dp
    assign an[7:4] = 4'b1111; // turn off un-used displays
    
endmodule