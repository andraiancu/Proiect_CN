// multiplier.v
// Booth Radix-2 Multiplier pe 8 biti
// Product final pe 16 biti

module multiplier_br2(
    input  [7:0] multiplicand,   // M
    input  [7:0] multiplier,     // Q
    input        clk,
    input        rst,
    input        start,

    output [15:0] product,
    output reg    done
);

    //========================================
    // REGISTRE INTERNE
    //========================================

    reg [7:0] A;       // Acumulator
    reg [7:0] Q;       // Multiplier
    reg [7:0] M;       // Multiplicand
    reg       q_m1;    // Q(-1)
    reg [3:0] count;   // 8 iteratii

    //========================================
    // ADD / SUB CONTROL
    //========================================

    wire [8:0] sum_diff;
    wire mode;

    // Booth logic:
    // 01 -> ADD
    // 10 -> SUB
    //
    // mode = 0 => add
    // mode = 1 => subtract

    assign mode = (Q[0] == 1'b1 && q_m1 == 1'b0);

    //========================================
    // ADDER / SUBTRACTOR
    //========================================

    adder_sub_9bit CALC_UNIT (
        .a(A),
        .b(M),
        .mode(mode),
        .sum_diff(sum_diff),
        .cout_bout()
    );

    //========================================
    // FINAL PRODUCT
    //========================================

    assign product = {A, Q};

    //========================================
    // SEQUENTIAL LOGIC
    //========================================

    always @(posedge clk or posedge rst) begin

        // RESET
        if (rst) begin
            A     <= 8'b0;
            Q     <= 8'b0;
            M     <= 8'b0;
            q_m1  <= 1'b0;
            count <= 4'b0;
            done  <= 1'b0;
        end

        // START OPERATION
        else if (start) begin
            M     <= multiplicand;
            Q     <= multiplier;
            A     <= 8'b0;
            q_m1  <= 1'b0;
            count <= 4'b0;
            done  <= 1'b0;
        end

        // MAIN BOOTH LOOP
        else if (count < 8) begin

            // daca Q0 si Q(-1) sunt diferite:
            // 01 sau 10 -> add/sub + arithmetic shift
            if (Q[0] ^ q_m1) begin

                // arithmetic right shift
                // semnul este sum_diff[8]

                {A, Q, q_m1} <= {
                    sum_diff[8],      // sign extension
                    sum_diff[8:0],
                    Q
                };
            end

            // daca sunt 00 sau 11:
            // doar arithmetic shift
            else begin

                {A, Q, q_m1} <= {
                    A[7],             // preserve sign
                    A,
                    Q
                };
            end

            count <= count + 1'b1;
        end

        // FINISH
        else begin
            done <= 1'b1;
        end

    end

endmodule
