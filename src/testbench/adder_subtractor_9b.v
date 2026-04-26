module adder_sub_9bit_tb;
    reg  [7:0] a, b;
    reg        mode;
    wire [8:0] sum_diff;
    wire       cout_bout;

    adder_sub_9bit uut(
        .a(a), .b(b), .mode(mode),
        .sum_diff(sum_diff), .cout_bout(cout_bout)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1, adder_sub_9bit_tb);
        $display("=== TEST ADDER/SUBTRACTOR 9BIT ===");

        mode = 0;
        a = 8'd10;  b = 8'd5;   #10;
        if($signed(sum_diff) == 15)  $display("PASS ADD: 10+5=%0d", $signed(sum_diff));
        else                         $display("FAIL ADD: 10+5=%0d (asteptat 15)", $signed(sum_diff));

        a = 8'd100; b = 8'd28;  #10;
        if($signed(sum_diff) == 128) $display("PASS ADD: 100+28=%0d", $signed(sum_diff));
        else                         $display("FAIL ADD: 100+28=%0d (asteptat 128)", $signed(sum_diff));

        a = 8'hF6;  b = 8'h0A;  #10;
        if($signed(sum_diff) == 0)   $display("PASS ADD: -10+10=%0d", $signed(sum_diff));
        else                         $display("FAIL ADD: -10+10=%0d (asteptat 0)", $signed(sum_diff));

        a = 8'hF6;  b = 8'hF6;  #10;
        if($signed(sum_diff) == -20) $display("PASS ADD: -10+(-10)=%0d", $signed(sum_diff));
        else                         $display("FAIL ADD: -10+(-10)=%0d (asteptat -20)", $signed(sum_diff));

        mode = 1;
        a = 8'd20;  b = 8'd5;   #10;
        if($signed(sum_diff) == 15)  $display("PASS SUB: 20-5=%0d", $signed(sum_diff));
        else                         $display("FAIL SUB: 20-5=%0d (asteptat 15)", $signed(sum_diff));

        a = 8'd10;  b = 8'd10;  #10;
        if($signed(sum_diff) == 0)   $display("PASS SUB: 10-10=%0d", $signed(sum_diff));
        else                         $display("FAIL SUB: 10-10=%0d (asteptat 0)", $signed(sum_diff));

        a = 8'd5;   b = 8'd10;  #10;
        if($signed(sum_diff) == -5)  $display("PASS SUB: 5-10=%0d", $signed(sum_diff));
        else                         $display("FAIL SUB: 5-10=%0d (asteptat -5)", $signed(sum_diff));

        a = 8'hF6;  b = 8'h05;  #10;
        if($signed(sum_diff) == -15) $display("PASS SUB: -10-5=%0d", $signed(sum_diff));
        else                         $display("FAIL SUB: -10-5=%0d (asteptat -15)", $signed(sum_diff));

        $display("=== DONE ===");
        $finish;
    end

    initial begin
        $monitor("mode=%b a=%0d b=%0d | sum_diff=%0d cout=%b",
                  mode, a, b, sum_diff, cout_bout);
    end
endmodule
