module sseg_ctl
(
   input  logic        clk,
   input  logic        rst,
   
   input  logic [11:0] bcd,
   
   output logic [3:0]  hex_out,
   output logic [2:0]  an_out
   
);
   
   parameter REFRESH_RATE = 100000; // 1ms refresh per digit at 100mhz clock
   
   
   logic [16:0] cntr;           
   logic [1:0]  disp_sel;
   logic [3:0]  hex;
   logic [2:0]  an;
   
   
   always_ff @(posedge clk)
   begin
      if (rst)
	  begin
	     cntr     <= 'b0;
		 disp_sel <= 'b0;
	  end
	  else if (cntr == REFRESH_RATE)
	  begin
	     cntr <= 'b0;
	     if (disp_sel == 2'b10)
		    disp_sel <= 'b0;
		 else
	        disp_sel <= disp_sel + 1;
	  end
	  else
	     cntr <= cntr + 1; 
    end
	
	always_comb
	begin
	   case(disp_sel)
	      2'b00: 
	      begin
	         hex     <= bcd[3:0];
		     an      <= 3'b110;
	      end
	      2'b01:
	      begin
	         hex     <= bcd[7:4];
		     an      <= 3'b101;
	      end
	      2'b10:
	      begin
	         hex     <= bcd[11:8];
		     an      <= 3'b011;
	      end
	      default:
	      begin
	         hex     <= 'b0;
		     an      <= 3'b111;
	      end
	   endcase
	end
	
	always_ff @(posedge clk)
	begin
	   if (rst)
	   begin
	      hex_out <= 'b0;
		  an_out  <= 3'b111;
	   end
	   else
	   begin
	      hex_out <= hex;
		  an_out  <= an;
	   end
	end
	
endmodule