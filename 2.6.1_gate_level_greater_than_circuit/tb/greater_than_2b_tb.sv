module greater_than_2b_tb ();

logic [1:0] a, b;
logic       y;

greater_than_2b u_greater_than_2b
(
   .a    (a),
   .b    (b),
   .y    (y)
);
initial begin
   for (int i = 0; i < 4; i ++)
   begin
      a = i;
      for (int j = 0; j < 4; j++)
	  begin
	     b = j;
		 #8;
		 assert (y === (a > b))
		 else $error("a is not greater than b");
	  end
   end
   $display("Test Passed");
end

endmodule