module SoC(
    input wire clk,
    input wire rst,
    input wire key,
    output reg [15:0] led
);
	wire [31:0] instAddr;
    wire [31:0] instruction;
    wire romCe;

    wire memCe, memWr;    
    wire [31:0] memAddr;
    wire [31:0] rdData;
    wire [31:0] wtData;

	wire ramCe,ramWe,ioCe,ioWe;
	wire [31:0]ramWtData,ramAddr,ramRdData;
	wire [31:0]ioWtData,ioAddr,ioRdData;

	wire[5:0] intr;
	wire intimer;

	assign intr={5'b0,intimer};

	MIPS mips0(
        .clk(clk),
        .rst(rst),
        .instruction(instruction),	
		.romCe(romCe),
        .instAddr(instAddr),
		.rdData(rdData),        
		.wtData(wtData),        
		.memAddr(memAddr),        
		.memCe(memCe),        
		.memWr(memWr),
		.intr(intr),
		.intimer(intr[0])
	);	

	MIOC mioc0(
		.memCe(memCe),
		.memWr(memWr),
		.memAddr(memAddr),
		.wtData(wtData),
		.ramRdData(ramRdData),
		.ioRdData(ioRdData),
		.rdData(rdData),
		.ramCe(ramCe),
		.ramWe(ramWe),
		.ramAddr(ramAddr),
		.ramWtData(ramWtData),
		.ioCe(ioCe),
		.ioWe(ioWe),
		.ioAddr(ioAddr),
		.ioWtData(ioWtData)
	);

	InstMem instrom0(
        .ce(romCe),
        .addr(instAddr),
        .data(instruction)
	);

	DataMem datamem0(       
		.ce(ramCe),        
		.clk(clk),        
		.we(ramWe),        
		.addr(ramAddr),        
		.wtData(ramWtData),        
		.rdData(ramRdData)  
	);

	IO io0(
		.ce(ioCe),
		.clk(clk),
		.we(ioWe),
		.addr(ioAddr),
		.wtData(ioWtData),
		.rdData(ioRdData),
		/*IO interface*/
		.key(key),
		.led(led)
	);
endmodule
