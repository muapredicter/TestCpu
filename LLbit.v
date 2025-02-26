`include "define.v"

module LLbit(
	input wire clk,
	input wire rst,
	input wire excpt,
	input wire wbit, 	// rt 
	input wire wLLbit,	// EX执行后对LLbit的修改 服务于ll指令
	output reg rLLbit	// 给EX模块的LLbit 服务于sc指令
);

	reg LLbit;

	always@(*)
        if(rst == `RstEnable)
            rLLbit = `Zero;
        else
            rLLbit = LLbit;

    always@(posedge clk)
        if(rst ==`RstDisable && wbit==`Valid)
            LLbit=wLLbit;
        else 
            ;
endmodule