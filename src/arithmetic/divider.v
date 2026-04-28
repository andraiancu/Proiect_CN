// divider.v
// Restoring Division pe 8 biti
// Corectat pentru quotient corect

module divider_restoring(
    input  [7:0] dividend,
    input  [7:0] divisor,
    input        clk,
    input        rst,
    input        start,

    output [7:0] quotient,
    output [7:0] remainder,
    output reg   done
);

    //========================================
    // REGISTRE INTERNE
    //========================================

    reg [7:0] A;      // remainder partial
    reg [7:0] Q;      // dividend -> quotient
    reg [7:0] M;      // divisor
    reg [3:0] count;  // 8 iteratii

    //========================================
    // SHIFT LEFT COMBINED [A,Q]
    //========================================

    // In restoring division:
    // [A,Q] <- left shift [A,Q]

    wire [7:0] A_shifted;
    wire [7:0] Q_shifted;

    assign A_shifted = {A[6:0], Q[7]};
    assign Q_shifted = {Q[6:0], 1'b0};

    //========================================
    // SUBTRACTOR
    //========================================

    wire [8:0] sub_out;

    // A_shifted - M

    adder_sub_9bit SUB_UNIT (
        .a(A_shifted),
        .b(M),
        .mode(1'b1),
        .sum_diff(sub_out),
        .cout_bout()
    );

    //========================================
    // OUTPUTS
    //========================================

    assign quotient  = Q;
    assign remainder = A;

    //========================================
    // SEQUENTIAL LOGIC
    //========================================

    always @(posedge clk or posedge rst) begin

        // RESET
        if (rst) begin
            A     <= 8'b0;
            Q     <= 8'b0;
            M     <= 8'b0;
            count <= 4'b0;
            done  <= 1'b0;
        end

        // START
        else if (start) begin
            A     <= 8'b0;
            Q     <= dividend;
            M     <= divisor;
            count <= 4'b0;
            done  <= 1'b0;
        end

        // MAIN LOOP
        else if (count < 8) begin

            // daca A_shifted - M este negativ
            if (sub_out[8] == 1'b1) begin

                // restore:
                // A ramane A_shifted
                // Q[0] = 0

                A <= A_shifted;
                Q <= Q_shifted;

            end
            else begin
                A <= sub_out[7:0];
                Q <= {Q[6:0], 1'b1};
            end

            count <= count + 1'b1;
        end

        // FINISH
        else begin
            done <= 1'b1;
        end

    end

endmodule
