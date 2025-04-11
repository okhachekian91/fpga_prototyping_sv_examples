module dec_3_8_tb();

   logic       en;
   logic [2:0] a;
   logic [7:0] y;

   dec_3_8 u_dec_3_8
   (
      .a          (a),
      .en         (en),
      .y          (y)
   );
   
   initial begin
      {en,a} = 4'b0000;
      for (int i = 0; i < 16; i++)
      begin
	     {en,a} = i;
		 #8;
		 $display("a = %b, en = %b, y should be %8b", a, en, ({8{en}} & (8'b00000001<<a)));
		 assert (y === ({8{en}} & (8'b00000001<<a))) $display("Correct, y = %8b", y);
		 else $error("y is incorrect");
      end
      $display("Test passed");
   end
   
endmodule