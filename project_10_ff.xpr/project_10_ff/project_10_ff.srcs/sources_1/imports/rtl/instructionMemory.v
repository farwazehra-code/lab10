`timescale 1ns / 1ps
module instructionMemory #(
    parameter OPERAND_LENGTH = 31,
    parameter SIM_FAST       = 0
)(
    input      [OPERAND_LENGTH:0] instAddress,
    output     [31:0]             instruction
);
    reg [7:0]  memory [0:255];     // byte memory used by the processor
    reg [31:0] words  [0:63];      // temporary: one instruction per line of program.mem
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1) words[i] = 32'h00000000;   // clear
        $readmemh("mem.mem", words);                          // load the file

        // split every 32-bit instruction into 4 bytes (lowest byte first)
        for (i = 0; i < 64; i = i + 1) begin
            memory[4*i]     = words[i][7:0];
            memory[4*i + 1] = words[i][15:8];
            memory[4*i + 2] = words[i][23:16];
            memory[4*i + 3] = words[i][31:24];
        end

        // Simulation only: replace the delay constant (2,500,000) with 40
        if (SIM_FAST) begin
            memory[100] = 8'hB7; memory[101] = 8'h02; memory[102] = 8'h00; memory[103] = 8'h00;
            memory[104] = 8'h93; memory[105] = 8'h82; memory[106] = 8'h82; memory[107] = 8'h02;
        end
    end

    // Use the PC (aligned to 4 bytes) and join 4 bytes into one instruction
    wire [7:0] a = {instAddress[7:2], 2'b00};
    assign instruction = {memory[a + 8'd3], memory[a + 8'd2], memory[a + 8'd1], memory[a]};
endmodule