module MIOC(
    input wire memCe,
    input wire memWr,
    input wire [31:0] memAddr,
    input wire [31:0] wtData,
    input wire [31:0] ramRdData,
    input wire [31:0] ioRdData,
    output reg [31:0] rdData,
    output reg ramCe,
    output reg ramWe,
    output reg [31:0] ramAddr,
    output reg [31:0] ramWtData,
    output reg ioCe,
    output reg ioWe,
    output reg [31:0] ioAddr,
    output reg [31:0] ioWtData
);
if(memCe==`RamEnable)
    if(memAddr & 32'hF000_0000==32'h7000_0000)
    begin
        ioCe = `RamEnable;
        ioWe = memWr;
        ioAddr = memAddr;
        ramCe = `RamDisable;
        ramWe = `RamUnWrite;
        ramAddr = `Zero;
    end
endmodule