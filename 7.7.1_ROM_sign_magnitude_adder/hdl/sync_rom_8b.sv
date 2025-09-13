module sync_rom_8b #
(
    parameter AWIDTH = 16,
    parameter DWIDTH = 8
)
(
    input  logic                   clk,
    input  logic [AWIDTH-1:0]      addr,
    output logic [DWIDTH-1:0]      data
);


logic [DWIDTH-1:0] rom [0:2**AWIDTH -1];
logic [DWIDTH-1:0] data_reg;

initial begin
    $readmemb("sign_mag_addr_rom_8bit.data",rom);
end

always_ff @(posedge clk)
begin
    data_reg <= rom[addr];
end

assign data = data_reg;

endmodule
