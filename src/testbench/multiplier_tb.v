module multiplier_br2_tb;
    reg  [7:0] multiplicand;
    reg  [7:0] multiplier;
    reg        clk, rst, start;
    wire [15:0] product;
    wire        done;

    multiplier_br2 uut(
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .clk(clk),
        .rst(rst),
        .start(start),
        .product(product),
        .done(done)
    );

    // clock: toggle la fiecare 5ns
    always #5 clk = ~clk;

    // task pentru o inmultire completa
    task do_multiply;
        input [7:0] m, q;
        input signed [15:0] expected;
        begin
            // reset
            rst = 1; start = 0; #10;
            rst = 0; #10;

            // incarca operanzii
            multiplicand = m;
            multiplier   = q;
            start = 1; #10;
            start = 0;

            // asteapta done
            wait(done == 1);
            #5;

            if ($signed(product) == expected)
                $display("PASS: %0d x %0d = %0d", $signed(m), $signed(q), $signed(product));
            else
                $display("FAIL: %0d x %0d = %0d (asteptat %0d)", $signed(m), $signed(q), $signed(product), expected);
        end
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1, multiplier_br2_tb);
        $display("=== TEST MULTIPLIER BOOTH RADIX-2 ===");
        clk = 0; rst = 1; start = 0;
        multiplicand = 0; multiplier = 0;
        #10;

        // pozitiv x pozitiv
        do_multiply(8'd3,   8'd4,   16'd12);   // 3 x 4 = 12
        do_multiply(8'd7,   8'd5,   16'd35);   // 7 x 5 = 35
        do_multiply(8'd15,  8'd10,  16'd150);  // 15 x 10 = 150

        // pozitiv x negativ
        do_multiply(8'd3,   8'hFD,  -16'd9);   // 3 x (-3) = -9
        do_multiply(8'd10,  8'hF6,  -16'd100); // 10 x (-10) = -100

        // negativ x negativ
        do_multiply(8'hFD,  8'hFD,  16'd9);    // (-3) x (-3) = 9
        do_multiply(8'hF6,  8'hF6,  16'd100);  // (-10) x (-10) = 100

        // cazuri speciale
        do_multiply(8'd0,   8'd5,   16'd0);    // 0 x 5 = 0
        do_multiply(8'd1,   8'd1,   16'd1);    // 1 x 1 = 1
        do_multiply(8'd127, 8'd1,   16'd127);  // max pozitiv x 1

        $display("=== DONE ===");
        $finish;
    end
endmodule
