`include "define.v"

// DataMem模块 数据存储器 服务于Lw和Sw
module DataMem(
        input wire clk,
        input wire ce,
        input wire we,
        input wire [31:0] wtData,
        input wire [31:0] addr,
        output reg [31:0] rdData
);
    reg [31:0] datamem [1023 : 0];
    always@(*)      
        if(ce == `RamDisable)
            rdData = `Zero;
        else
            rdData = datamem[addr[11 : 2]]; 
    always@(posedge clk)
        if(ce == `RamEnable && we == `RamWrite)
            datamem[addr[11 : 2]] = wtData;
        else 
            ;
endmodule