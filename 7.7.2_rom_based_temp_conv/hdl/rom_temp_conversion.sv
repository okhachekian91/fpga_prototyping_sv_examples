module rom_temp_conversion
(
	input  logic 		clk,
	input  logic 		rstn,

	input  logic 		format_sw,
	input  logic 		start,
	input  logic [7:0]  temp_in,
 
	output logic [7:0]	sseg,
	output logic [7:0]	an
);

logic       start_db;
logic [7:0] temp_out;
logic [3:0] bcd0, bcd1, bcd2, bcd3;

early_detection_debounce u_edb
(
    .clk              (clk),
    .rst_n            (rstn),

    .sw               (!start),
    .db               (start_db)

);

sync_rom_temp_conv
(
	.clk		(clk),
	.addr		(temp_in),
	.data		(temp_out),
	.format_sel     (format_sw)
);

bin2bcd i_bin2bcd
(
    .clk               (clk),
    .rst_n             (rstn),
    .start             (start_db),
    .bin               ({6'b0,temp_out[7:0]}),
    .ready             (),
    .done_tick         (),
    .bcd3              (bcd3),
    .bcd2              (bcd2),
    .bcd1              (bcd1),
    .bcd0              (bcd0)
);
hex_sseg_disp i_hex_sseg_disp
(
   .clk                (clk),
   .rst_n              (rstn),
   .bcd0               (bcd0),
   .bcd1               (bcd1),
   .bcd2               (bcd2),
   .bcd3               (bcd3),
   .sseg               (sseg),
   .an                 (an)
);

endmodule
