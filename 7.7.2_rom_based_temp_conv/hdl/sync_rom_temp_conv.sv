module sync_rom_temp_conv #
(
	parameter AWIDTH = 8,
	parameter DWIDTH = 8
)
(
	input  logic 		  clk,
	input  logic [AWIDTH-1:0] addr,
	output logic [DWIDTH-1:0] data,

    input  logic 	          format_sel 
);

logic [DWIDTH-1:0] rom_c_to_f [0:2**AWIDTH-1];
logic [DWIDTH-1:0] rom_f_to_c [0:2**AWIDTH-1];

logic [DWIDTH-1:0] c_data_reg, f_data_reg;
logic [AWIDTH-1:0] f_addr;

initial begin
	$readmemb("fahrenheit_to_celcius.data",rom_f_to_c);
	$readmemb("celcius_to_fahrenheit.data",rom_c_to_f);
end

always_ff @(posedge clk)
begin
	c_data_reg <= rom_f_to_c[f_addr];
end

always_ff @(posedge clk)
begin
	f_data_reg <= rom_c_to_f[addr];
end

assign data = format_sel ? c_data_reg : f_data_reg;

assign f_addr = addr >= 32 ? addr - 32 : 'b0;
endmodule
