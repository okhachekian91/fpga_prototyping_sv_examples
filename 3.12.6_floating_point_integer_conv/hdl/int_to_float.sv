module int_to_float
(
   input  logic [7:0] signed_int,

   output logic [3:0] exp,
   output logic [7:0] frac,
   output logic       sign
);

    logic [7:0] frac_temp;

    always_comb
    begin
        casez(signed_int[6:0])
            7'b1??????: exp  = 'd7;
            7'b01?????: exp =  'd6;
            7'b001????: exp =  'd5;
            7'b0001???: exp =  'd4;
            7'b00001??: exp =  'd3;
            7'b000001?: exp =  'd2;
            7'b0000001: exp =  'd1;
            7'b0000000: exp =  'd0;
        endcase
    end

    assign frac = {signed_int[6:0] << ('d7 - exp), 1'b0};
    assign sign = signed_int[7];
    
endmodule