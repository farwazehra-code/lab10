`timescale 1ns / 1ps
// Checks that instructionMemory returns exactly the words written in program.mem.
module tb_instructionmem;
    reg  [31:0] instAddress;
    wire [31:0] instruction;
    reg  [31:0] expected [0:63];     // program.mem read directly, for comparison
    integer i, errors, count;

    instructionMemory #(.SIM_FAST(0)) dut (
        .instAddress(instAddress),
        .instruction(instruction)
    );

    initial begin
        errors = 0;
        count  = 0;
        for (i = 0; i < 64; i = i + 1) expected[i] = 32'h0;
        $readmemh("mem.mem", expected);

        for (i = 0; i < 64; i = i + 1) begin
            instAddress = i * 4;
            #1;
            if (instruction !== expected[i]) begin
                $display("FAIL : PC=0x%03h  got %h  expected %h", instAddress, instruction, expected[i]);
                errors = errors + 1;
            end else if (expected[i] !== 32'h0) begin
                $display("OK   : PC=0x%03h  instruction = %h", instAddress, instruction);
                count = count + 1;
            end
        end

        $display("-----------------------------------------");
        $display("%0d instructions checked, %0d errors", count, errors);
        if (errors == 0) $display("=== INSTRUCTION MEMORY CORRECT ===");
        else             $display("=== INSTRUCTION MEMORY HAS ERRORS ===");
        $finish;
    end
endmodule