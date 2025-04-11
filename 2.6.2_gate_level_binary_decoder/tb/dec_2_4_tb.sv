module dec_2_4_tb();

   logic       en;
   logic [1:0] a;
   logic [3:0] y;

   dec_2_4 u_dec_2_4
   (
      .a          (a),
      .en         (en),
      .y          (y)
   );
   
   initial begin
      {en,a} = 3'b000;
      for (int i = 0; i < 8; i++)
      begin
	     {en,a} = i;
		 #8;
		 $display("a = %b, en = %b, y should be %4b", a, en, ({4{en}} & (4'b0001<<a)));
		 assert (y === ({4{en}} & (4'b0001<<a))) $display("Correct, y = %4b", y);
		 else $error("y is incorrect");
      end
      $display("Test passed");
   end
   
endmodule