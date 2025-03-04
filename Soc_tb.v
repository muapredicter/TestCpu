`include "define.v"

module Soc_tb;

	reg clk;
	reg rst;
	wire[1:0] key;
    wire[15:0] led;
	initial 
	begin
		clk = 0;
		rst = `RstEnable;
		#100
		rst = `RstDisable;
		#1000 	$stop;        
	end

	always #10 clk = ~ clk;

	SoC soc0(
        .clk(clk), 
        .rst(rst),
		.key(key),
		.led(led)
    );

endmodule