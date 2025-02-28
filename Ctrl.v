`include "define.v"

// 控制模块：处理异常和跳转
module Ctrl(
    input wire rst,             // 复位信号
    input wire[31:0] excptype,  // 异常类型
    input wire [31:0] epc,      // 异常程序计数器
    output reg [31:0] ejpc,     // 异常跳转地址
    output reg excpt            // 异常信号
);

    always@(*)
        if(rst == `RstEnable) begin
            // 复位时初始化
            excpt = `Invalid;
            ejpc = `Zero;
        end else begin
            excpt = `Valid;
            case(excptype)
                32'h0000_0004: ejpc = 32'h00000050; // 定时器中断跳转地址
                32'h0000_0100: ejpc = 32'h000000DC; // 系统调用跳转地址
                32'h0000_0200: ejpc = epc; // 异常返回地址
                default: begin
                    ejpc = `Zero;
                    excpt = `Invalid;
                end
            endcase
        end
endmodule