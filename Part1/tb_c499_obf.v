`timescale 1ns/1ps

module tb_c499_obf;

    // ----- DUT primary inputs (41) -----
    reg N1,N5,N9,N13,N17,N21,N25,N29,
        N33,N37,N41,N45,N49,N53,N57,N61,
        N65,N69,N73,N77,N81,N85,N89,N93,
        N97,N101,N105,N109,N113,N117,N121,N125,
        N129,N130,N131,N132,N133,N134,N135,N136,
        N137;

    // ----- 16 key inputs -----
    reg keyinput0,keyinput1,keyinput2,keyinput3,
        keyinput4,keyinput5,keyinput6,keyinput7,
        keyinput8,keyinput9,keyinput10,keyinput11,
        keyinput12,keyinput13,keyinput14,keyinput15;

    // ----- DUT outputs (32) -----
    wire N724,N725,N726,N727,N728,N729,N730,N731,
         N732,N733,N734,N735,N736,N737,N738,N739,
         N740,N741,N742,N743,N744,N745,N746,N747,
         N748,N749,N750,N751,N752,N753,N754,N755;

    // Instantiate DUT
    c499_obf dut (
        N1,N5,N9,N13,N17,N21,N25,N29,
        N33,N37,N41,N45,N49,N53,N57,N61,
        N65,N69,N73,N77,N81,N85,N89,N93,
        N97,N101,N105,N109,N113,N117,N121,N125,
        N129,N130,N131,N132,N133,N134,N135,N136,
        N137,
        keyinput0,keyinput1,keyinput2,keyinput3,
        keyinput4,keyinput5,keyinput6,keyinput7,
        keyinput8,keyinput9,keyinput10,keyinput11,
        keyinput12,keyinput13,keyinput14,keyinput15,
        N724,N725,N726,N727,N728,N729,N730,N731,
        N732,N733,N734,N735,N736,N737,N738,N739,
        N740,N741,N742,N743,N744,N745,N746,N747,
        N748,N749,N750,N751,N752,N753,N754,N755
    );

    // ----------------------------------------------------------------------
    // VCD dump for GTKWave
    // ----------------------------------------------------------------------
    initial begin
        $dumpfile("c499_obf.vcd");
        $dumpvars(0, tb_c499_obf);
    end

    // ----------------------------------------------------------------------
    // Helper: Set keyinput0..15 from a 16-bit vector
    // ----------------------------------------------------------------------
    task set_key(input [15:0] keyval);
    begin
        {keyinput15,keyinput14,keyinput13,keyinput12,
         keyinput11,keyinput10,keyinput9,keyinput8,
         keyinput7,keyinput6,keyinput5,keyinput4,
         keyinput3,keyinput2,keyinput1,keyinput0} = keyval;
    end
    endtask

    // ----------------------------------------------------------------------
    // Helper: Randomize all 41 primary inputs
    // ----------------------------------------------------------------------
    task randomize_inputs;
    begin
        N1=$random;   N5=$random;   N9=$random;   N13=$random;
        N17=$random;  N21=$random;  N25=$random;  N29=$random;
        N33=$random;  N37=$random;  N41=$random;  N45=$random;
        N49=$random;  N53=$random;  N57=$random;  N61=$random;
        N65=$random;  N69=$random;  N73=$random;  N77=$random;
        N81=$random;  N85=$random;  N89=$random;  N93=$random;
        N97=$random;  N101=$random; N105=$random; N109=$random;
        N113=$random; N117=$random; N121=$random; N125=$random;
        N129=$random; N130=$random; N131=$random; N132=$random;
        N133=$random; N134=$random; N135=$random; N136=$random;
        N137=$random;
    end
    endtask

    // ----------------------------------------------------------------------
    // Helper: Drive ONE fixed input vector (for clean proof screenshots)
    // ----------------------------------------------------------------------
    task apply_fixed_inputs;
    begin
        // A simple alternating 1/0 pattern (easy to recognize in GTKWave)
        N1=1;  N5=0;  N9=1;  N13=0;
        N17=1; N21=0; N25=1; N29=0;
        N33=1; N37=0; N41=1; N45=0;
        N49=1; N53=0; N57=1; N61=0;
        N65=1; N69=0; N73=1; N77=0;
        N81=1; N85=0; N89=1; N93=0;
        N97=1; N101=0; N105=1; N109=0;
        N113=1; N117=0; N121=1; N125=0;
        N129=1; N130=0; N131=1; N132=0;
        N133=1; N134=0; N135=1; N136=0;
        N137=1;
    end
    endtask

    // ----------------------------------------------------------------------
    // Outputs packed as a 32-bit bus for printing/comparison
    // ----------------------------------------------------------------------
    wire [31:0] out_bus = {N724,N725,N726,N727,N728,N729,N730,N731,
                          N732,N733,N734,N735,N736,N737,N738,N739,
                          N740,N741,N742,N743,N744,N745,N746,N747,
                          N748,N749,N750,N751,N752,N753,N754,N755};

    // ----------------------------------------------------------------------
    // Main test
    // ----------------------------------------------------------------------
    integer i, j;
    reg [15:0] right_key;
    reg [15:0] wrong_key;

    reg [31:0] out_right;
    reg [31:0] out_wrong;

    initial begin
        right_key = 16'b0110_1101_0010_0101;

        // -------------------------------
        // (A) Quick sanity: correct key runs
        // -------------------------------
        $display("\n=======================================");
        $display("      Testing CORRECT KEY (random inputs)");
        $display("=======================================");

        set_key(right_key);
        for (i=0; i<10; i=i+1) begin
            randomize_inputs;
            #1;
            $display("CORRECT key=%b  out=%b", right_key, out_bus);
        end

        // -------------------------------
        // (B) 10 wrong keys, 10 inputs each
        // -------------------------------
        $display("\n=======================================");
        $display("      Testing 10 WRONG KEYS (random inputs)");
        $display("=======================================\n");

        for (j=0; j<10; j=j+1) begin
            wrong_key = $random;
            if (wrong_key == right_key)
                wrong_key = wrong_key ^ 16'h0001; // ensure different

            set_key(wrong_key);

            for (i=0; i<10; i=i+1) begin
                randomize_inputs;
                #1;
                $display("WRONG%0d key=%b  out=%b", j, wrong_key, out_bus);
            end
        end

        // -------------------------------
        // (C) CLEAN PROOF SECTION (best for screenshots)
        // Same INPUTS, compare RIGHT vs WRONG key outputs
        // -------------------------------
        $display("\n=======================================");
        $display("      FIXED INPUT PROOF (RIGHT vs WRONG)");
        $display("=======================================");

        apply_fixed_inputs;

        // Right key output
        set_key(right_key);
        #1;
        out_right = out_bus;

        // Wrong key output (flip 1 bit from right_key)
        wrong_key = right_key ^ 16'h0001;
        set_key(wrong_key);
        #1;
        out_wrong = out_bus;

        $display("FIXED INPUTS");
        $display("RIGHT key=%b  out=%b", right_key, out_right);
        $display("WRONG key=%b  out=%b", wrong_key, out_wrong);

        if (out_right !== out_wrong)
            $display("PASS: Outputs differ for same input when key is wrong.");
        else
            $display("WARNING: Outputs did NOT change (check obfuscation insertion).");

        // Hold time so GTKWave shows a clean region to screenshot
        #50;

        $finish;
    end

endmodule
