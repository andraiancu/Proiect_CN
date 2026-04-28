// alu_top.v
// Top module pentru ALU pe 8 biti

module alu_top(
    input         clk,
    input         rst,
    input         start,

    input  [1:0]  op_select,
    input  [7:0]  operand_a,
    input  [7:0]  operand_b,

    output [15:0] result,
    output        done
);

    //========================================
    // WIRES
    //========================================

    wire [8:0] add_result;
    wire [8:0] sub_result;

    wire [15:0] mult_result;

    wire [7:0] div_quotient;
    wire [7:0] div_remainder;

    wire mult_done;
    wire div_done;

    wire mult_start;
    wire div_start;

    // rezultate extinse la 16 biti
    wire [15:0] add_result_ext;
    wire [15:0] sub_result_ext;
    wire [15:0] div_result_ext;

    //========================================
    // ADDITION
    //========================================

    adder_sub_9bit ADD_UNIT (
        .a(operand_a),
        .b(operand_b),
        .mode(1'b0),
        .sum_diff(add_result),
        .cout_bout()
    );

    //========================================
    // SUBTRACTION
    //========================================

    adder_sub_9bit SUB_UNIT (
        .a(operand_a),
        .b(operand_b),
        .mode(1'b1),
        .sum_diff(sub_result),
        .cout_bout()
    );

    //========================================
    // MULTIPLICATION
    //========================================

    multiplier_br2 MULT_UNIT (
        .multiplicand(operand_a),
        .multiplier(operand_b),
        .clk(clk),
        .rst(rst),
        .start(mult_start),
        .product(mult_result),
        .done(mult_done)
    );

    //========================================
    // DIVISION
    //========================================

    divider_restoring DIV_UNIT (
        .dividend(operand_a),
        .divisor(operand_b),
        .clk(clk),
        .rst(rst),
        .start(div_start),
        .quotient(div_quotient),
        .remainder(div_remainder),
        .done(div_done)
    );

    //========================================
    // CONTROL UNIT
    //========================================

    control_unit CTRL (
        .clk(clk),
        .rst(rst),
        .start(start),
        .op_select(op_select),
        .mult_start(mult_start),
        .div_start(div_start)
    );

    //========================================
    // RESULT FORMATTING
    //========================================

    assign add_result_ext = {7'b0, add_result};
    assign sub_result_ext = {7'b0, sub_result};

    // [ remainder | quotient ]
    assign div_result_ext = {div_remainder, div_quotient};

    //========================================
    // OUTPUT MUX
    //========================================

    mux4to1_16bit RESULT_MUX (
        .in0(add_result_ext),
        .in1(sub_result_ext),
        .in2(mult_result),
        .in3(div_result_ext),
        .sel(op_select),
        .out(result)
    );

    //========================================
    // DONE SIGNAL
    //========================================

    assign done =
        (op_select == 2'b00) ? 1'b1 :   // add
        (op_select == 2'b01) ? 1'b1 :   // sub
        (op_select == 2'b10) ? mult_done :
                               div_done;

endmodule
