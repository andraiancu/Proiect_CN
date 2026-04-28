// divider.v
// Restoring Division pe 8 biti
// Input:
//   dividend = deimpartit
//   divisor  = impartitor
//
// Output:
//   quotient  = cat
//   remainder = rest

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

    reg [7:0] A;      // Acumulator (rest partial)
    reg [7:0] Q;      // Dividend -> Quotient
    reg [7:0] M;      // Divisor
    reg [3:0] count;  // 8 iteratii

    //========================================
    // SHIFT LEFT pentru A
    //========================================

    // A <- shift left, cu Q[7] introdus pe LSB
    wire [7:0] A_shifted;
    assign A_shifted = {A[6:0], Q[7]};

    //========================================
    // SUBTRACTOR
    //========================================

    // A_shifted - M
    wire [8:0] sub_out;

    adder_sub_9bit SUB_UNIT (
        .a(A_shifted),
        .b(M),
        .mode(1'b1),       // 1 = subtraction
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

        // START OPERATION
        else if (start) begin
            A     <= 8'b0;
            Q     <= dividend;
            M     <= divisor;
            count <= 4'b0;
            done  <= 1'b0;
        end

        // MAIN DIVISION LOOP
        else if (count < 8) begin

            // daca rezultatul scaderii este negativ
            if (sub_out[8] == 1'b1) begin
                // restore:
                // A ramane A_shifted
                // Q[0] = 0
                A <= A_shifted;
                Q <= {Q[6:0], 1'b0};
            end

            // daca rezultatul este pozitiv
            else begin
                // accept subtraction:
                // A = rezultat
                // Q[0] = 1
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
