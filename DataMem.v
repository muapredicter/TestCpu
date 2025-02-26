`include "define.v"

// DataMem模块 数据存储器 服务于Lw和Sw
module DataMem(
        input wire clk,
        input wire ce,
        input wire we,
        input wire [31:0] addr,
        input wire [31:0] dataIn,
        output reg [31:0] dataOut
);
    reg [31:0] datamem [1023 : 0];
    always@(*)      
        if(ce == `RamDisable)
            dataout = `Zero;
        else
            dataout = datamem[addr[11 : 2]]; 
    always@(posedge clk)
        if(ce == `RamEnable && we == `RamWrite)
            datamem[addr[11 : 2]] = datain;
        else 
            ;
endmodule