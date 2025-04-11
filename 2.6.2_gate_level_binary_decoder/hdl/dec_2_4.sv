module dec_2_4
(
   input  logic [1:0] a,
   input  logic       en,
   
   output logic [3:0] y
);

   always_comb
   begin
      casez({en,a})
	     3'b0??: y = 4'b0000;
		 3'b100: y = 4'b0001;
		 3'b101: y = 4'b0010;
		 3'b110: y = 4'b0100;
		 3'b111: y = 4'b1000;
	  endcase
   end
endmodule