module sync_rom #
(
    parameter AWIDTH = 8,
    parameter DWIDTH = 4
)
(
    input  logic                   clk,
    input  logic [AWIDTH-1:0]      addr,
    output logic [DWIDTH-1:0]      data
);


logic [3:0] rom [0:2**AWIDTH -1];
logic [DWIDTH-1:0] data_reg;

initial begin
    $readmemb("sign_mag_addr_rom.data",rom);
end

always_ff @(posedge clk)
begin
    data_reg <= rom[addr];
end

assign data = data_reg;

endmodule
