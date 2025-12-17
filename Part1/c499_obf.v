// ============================================================================
// Obfuscated Wrapper for c499
// - Keeps original I/O of c499
// - Adds 16 scalar key inputs: keyinput0 .. keyinput15
// - Obfuscates outputs N724..N739 with XOR key-gates
//   (correct key here is all zeros; you can change it by mixing XOR/XNOR)
// ============================================================================

module c499_obf (
    // ----- Original primary inputs (41) -----
    input N1,N5,N9,N13,N17,N21,N25,N29,
    input N33,N37,N41,N45,N49,N53,N57,N61,
    input N65,N69,N73,N77,N81,N85,N89,N93,
    input N97,N101,N105,N109,N113,N117,N121,N125,
    input N129,N130,N131,N132,N133,N134,N135,N136,
    input N137,

    // ----- 16 scalar key inputs -----
    input keyinput0,keyinput1,keyinput2,keyinput3,
    input keyinput4,keyinput5,keyinput6,keyinput7,
    input keyinput8,keyinput9,keyinput10,keyinput11,
    input keyinput12,keyinput13,keyinput14,keyinput15,

    // ----- Original primary outputs (32) -----
    output N724,N725,N726,N727,N728,N729,N730,N731,
    output N732,N733,N734,N735,N736,N737,N738,N739,
    output N740,N741,N742,N743,N744,N745,N746,N747,
    output N748,N749,N750,N751,N752,N753,N754,N755
);

    // Internal wires for original outputs
    wire N724_plain,N725_plain,N726_plain,N727_plain,
         N728_plain,N729_plain,N730_plain,N731_plain,
         N732_plain,N733_plain,N734_plain,N735_plain,
         N736_plain,N737_plain,N738_plain,N739_plain,
         N740_plain,N741_plain,N742_plain,N743_plain,
         N744_plain,N745_plain,N746_plain,N747_plain,
         N748_plain,N749_plain,N750_plain,N751_plain,
         N752_plain,N753_plain,N754_plain,N755_plain;

    // =============================
    // Instantiate original c499 core
    // =============================
    c499 core_inst (
        .N1(N1),.N5(N5),.N9(N9),.N13(N13),
        .N17(N17),.N21(N21),.N25(N25),.N29(N29),
        .N33(N33),.N37(N37),.N41(N41),.N45(N45),
        .N49(N49),.N53(N53),.N57(N57),.N61(N61),
        .N65(N65),.N69(N69),.N73(N73),.N77(N77),
        .N81(N81),.N85(N85),.N89(N89),.N93(N93),
        .N97(N97),.N101(N101),.N105(N105),.N109(N109),
        .N113(N113),.N117(N117),.N121(N121),.N125(N125),
        .N129(N129),.N130(N130),.N131(N131),.N132(N132),
        .N133(N133),.N134(N134),.N135(N135),.N136(N136),
        .N137(N137),

        .N724(N724_plain),.N725(N725_plain),
        .N726(N726_plain),.N727(N727_plain),
        .N728(N728_plain),.N729(N729_plain),
        .N730(N730_plain),.N731(N731_plain),
        .N732(N732_plain),.N733(N733_plain),
        .N734(N734_plain),.N735(N735_plain),
        .N736(N736_plain),.N737(N737_plain),
        .N738(N738_plain),.N739(N739_plain),
        .N740(N740_plain),.N741(N741_plain),
        .N742(N742_plain),.N743(N743_plain),
        .N744(N744_plain),.N745(N745_plain),
        .N746(N746_plain),.N747(N747_plain),
        .N748(N748_plain),.N749(N749_plain),
        .N750(N750_plain),.N751(N751_plain),
        .N752(N752_plain),.N753(N753_plain),
        .N754(N754_plain),.N755(N755_plain)
    );

    // =============================
    // 16 key gates on N724..N739
    //
    // Right now: all XOR (^)
    //   → correct key = 16'b0110110100100101
    //
    // If your Table 2 key bit i is 1, change that line to XNOR:
    //   assign Nxxx = Nxxx_plain ~^ keyinputi;
    // =============================

    assign N724 = N724_plain ^  keyinput0;
    assign N725 = N725_plain ^  keyinput1;
    assign N726 = N726_plain ^  keyinput2;
    assign N727 = N727_plain ^  keyinput3;
    assign N728 = N728_plain ^  keyinput4;
    assign N729 = N729_plain ^  keyinput5;
    assign N730 = N730_plain ^  keyinput6;
    assign N731 = N731_plain ^  keyinput7;
    assign N732 = N732_plain ^  keyinput8;
    assign N733 = N733_plain ^  keyinput9;
    assign N734 = N734_plain ^  keyinput10;
    assign N735 = N735_plain ^  keyinput11;
    assign N736 = N736_plain ^  keyinput12;
    assign N737 = N737_plain ^  keyinput13;
    assign N738 = N738_plain ^  keyinput14;
    assign N739 = N739_plain ^  keyinput15;

    // Remaining outputs unchanged
    assign N740 = N740_plain;
    assign N741 = N741_plain;
    assign N742 = N742_plain;
    assign N743 = N743_plain;
    assign N744 = N744_plain;
    assign N745 = N745_plain;
    assign N746 = N746_plain;
    assign N747 = N747_plain;
    assign N748 = N748_plain;
    assign N749 = N749_plain;
    assign N750 = N750_plain;
    assign N751 = N751_plain;
    assign N752 = N752_plain;
    assign N753 = N753_plain;
    assign N754 = N754_plain;
    assign N755 = N755_plain;

endmodule
