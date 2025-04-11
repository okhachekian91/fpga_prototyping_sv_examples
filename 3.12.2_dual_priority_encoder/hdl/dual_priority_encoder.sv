module dual_priority_encoder
(
   input  logic [11:0] req,
   
   output logic [3:0] first,
   output logic [3:0] second
);

   logic [11:0] req_filter;
   
   always_comb
   begin
      req_filter = req;
      if (req[11])
	  begin
	     first          = 4'b1011;
		 req_filter[11] = 1'b0;
      end
	  else if (req[10])
	  begin
	     first          = 4'b1010;
		 req_filter[10] = 1'b0;
	  end
	  else if (req[9])
	  begin
	     first         = 4'b1001;
		 req_filter[9] = 1'b0;
	  end
	  else if (req[8])
	  begin
	     first         = 4'b1000;
		 req_filter[8] = 1'b0;
	  end
	  else if (req[7])
	  begin
	     first         = 4'b0111;
		 req_filter[7] = 1'b0;
	  end
	  else if (req[6])
	  begin
	     first         = 4'b0110;
		 req_filter[6] = 1'b0;
	  end
	  else if (req[5])
	  begin
	     first         = 4'b0101;
	     req_filter[5] = 1'b0;
	  end
	  else if (req[4])
	  begin
	     first         = 4'b0100;
	     req_filter[4] = 1'b0;
      end
	  else if (req[3])
	  begin
	     first      = 4'b0011;
	     req_filter[3] = 1'b0;
	  end
	  else if (req[2])
	  begin
	     first    = 4'b0010;
	     req_filter[2] = 1'b0;
	  end
	  else if (req[1])
	  begin
	     first = 4'b0001;
	     req_filter[1] = 1'b0;
	  end
	  else if (req[0])
	  begin
	     first = 4'b0000;
	     req_filter[0] = 1'b0;
	  end
   end
   
   always_comb
   begin
      if (req_filter[11])
	     second = 4'b1011;
	  else if (req_filter[10])
	     second = 4'b1010;
	  else if (req_filter[9])
	     second = 4'b1001;
	  else if (req_filter[8])
	     second = 4'b1000;
	  else if (req_filter[7])
	     second = 4'b0111;
	  else if (req_filter[6])
	     second = 4'b0110;
	  else if (req_filter[5])
	     second = 4'b0101;
	  else if (req_filter[4])
	     second = 4'b0100;
	  else if (req_filter[3])
	     second = 4'b0011;
	  else if (req_filter[2])
	     second = 4'b0010;
	  else if (req_filter[1])
	     second = 4'b0001;
	  else if (req_filter[0])
	     second = 4'b0000;
   end
endmodule