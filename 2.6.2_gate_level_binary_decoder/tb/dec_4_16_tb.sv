module dec_4_16_tb();
   logic       en;
   logic [3:0] a;
   logic [15:0] y;

   dec_4_16 u_dec_4_16
   (
      .a          (a),
      .en         (en),
      .y          (y)
   );
   
   initial begin
      {en,a} = 5'b00000;
      for (int i = 0; i < 32; i++)
      begin
	     {en,a} = i;
		 #8;
		 $display("a = %b, en = %b, y should be %16b", a, en, ({16{en}} & (16'b000000000001<<a)));
		 assert (y === ({16{en}} & (16'b000000000001<<a))) $display("Correct, y = %16b", y);
		 else $error("y is incorrect");
      end
      $display("Test passed");
   end
   
endmodule