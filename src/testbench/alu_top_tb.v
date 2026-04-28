// alu_top_tb.v
// Testbench pentru ALU_TOP
// Verifica:
// 00 -> Addition
// 01 -> Subtraction
// 10 -> Multiplication (Booth Radix-2)
// 11 -> Division (Restoring)

`timescale 1ns / 1ps

module alu_top_tb;

    reg         clk;
    reg         rst;
    reg         start;

    reg  [1:0]  op_select;
    reg  [7:0]  operand_a;
    reg  [7:0]  operand_b;

    wire [15:0] result;
    wire        done;

    //================================================
    // Instantiate DUT (Device Under Test)
    //================================================

    alu_top DUT (
        .clk(clk),
        .rst(rst),
        .start(start),
        .op_select(op_select),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .result(result),
        .done(done)
    );

    //================================================
    // Clock generation
    //================================================

    always #5 clk = ~clk; // clock de 10ns

    //================================================
    // Test sequence
    //================================================

    initial begin

        $display("======================================");
        $display("STARTING ALU TOP TESTBENCH");
        $display("======================================");

        clk = 0;
        rst = 1;
        start = 0;
        op_select = 2'b00;
        operand_a = 8'b0;
        operand_b = 8'b0;

        // Reset
        #20;
        rst = 0;

        //========================================
        // TEST 1 — ADDITION
        // 25 + 10 = 35
        //========================================

        $display("\nTEST 1: ADDITION");

        operand_a = 8'd25;
        operand_b = 8'd10;
        op_select = 2'b00;

        start = 1;
        #10;
        start = 0;

        #20;

        $display("A = %d, B = %d, Result = %d",
                  operand_a, operand_b, result);

        //========================================
        // TEST 2 — SUBTRACTION
        // 25 - 10 = 15
        //========================================

        $display("\nTEST 2: SUBTRACTION");

        operand_a = 8'd25;
        operand_b = 8'd10;
        op_select = 2'b01;

        start = 1;
        #10;
        start = 0;

        #20;

        $display("A = %d, B = %d, Result = %d",
                  operand_a, operand_b, result);

        //========================================
        // TEST 3 — MULTIPLICATION
        // 7 × 3 = 21
        //========================================

        $display("\nTEST 3: MULTIPLICATION");

        operand_a = 8'd7;
        operand_b = 8'd3;
        op_select = 2'b10;

        start = 1;
        #10;
        start = 0;

        wait(done == 1);

        #20;

        $display("A = %d, B = %d, Product = %d",
                  operand_a, operand_b, result);

        //========================================
        // TEST 4 — DIVISION
        // 20 / 4 = Quotient 5
        //========================================

        $display("\nTEST 4: DIVISION");

        operand_a = 8'd20;
        operand_b = 8'd4;
        op_select = 2'b11;

        start = 1;
        #10;
        start = 0;

        wait(done == 1);

        #20;

        $display("Dividend = %d, Divisor = %d",
                  operand_a, operand_b);

        $display("Quotient = %d, Remainder = %d",
                  result[7:0], result[15:8]);

        //========================================
        // END
        //========================================

        $display("\n======================================");
        $display("ALL TESTS FINISHED");
        $display("======================================");

        #50;
        $stop;
    end

endmodule
