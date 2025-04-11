module pwm_led_dimmer_top
(
	input  logic			clk,
	input  logic			rst,
	
	input  logic [3:0]		w_in,
	
	output logic [3:0]		an_out,
	output logic [7:0]		sseg,
	
	input  logic            go,
	input  logic            clr
);

	logic [3:0] hex0, hex1, hex2;

	disp_mux_pwm u_disp_mux_pwm
	(
		.clk			(!clk),
		.rst			(!rst),
		
		.hex0			(hex0),
		.hex1			(hex1),
		.hex2			(hex2),
		.hex3			(4'b0000),
		
		.dp_in			(4'b1111),
		
		.an_out			(an_out),
		.sseg			(sseg),
		
		.w_in			(w_in)
	);
	
	stop_watch u_stop_watch
	(
		.clk			(clk),
		.rst			(!rst),
		
		.go				(go),
		.clr			(clr),
		
		.d2				(hex2),
		.d1				(hex1),
		.d0				(hex0)
	);
	
endmodule