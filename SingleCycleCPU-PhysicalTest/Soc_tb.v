`include "define.v"

module Soc_tb;

	reg clk;
	reg rst;
	wire key;
    wire[15:0] led;
	initial 
	begin
		clk = 0;
		rst = `RstEnable;
		#1000
		rst = `RstDisable;
		#10000	$stop;        
	end

	always #10 clk = ~ clk;

	SoC soc0(
        .out_clk(clk), 
        .rst(rst),
		.key(key),
		.led(led)
    );

endmodule