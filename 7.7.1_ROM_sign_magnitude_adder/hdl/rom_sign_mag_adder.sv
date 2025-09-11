module rom_sign_mag_adder
(
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic [3:0]             a,
    input  logic [3:0]             b,
    input  logic                   start,

    output logic [7:0]             sseg,
    output logic [7:0]             an

);


logic [3:0] sum;
logic [3:0] bcd0, bcd1, bcd2, bcd3;

sync_rom #
    (
    .AWIDTH       (8),
    .DWIDTH       (4)
    )
sign_mag_adder_rom
(
    .clk               (clk),
    .addr              ({b,a}),
    .data              (sum)
);

early_detection_debounce u_edb
(
    .clk              (clk),
    .rst_n            (rst_n),

    .sw               (!start),
    .db               (start_db)

);
bin2bcd i_bin2bcd
(
    .clk               (clk),
    .rst_n             (rst_n),
    .start             (start_db),
    .bin               ({11'b0,sum[2:0]}),
    .ready             (),
    .done_tick         (),
    .bcd3              (),
    .bcd2              (),
    .bcd1              (),
    .bcd0              (bcd0)
);

assign bcd1 = {3'b0, sum[3]};
assign bcd2 = 'b0;
assign bcd3 = 'b0;

hex_sseg_disp_sign_mag i_hex_sseg_disp_sign_mag
(
   .clk                (clk),
   .rst_n              (rst_n),
   .bcd0               (bcd0),
   .bcd1               (bcd1),
   .bcd2               (bcd2),
   .bcd3               (bcd3),
   .sseg               (sseg),
   .an                 (an)
);


endmodule



