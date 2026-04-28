// control_unit.v
// Control Unit pentru ALU pe 8 biti
// Genereaza semnalele de start pentru multiplier/divider

module control_unit(
    input        clk,
    input        rst,
    input        start,

    input  [1:0] op_select,
    // 00 = Addition
    // 01 = Subtraction
    // 10 = Multiplication
    // 11 = Division

    output reg   mult_start,
    output reg   div_start
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mult_start <= 1'b0;
            div_start  <= 1'b0;
        end
        else begin
            // default
            mult_start <= 1'b0;
            div_start  <= 1'b0;

            if (start) begin
                case (op_select)

                    // Addition -> fara start special
                    2'b00: begin
                        mult_start <= 1'b0;
                        div_start  <= 1'b0;
                    end

                    // Subtraction -> fara start special
                    2'b01: begin
                        mult_start <= 1'b0;
                        div_start  <= 1'b0;
                    end

                    // Multiplication
                    2'b10: begin
                        mult_start <= 1'b1;
                    end

                    // Division
                    2'b11: begin
                        div_start <= 1'b1;
                    end

                    default: begin
                        mult_start <= 1'b0;
                        div_start  <= 1'b0;
                    end

                endcase
            end
        end
    end

endmodule
