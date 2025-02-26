`include "define.v"

module Ctrl(
	input wire rst,				
	input wire[31:0] excptype,
	input wire [31:0] epc,	// 异常处理程序的返回地址
	output reg [31:0] ejpc, // 异常处理程序的跳转地址		
	output reg excpt		
);
	always@(*)
		if(rst == `RstEnable)
			begin
				excpt = `Invalid;
				ejpc = `Zero;
			end
		else
			begin
				excpt = `Valid;
				case(excptype)
					//将定时器时钟中断处理程序存在于地址00000050处
					32'h0000_0004:
						ejpc = 32'h00000050; // 0101 0000
					//Syscall
					32'h0000_0100:
						ejpc= 32'h000000DC; // 1101 1100
					//Eret
					32'h0000_0200:
						ejpc = epc;
					default:
						begin
							ejpc= `Zero;
							excpt = `Invalid;
						end
				endcase
			end
endmodule

