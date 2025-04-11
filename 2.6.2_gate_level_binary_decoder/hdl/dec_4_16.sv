module dec_4_16
(
   input  logic [3:0] a,
   input  logic       en,
   
   output logic [15:0] y
);

   logic [3:0] en_dec;
   
   dec_2_4 dec_2_4_a
   (
      .a          (a[1:0]),
	  .en         (en_dec[0]),
	  .y          (y[3:0])
   );
   
   dec_2_4 dec_2_4_b
   (
      .a          (a[1:0]),
	  .en         (en_dec[1]),
	  .y          (y[7:4])
   );
   
   dec_2_4 dec_2_4_c
   (
      .a          (a[1:0]),
      .en         (en_dec[2]),
      .y          (y[11:8])
   );
   
   dec_2_4 dec_2_4_d
   (
      .a          (a[1:0]),
      .en         (en_dec[3]),
      .y          (y[15:12])
   );
   
   dec_2_4 dec_2_4_en
   (
      .a          (a[3:2]),
      .en         (en),
      .y          (en_dec)
   );
endmodule