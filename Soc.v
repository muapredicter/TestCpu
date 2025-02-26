`include "define.v"

module SoC(
    input wire clk,
    input wire rst
);

    wire [31:0] instAddr;
    wire [31:0] instruction;
    wire romCe;

    wire memCe, memWr;    
    wire [31:0] memAddr;
    wire [31:0] rdData;
    wire [31:0] wtData;


    MIPS mips0(
    .clk(clk),
    .rst(rst),
    .instruction(instruction),
    .instAddr(instAddr),
    .romCe(romCe)
    .rdData(rdData),        
    .wtData(wtData),        
    .memAddr(memAddr),        
    .memCe(memCe),        
    .memWr(memWr)    
    );

    InstMem instrom0(
    .ce(romCe),
    .addr(instAddr),
    .data(instruction)
    );

    DataMem datamem0(       
    .ce(memCe),        
    .clk(clk),        
    .we(memWr),        
    .addr(memAddr),        
    .rdData(rdData),        
    .wtData(wtData)   
);


endmodule
