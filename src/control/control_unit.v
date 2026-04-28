
// control_unit.v
// Control Unit pentru ALU pe 8 biti
// Selecteaza operatia si genereaza semnalele de control

module control_unit(
    input        clk,
    input        rst,
    input        start,

    input  [1:0] op_select,
    // 00 = Addition
    // 01 = Subtraction
    // 10 = Multiplication
    // 11 = Division

    input        mult_done,
    input        div_done,

    output reg   mult_start,
    output reg   div_start,
    output reg   result_valid
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mult_start   <= 1'b0;
            div_start    <= 1'b0;
            result_valid <= 1'b0;
        end
        else begin
            // valori default la fiecare ciclu
            mult_start   <= 1'b0;
            div_start    <= 1'b0;
            result_valid <= 1'b0;

            if (start) begin
                case (op_select)

                    // Addition
                    2'b00: begin
                        result_valid <= 1'b1;
                    end

                    // Subtraction
                    2'b01: begin
                        result_valid <= 1'b1;
                    end

                    // Multiplication
                    2'b10: begin
                        mult_start <= 1'b1;

                        if (mult_done)
                            result_valid <= 1'b1;
                    end

                    // Division
                    2'b11: begin
                        div_start <= 1'b1;

                        if (div_done)
                            result_valid <= 1'b1;
                    end

                    default: begin
                        result_valid <= 1'b0;
                    end

                endcase
            end
        end
    end

endmodule
