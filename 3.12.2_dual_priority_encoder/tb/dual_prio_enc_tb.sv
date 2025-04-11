module dual_prio_enc_tb();

   logic [11:0] req;
   logic [3:0] first, second; 
   
   dual_priority_encoder dut
   (
      .req           (req),
	  .first         (first),
	  .second        (second)
   );
   
   
   initial begin
   req = 12'b0000_0000_0000;
   #10;
   req = 12'b0000_0000_0011;
   #10; 
   req = 12'b0001_0001_0000;
   #10; 
   req = 12'b0010_0000_0001;
   #10;
   end
endmodule