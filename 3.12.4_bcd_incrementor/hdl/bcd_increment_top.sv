module bcd_increment_top
(
   input  logic          clk,
   input  logic          rst,
   
   input  logic [11:0]   bcd_in,
   
   output logic [7:0]    sseg_out,
   output logic [7:0]    an_out
);

   logic [11:0] bcd_int;
   logic [3:0]  hex_int;
   logic [2:0]  an_int;
   
   sseg_ctl u_sseg_ctl
   (
      .clk              (clk),
	  .rst              (rst),
	  .bcd              (bcd_int),
	  .hex_out          (hex_int),
	  .an_out           (an_int)
   );
   
   bcd_increment u_bcd_increment
   (
      .bcd_in           (bcd_in),
	  .bcd_out          (bcd_int)
   );
   
   hex_to_sseg u_hex_to_sseg
   (
      .hex              (hex_int),
      .dp               (1'b0),
      .sseg             (sseg_out)
   );
   
   assign an_out = {5'b11111, an_int};
endmodule