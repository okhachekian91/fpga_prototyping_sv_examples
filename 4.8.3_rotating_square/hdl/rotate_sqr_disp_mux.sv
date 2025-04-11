module rotate_sqr_mux
(
    input  logic            clk,
    input  logic            rst,
    input  logic            en,
    input  logic            cw,
    
    output logic [7:0]      sseg,
    output logic [7:0]      an
    
);
    
    localparam N = 28;
    logic [N:0] count;  // add extra bit for 

    always_ff @(posedge clk)
    begin
        if (!rst)
            count <= 'b0;
        else if (en)
        begin
            if (cw)
                count <= count + 1;
            else
                count <= count - 1;
        end
    end

    always_comb
    begin
        case(count[N:N-2])
            3'b000:
            begin
                an[3:0] = 4'b1110;
            end
            3'b001:
            begin
                an[3:0] = 4'b1101;
            end
            3'b010:
            begin
                an[3:0] = 4'b1011;
            end
            3'b011:
            begin
                an[3:0] = 4'b0111;
            end
            3'b100:
            begin
                an[3:0] = 4'b0111;
            end
            3'b101:
            begin
                an[3:0] = 4'b1011;
            end
            3'b110:
            begin
                an[3:0] = 4'b1101;
            end
            3'b111:
            begin
                an[3:0] = 4'b1110;
            end
        endcase
    end

    assign sseg[6:0] = count[N] ? 7'b0011100 : 7'b0100011;
    assign sseg[7] = 1'b1;
    assign an[7:4]   = 4'b1111;
    
endmodule