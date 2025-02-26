`include "define.v"

module soc_tb;

    reg clk;
    reg rst;

    initial begin
        clk = 0;
        rst = `RstEnable;
        #100
        rst = `RstDisable;
        #1000 $stop;
    end

    always #10 clk = ~ clk;

    SoC soc(
    .clk(clk), 
    .rst(rst)
    );

endmodule