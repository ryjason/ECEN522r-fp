// ============================================================================
// Experiment 14 - Part 2
// Obfuscated FSM: 5-bit unlock sequence + blackhole state
// Group: 1
// Key: 5'b10001
// ============================================================================
`timescale 1ns/1ps

module FSM(
    input  x,
    input  clk,
    output reg out
);

    // ------------------------------------------------------------------------
    // Key sequence P1..P5 for GROUP 1
    // Key: 10001
    // ------------------------------------------------------------------------
    localparam P1 = 1'b1;  // MSB
    localparam P2 = 1'b0;
    localparam P3 = 1'b0;
    localparam P4 = 1'b0;
    localparam P5 = 1'b1;  // LSB

    // ------------------------------------------------------------------------
    // State encoding
    // ------------------------------------------------------------------------
    reg [3:0] state;

    // Original FSM (blue) states
    localparam S0_N = 4'b0000;
    localparam S1_N = 4'b0001;
    localparam S2_N = 4'b0010;
    localparam S3_N = 4'b0011;
    localparam S4_N = 4'b0100;

    // Obfuscation (orange) states
    localparam S0_O = 4'b1000; // start state on power-up
    localparam S1_O = 4'b1001;
    localparam S2_O = 4'b1010;
    localparam S3_O = 4'b1011;
    localparam S4_O = 4'b1100;

    // Blackhole state
    localparam BLACKHOLE = 4'b1111;

    // Initial state = obfuscation start
    initial begin
        state = S0_O;
        out   = 1'b0;
    end

    // ------------------------------------------------------------------------
    // Sequential logic
    // ------------------------------------------------------------------------
    always @(posedge clk) begin
        case (state)

            // ------------------------------------------------------------
            // Obfuscation FSM
            // ------------------------------------------------------------
            S0_O: begin
                out <= 1'b0;
                if (x == P1) state <= S1_O;
                else         state <= BLACKHOLE;
            end

            S1_O: begin
                out <= 1'b0;
                if (x == P2) state <= S2_O;
                else         state <= BLACKHOLE;
            end

            S2_O: begin
                out <= 1'b0;
                if (x == P3) state <= S3_O;
                else         state <= BLACKHOLE;
            end

            S3_O: begin
                out <= 1'b0;
                if (x == P4) state <= S4_O;
                else         state <= BLACKHOLE;
            end

            S4_O: begin
                out <= 1'b0;
                if (x == P5) state <= S0_N;  // Unlock: Jump to Original FSM
                else         state <= BLACKHOLE;
            end

            // ------------------------------------------------------------
            // Blackhole
            // ------------------------------------------------------------
            BLACKHOLE: begin
                state <= BLACKHOLE; // Stuck here forever
                out   <= 1'b0;
            end

            // ------------------------------------------------------------
            // Original FSM behavior
            // ------------------------------------------------------------
            S0_N: begin
                out <= 1'b0;
                if (x == 1'b1) state <= S2_N;
                else           state <= S1_N;
            end

            S1_N: begin
                out <= 1'b0;
                if (x == 1'b1) state <= S2_N;
                else           state <= S3_N;
            end

            S2_N: begin
                out <= 1'b0;
                if (x == 1'b1) state <= S4_N;
                else           state <= S3_N;
            end

            S3_N: begin
                out   <= 1'b0;
                state <= S4_N;
            end

            S4_N: begin
                if (x == 1'b1) begin
                    state <= S0_N;
                    out   <= 1'b1;
                end else begin
                    state <= S1_N;
                    out   <= 1'b0;
                end
            end

            // ------------------------------------------------------------
            // Default
            // ------------------------------------------------------------
            default: begin
                state <= S0_O;
                out   <= 1'b0;
            end
        endcase
    end

endmodule