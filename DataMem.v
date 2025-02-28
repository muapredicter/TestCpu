`include "define.v"

// 数据存储器模块
module DataMem(
    input wire clk,         // 时钟信号
    input wire ce,          // 片选信号
    input wire we,          // 写使能信号
    input wire [31:0] addr, // 地址
    input wire [31:0] wtData, // 写入数据
    output reg [31:0] rdData // 读取数据
);

    reg [31:0] datamem [1023 : 0]; // 1024个32位存储器

    always@(*)
        if(ce == `RamDisable)
            rdData = `Zero; // 片选无效时输出0
        else
            rdData = datamem[addr[11 : 2]]; // 根据地址读取数据

    always@(posedge clk)
        if(ce == `RamEnable && we == `RamWrite)
            datamem[addr[11 : 2]] = wtData; // 写入数据
endmodule