module divider_restoring_tb;
    reg  [7:0] dividend, divisor; // operanzii
    reg        clk, rst, start;
    wire [7:0] quotient;  // catul
    wire [7:0] remainder; // restul
    wire       done;      // semnal de finalizare

    // instantiem modulul de testat
    divider_restoring uut(
        .dividend(dividend),
        .divisor(divisor),
        .clk(clk),
        .rst(rst),
        .start(start),
        .quotient(quotient),
        .remainder(remainder),
        .done(done)
    );

    // clock: toggle la fiecare 5ns
    always #5 clk = ~clk;

    // task pentru o impartire completa
    task do_divide;
        input [7:0] dvd, dvs;         // deimpartit si impartitor
        input [7:0] exp_q, exp_r;     // cat si rest asteptate
        begin
            // reset
            rst = 1; start = 0; #10;
            rst = 0; #10;

            // incarca operanzii
            dividend = dvd;
            divisor  = dvs;
            start = 1; #10;
            start = 0;

            // asteapta done
            wait(done == 1);
            #5;

            if(quotient == exp_q && remainder == exp_r)
                $display("PASS: %0d / %0d = cat:%0d rest:%0d", dvd, dvs, quotient, remainder);
            else
                $display("FAIL: %0d / %0d = cat:%0d rest:%0d (asteptat cat:%0d rest:%0d)",
                          dvd, dvs, quotient, remainder, exp_q, exp_r);
        end
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1, divider_restoring_tb);
        $display("=== TEST DIVIDER RESTORING ===");
        clk = 0; rst = 1; start = 0;
        dividend = 0; divisor = 0;
        #10;

        // impartiri exacte (rest 0)
        do_divide(8'd10,  8'd2,  8'd5,  8'd0);  // 10/2 = 5 rest 0
        do_divide(8'd20,  8'd4,  8'd5,  8'd0);  // 20/4 = 5 rest 0
        do_divide(8'd15,  8'd3,  8'd5,  8'd0);  // 15/3 = 5 rest 0
        do_divide(8'd100, 8'd10, 8'd10, 8'd0);  // 100/10 = 10 rest 0

        // impartiri cu rest
        do_divide(8'd10,  8'd3,  8'd3,  8'd1);  // 10/3 = 3 rest 1
        do_divide(8'd7,   8'd2,  8'd3,  8'd1);  // 7/2 = 3 rest 1
        do_divide(8'd17,  8'd5,  8'd3,  8'd2);  // 17/5 = 3 rest 2
        do_divide(8'd255, 8'd16, 8'd15, 8'd15); // 255/16 = 15 rest 15

        // cazuri speciale
        do_divide(8'd0,   8'd5,  8'd0,  8'd0);  // 0/5 = 0 rest 0
        do_divide(8'd1,   8'd1,  8'd1,  8'd0);  // 1/1 = 1 rest 0
        do_divide(8'd5,   8'd5,  8'd1,  8'd0);  // 5/5 = 1 rest 0

        $display("=== DONE ===");
        $finish;
    end
endmodule
