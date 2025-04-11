module simple_fp_adder
(
    input  logic       sign1,
    input  logic [3:0] exp1,
    input  logic [7:0] frac1,
    input  logic       sign2,
    input  logic [3:0] exp2,
    input  logic [7:0] frac2,

    output logic       sign_out,
    output logic [3:0] exp_out,
    output logic [7:0] frac_out 
);

    logic signb, signs;
    logic [3:0] expb, exps, expn, expdiff;
    logic [7:0] fracb, fracs, fraca, sum_norm;
    logic [8:0] sum;
    logic [2:0] lead0;

    always_comb
    begin
        // sort to find larger number
        if ({exp1, frac1} > {exp2, frac2})
        begin
            signb = sign1;
            signs = sign2; 
            expb = exp1;
            exps = exp2;
            fracb = frac1;
            fracs = frac2;
        end
        else
        begin
            signb = sign2;
            signs = sign1;
            expb = exp2;
            exps = exp1;
            fracb = frac2;
            fracs = frac1;
        end

        // align smaller number
        exp_diff = expb - exps;
        fraca = fracs >> exp_diff;

        // add/subtract
        if (signb == sign1)
            sum = {1'b0, fracb} + {1'b0, fraca};
        else
            sum = {1'b0, fracb} - {1'b0, fraca};

        //count leading 0s
        if(sum[7])
            lead0 = 3'b000;
        else if (sum[6])
            lead0 = 3'b001;
        else if (sum[5])
            lead0 = 3'b010;
        else if (sum[4])
            lead0 = 3'b011;
        else if (sum[3])
            lead0 = 3'b100;
        else if (sum[2])
            lead0 = 3'b101;
        else if (sum[1])
            lead0 = 3'b110;
        else
            lead0 = 3'b111;

        // shift significand
        sum_norm = sum << lead0;

        //normalize with special conditions
        if (sum[8]) // carry out, shift frac to right
        begin
            expn = expb + 1;
            fracn = sum[8:1];
        end
        else if (lead0 > expb) // too small to normalize
        begin
            expn = 0;
            fracn = 0;    
        end
        else
        begin
            expn = expb - lead0;
            fracn = sum_norm;
        end

        sign_out = signb;
        exp_out = expn;
        frac_out = fracn;
    end

endmodule