`include "define.v"

module MIPS(
    input wire clk,
    input wire rst,
    input wire [31:0] instruction,
    output wire romCe,
    output wire [31:0] instAddr
);

    wire [31:0] regaData_regFile, regbData_regFile;
    wire [31:0] regaData_id, regbData_id; 
    wire [31:0] regcData_ex;
    wire [5:0] op_id;    
    wire regaRead, regbRead;
    wire [4:0] regaAddr, regbAddr;
    wire regcWrite_id, regcWrite_ex;
    wire [4:0] regcAddr_id, regcAddr_ex;

    wire [31:0] wHiData_ex;
	wire [31:0] wLoData_ex;
	wire whi;
	wire wlo;
	wire [31:0] rHiData_ex;
	wire [31:0] rLoData_ex;

    wire excpt;
	wire wbit;
	wire wLLbit;
	wire rLLbit;

    IF if0(
    .clk(clk),
    .rst(rst),
    .ce(romCe), 
    .pc(instAddr)
    );

    ID id0(
    .rst(rst),        
    .inst(instruction),
    .regaData_i(regaData_regFile),
    .regbData_i(regbData_regFile),
    .op(op),
    .regaData(regaData_id),
    .regbData(regbData_id),
    .regaRead(regaRead),
    .regbRead(regbRead),
    .regaAddr(regaAddr),
    .regbAddr(regbAddr),
    .regcWrite(regcWrite_id),
    .regcAddr(regcAddr_id)
    );

    EX ex0(
    .rst(rst),
    .op_i(op),        
    .regaData(regaData_id),
    .regbData(regbData_id),
    .regcWrite_i(regcWrite_id),
    .regcAddr_i(regcAddr_id),
    .regcData(regcData_ex),
    .regcWrite(regcWrite_ex),
    .regcAddr(regcAddr_ex)
    );

    RegFile regfile0(
    .clk(clk),
    .rst(rst),
    .we(regcWrite_ex),
    .waddr(regcAddr_ex),
    .wdata(regcData_ex),
    .regaRead(regaRead),
    .regbRead(regbRead),
    .regaAddr(regaAddr),
    .regbAddr(regbAddr),
    .regaData(regaData_regFile),
    .regbData(regbData_regFile)
    );

    HiLo hilo0(
	.rst(rst),
	.clk(clk),
	.wHiData(wHiData_ex),
	.wLoData(wLoData_ex),
	.whi(whi_ex),
	.wlo(wlo_ex),
	.rHiData(rHiData_ex),
	.rLoData(rLoData_ex)
	);

    MEM mem0(
    .rst(rst),
    .op(op),
    )

    LLbit llbit0(
    .clk(clk),
    .rst(rst),
    .excpt(excpt),
    .wbit(wbit), 
    .wLLbit(wLLbit),
    .rLLbit(rLLbit)
    );

endmodule