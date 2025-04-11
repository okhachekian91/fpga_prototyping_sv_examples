module bcd_increment
(
   input  logic [11:0] bcd_in,
   output logic [11:0] bcd_out
);


   always_comb
   begin
      if (bcd_in[3:0] == 4'hf)
	  begin
	     bcd_out[3:0] = 4'h0;
		 if (bcd_in[7:4] == 4'hf)
		 begin
		    bcd_out[7:4] = 4'h0;
			if (bcd_in[11:8] == 4'hf)
			   bcd_out[11:8] = 4'h0;
			else
			   bcd_out[11:8] = bcd_in[11:8] + 1; 
		 end
		 else
		 begin
		    bcd_out[11:8] = bcd_in[11:8];
		    bcd_out[7:4] = bcd_in[7:4] + 1;
		 end
	  end
	  else
	  begin
	     bcd_out[11:4] = bcd_in[11:4];
	     bcd_out[3:0] = bcd_in[3:0] + 1; 
	  end
   end
   
endmodule