module float_to_int_tb();


logic             sign, sign_out;
logic [3:0]       exp, exp_out;
logic [7:0]       frac, frac_out;

logic [12:0]      signed_int, signed_int_in;
logic             udf;
logic             ovf;

float_to_int u_float_to_int
(
    .sign         (sign_out),
    .exp          (exp_out),
    .frac         (frac_out),

    .signed_int   (signed_int),
    .ovf          (ovf),
    .udf          (udf)
    
);

int_to_float u_int_to_float
(
   .sign          (sign_out),
   .exp           (exp_out),
   .frac          (frac_out),
   
   .signed_int    (signed_int_in)
);

initial
begin
//    sign = 1'b0;
//    exp  = 'b0;
//    frac = 'b0;
    signed_int_in = 'b0;
//    # 10;
//    sign = 1'b0;
//    exp  = 4'b0011;
//    frac = 8'b10011001;
//    # 10;
//    sign = 1'b0;
//    exp  = 4'b0111;
//    frac = 8'b10011001;
//    # 10;
//    sign = 1'b0;
//    exp  = 4'b1000;
//    frac = 8'b10011001;
//    # 10;
//    sign = 1'b1;
//    exp  = 4'b0011;
//    frac = 8'b10011001;
//    # 10;
//    sign = 1'b0;
//    exp  = 4'b0000;
//    frac = 8'b10011001;
//    #10;
    signed_int_in = 8'b10010001;
    #10;
    signed_int_in = 8'b00010001;
    #10;
    signed_int_in = 8'b01110001;
    #10;
    signed_int_in = 8'b00000010;
    
end

endmodule