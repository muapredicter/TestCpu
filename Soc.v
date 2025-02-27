module SoC(
    input wire clk,
    input wire rst
);

// MIPS
wire romCe;
wire [31:0] instAddr;
wire [31:0] wtData;
wire [31:0] memAddr;
wire memCe;
wire memWr;

// InstMem
wire [31:0] instruction;

// DataMem
wire [31:0] rdData;

// CP0
wire [5:0] intr;
wire intimer;
assign intr={5'b0,intimer};

MIPS mips0(
    .clk(clk),
    .rst(rst),
    .instruction(instruction),
    .rdData(rdData),
    .romCe(romCe),
    .instAddr(instAddr),
    .wtData(wtData),
    .memAddr(memAddr),
    .memCe(memCe),
    .memWr(memWr),
    .intr(intr),
    .intimer(intimer)
);

InstMem instrom0(
    .ce(romCe),
    .addr(instAddr),
    .data(instruction)
);

DataMem datamem0(
    .clk(clk),
    .ce(memCe),
    .we(memWr),
    .wtData(wtData),
    .addr(memAddr),
    .rDdata(rdData)
); 

endmodule
