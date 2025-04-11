module stop_watch
(
	input  logic 		clk,
	input  logic		rst,
	input  logic        go,
	input  logic 		clr,
	
	output logic [3:0] 	d2,
	output logic [3:0]  d1,
	output logic [3:0]  d0
);


	//declaration
	localparam DVSR = 5000000;
	
	logic [22:0] ms_reg;
	logic [3:0] d0_c, d1_c, d2_c; 
	logic 		ms_tick;
	
	always_ff @(posedge clk)
	begin
		if (rst)
			ms_reg <= 'b0;
		else if (clr)
			ms_reg <= 'b0;
		else if (go && (ms_reg == DVSR))
			ms_reg <= 'b0;
		else if (go)
			ms_reg <= ms_reg + 1 ; 
	end
	
	assign ms_tick = (ms_reg == DVSR) ? 1'b1 : 1'b0;
	
	always_comb
	begin
		d0_c = d0;
		d1_c = d1;
		d2_c = d2;
		if (ms_tick)
		begin
			if (d0 != 'd9)
				d0_c = d0 + 1; 
			else
			begin
				d0_c = 'b0;
				if (d1 != 'd9)
					d1_c = d1 + 1;
				else
				begin
					d1_c = 'b0;
					if (d2 != 'd9)
						d2_c = d2 + 1;
					else
						d2_c = 'b0;
				end
			end
		end
	end
	
	always_ff @(posedge clk)
	begin
		if (rst)
		begin
			d0 <= 'b0;
			d1 <= 'b0;
			d2 <= 'b0;
		end
		else if (clr)
		begin
			d0 <= 'b0;
			d1 <= 'b0;
			d2 <= 'b0;
		end
		else
		begin
			d0 <= d0_c;
			d1 <= d1_c;
			d2 <= d2_c;
		end
	end
	
	
endmodule