module dec_3_8
(
   input  logic [2:0] a,
   input  logic       en,
   
   output logic [7:0] y
);

   logic ena, enb;
   
   assign ena = en && !a[2];
   assign enb = en && a[2];
   
   dec_2_4 dec_2_4_a
   (
      .a          (a[1:0]),
	  .en         (ena),
	  .y          (y[3:0])
   );
   
   dec_2_4 dec_2_4_b
   (
      .a          (a[1:0]),
	  .en         (enb),
	  .y          (y[7:4])
   );
   
endmodule