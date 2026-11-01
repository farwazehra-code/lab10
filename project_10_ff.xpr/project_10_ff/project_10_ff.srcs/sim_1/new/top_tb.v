`timescale 1ns/1ps
module tb_lab10;
  reg clk=0, btnC=0, btnU=0; reg [15:0] sw=0; wire [15:0] led;
  lab10_top #(.SIM_FAST(1)) dut(.clk(clk),.btnC(btnC),.btnU(btnU),.sw(sw),.led(led));
  always #5 clk = ~clk;
  initial begin
    #2000   sw = 16'd5;      // start countdown from 5
    #500    sw = 16'd0;      // ignored: countdown must keep going
    #100000;                 // let it finish (~17 us per step)
    sw = 16'd8;              // second run
    #40000  btnC = 1;        // reset mid-countdown
    #3000   btnC = 0;        // hold btnC for at least ~1 us so the 2-flop sync and polling see it
    sw = 0;
    #10000  $finish;
  end
endmodule