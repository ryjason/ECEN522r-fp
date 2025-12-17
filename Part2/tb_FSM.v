// ============================================================================
// Testbench for Obfuscated FSM (Part 2) - Group 1 FIXED
// ============================================================================

`timescale 1ns/1ps

module tb_FSM;

    reg clk;
    reg x;
    wire out;

    // DUT
    FSM dut (
        .x  (x),
        .clk(clk),
        .out(out)
    );

    // ------------------------------------------------------------------------
    // VCD dump
    // ------------------------------------------------------------------------
    initial begin
        $dumpfile("fsm_obf.vcd");
        $dumpvars(0, tb_FSM);
        $dumpvars(0, tb_FSM.dut); // Dump internal signals (state)
    end

    // ------------------------------------------------------------------------
    // Clock: 10 ns period
    // ------------------------------------------------------------------------
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // ------------------------------------------------------------------------
    // Group 1 Key bits (Matches FSM.v)
    // ------------------------------------------------------------------------
    localparam P1 = 1'b1; 
    localparam P2 = 1'b0;
    localparam P3 = 1'b0;
    localparam P4 = 1'b0;
    localparam P5 = 1'b1;

    // Construct the vector for easier logical negation in tests
    localparam [4:0] P = {P1,P2,P3,P4,P5}; 
    localparam [3:0] S0_O = 4'b1000;

    // ------------------------------------------------------------------------
    // Task: reset FSM back to S0_O (Simulation force)
    // FIXED: Removed the #10 delay and x=0 to prevent "Blackhole trap"
    // ------------------------------------------------------------------------
    task reset_fsm;
    begin
        // Force state back to start
        dut.state = S0_O; 
        // We do NOT wait here. We let apply_sequence set 'x' immediately.
    end
    endtask

    // ------------------------------------------------------------------------
    // Task: apply a 5-bit sequence (MSB first)
    // ------------------------------------------------------------------------
    task apply_sequence(input [4:0] seq);
        integer i;
        begin
            for (i = 4; i >= 0; i = i - 1) begin
                x = seq[i]; // Apply bit
                #10;        // Wait one clock period
            end
            #10; // small gap after sequence
        end
    endtask

    // ------------------------------------------------------------------------
    // Main stimulus
    // ------------------------------------------------------------------------
    reg [4:0] seq;

    initial begin
        // Initialize x to avoid undefined state at start
        x = 0; 

        // -------------------------------------------------------
        // 1. Wrong key: All inverted (~P1..~P5)
        // -------------------------------------------------------
        #5; // Align away from time 0
        reset_fsm();
        seq = ~P;
        $display("Test 1: Wrong Key (All Inverted) = %b", seq);
        apply_sequence(seq);
        $display("        State after Test 1: %b (Expected 1111/Blackhole)", dut.state);

        // -------------------------------------------------------
        // 2. Wrong key: P1 correct, rest inverted
        // -------------------------------------------------------
        reset_fsm();
        seq = {P1, ~P2, ~P3, ~P4, ~P5};
        $display("Test 2: Wrong Key (P1 only)      = %b", seq);
        apply_sequence(seq);
        $display("        State after Test 2: %b (Expected 1111/Blackhole)", dut.state);

        // -------------------------------------------------------
        // 3. Wrong key: First 4 correct, last inverted
        // -------------------------------------------------------
        reset_fsm();
        seq = {P1, P2, P3, P4, ~P5};
        $display("Test 3: Wrong Key (Last bit wrong) = %b", seq);
        apply_sequence(seq);
        $display("        State after Test 3: %b (Expected 1111/Blackhole)", dut.state);

        // -------------------------------------------------------
        // 4. Correct Key: P1..P5
        // -------------------------------------------------------
        reset_fsm();
        seq = P;
        $display("Test 4: Correct Key                = %b", seq);
        apply_sequence(seq);
        $display("        State after Test 4: %b (Expected 0000/S0_N)", dut.state);

        // -------------------------------------------------------
        // Demonstrate Unlocked Behavior
        // -------------------------------------------------------
        // Since state should now be 0000 (S0_N), sending '1' should move it to S2_N (0010)
        x = 1; 
        #10;
        x = 0; 
        #10;
        
        #20;
        $finish;
    end

endmodule