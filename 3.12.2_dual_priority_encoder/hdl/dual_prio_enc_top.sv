module dual_prio_enc_top
(
   input  logic [11:0] req_in,
   input  logic        sel_in,
   output logic [7:0]  sseg_out,
   output logic [7:0]  en
);

   logic [3:0] first, second; 
   logic [3:0] hex_sel;
   
   assign hex_sel = sel_in? second : first; 
   assign en = 8'b1111_1110;
   
   dual_priority_encoder u_dual_priority_encoder
   (
      .req         (req_in),
	  .first       (first),
	  .second      (second)
   );
   
   hex_to_sseg u_hex_to_sseg
   (
      .hex         (hex_sel),
	  .dp          (1'b0),
	  .sseg        (sseg_out)
   );
endmodule