module park_occupancy_top
(
    input  logic            clk,
    input  logic            rst_n,

    input  logic            sensor_a_in,
    input  logic            sensor_b_in,

    output logic    [7:0]   sseg,
    output logic    [7:0]   an

);

    logic sensor_a_db, sensor_b_db;
    logic [7:0] occupancy_counter;

    logic inc, dec;

    parking_occupancy parking_occupancy_ctl
    (
        .clk            (clk),
        .rst_n          (rst_n),

        .sensor_a       (sensor_a_db),
        .sensor_b       (sensor_b_db),

        .car_enter      (inc),
        .car_exit       (dec)
    );


    early_detection_debounce u_debounce_a
    (
        .clk            (clk),
        .rst_n          (rst_n),

        .sw             (sensor_a_in),
        .db             (sensor_a_db)
    );


    early_detection_debounce u_debounce_b
    (
        .clk            (clk),
        .rst_n          (rst_n),

        .sw             (sensor_b_in),
        .db             (sensor_b_db)
    );

    always_ff @(posedge clk)
    begin
        if (!rst_n)
            occupancy_counter <= 'b0;
        else if (inc)
            occupancy_counter <= occupancy_counter + 1;
        else if (dec)
        begin
            if (occupancy_counter != 'b0)
                occupancy_counter <= occupancy_counter - 1;
        end 
    end

    hex_sseg_disp u_hex_sseg_disp
    (
        .clk            (clk),
        .rst_n          (rst_n),
        .val1          (occupancy_counter),
        .val2          ('b0),
        .val3          ('b0),
        .val4          ('b0),
        .sseg           (sseg),
        .an             (an)
    );
    
endmodule