module parking_occupancy
(
    input  logic        clk,
    input  logic        rst_n,

    input  logic        sensor_a,
    input  logic        sensor_b,

    output logic        car_enter,
    output logic        car_exit
);

    enum logic [2:0] { PARK_IDLE    = 3'b000,
                       PARK_ENTER_1 = 3'b001,
                       PARK_ENTER_2 = 3'b010,
                       PARK_ENTER_3 = 3'b011,
                       PARK_EXIT_1  = 3'b100,
                       PARK_EXIT_2  = 3'b101,
                       PARK_EXIT_3  = 3'b111
                    } park_state, park_next; 

    always_comb
    begin
        park_next = park_state; 
        car_exit  = 1'b0;
        car_enter = 1'b0;
        case(park_state)
            PARK_IDLE:
            begin
                if (sensor_a)
                    park_next = PARK_ENTER_1;
                else if (sensor_b)
                    park_next = PARK_EXIT_1;
            end
            PARK_ENTER_1:
            begin
                if (sensor_a && sensor_b)
                    park_next = PARK_ENTER_2;
            end
            PARK_ENTER_2:
            begin
                if (sensor_b && !sensor_a)
                    park_next = PARK_ENTER_3;
            end
            PARK_ENTER_3:
            begin
                if (!sensor_a && !sensor_b)
                begin
                    car_enter = 1'b1;
                    park_next = PARK_IDLE;
                end
            end
            PARK_EXIT_1:
            begin
                if (sensor_a && sensor_b)
                    park_next = PARK_EXIT_2;
            end
            PARK_EXIT_2:
            begin
                if (!sensor_b && sensor_a)
                    park_next = PARK_EXIT_3;
            end
            PARK_EXIT_3:
            begin
                if (!sensor_a && !sensor_b)
                begin
                    car_exit = 1'b1;
                    park_next = PARK_IDLE;
                end
            end
        endcase
    end

    always_ff @(posedge clk)
    begin
        if (!rst_n)
            park_state <= PARK_IDLE;
        else
            park_state <= park_next;
    end

endmodule