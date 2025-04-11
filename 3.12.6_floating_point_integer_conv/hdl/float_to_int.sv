module float_to_int
(
    input  logic       sign,
    input  logic [3:0] exp,
    input  logic [7:0] frac,

    output logic [7:0] signed_int,
    output logic       ovf,
    output logic       udf

);

    logic [14:0] int_temp;
   always_comb
   begin
        udf      = 'b0;
        ovf      = 'b0;
        int_temp = 'b0;
        if (frac[7] && (exp > 'd7))
        begin
            signed_int[6:0] = {7*{1'b1}};
            ovf = 1'b1;
        end
        else if (frac[7] && (exp == 'd0))
        begin
            signed_int[6:0] = 'b0;
            udf = 1'b1;
        end
        else
        begin
            int_temp       = {{7'b0,frac} << exp};
            signed_int[6:0] = int_temp[15:8];
        end
   end

    assign signed_int[7] = sign;
    
endmodule