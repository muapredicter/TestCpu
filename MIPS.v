`include "define.v"

module MIPS(
    input wire clk,
    input wire rst,
    input wire [31:0] instruction,    /// 指令内容
    input wire [31:0] rdData, // ll & sc
    output wire romCe,
    output wire [31:0] instAddr, // 指令地址
    // ll & sc
    output wire [31:0] wtData, 
    output wire [31:0] memAddr, 
    output wire memCe,
    output wire memWr
    // 异常处理
    input wire [31:0] ejpc,
    input wire excpt, 
);

// IF
wire [31:0] jAddr;
wire jCe; 

// ID
wire [5:0] op_id;
wire [31:0] regaData_id, regbData_id;
wire regaRead, regbRead;
wire regcWrite_id;
wire [4:0] regaAddr, regbAddr;
wire [4:0] regcAddr_id;
wire [31:0] excptype_id;
wire [31:0] pc_id;

// EX
wire [31:0] regcData_ex;
wire regcWrite_ex;
wire [4:0] regcAddr_ex;
wire [5:0] op_ex;
wire [31:0] memAddr_ex, memData_ex;
wire whi_ex, whi_ex;
wire [31:0] wHiData_ex, wHiData_ex;
wire [31:0] pc_ex;
wire [31:0] excptype_ex;
wire [31:0] pc_ex;

// MEM
wire [31:0] rdData_datamem;
wire [4:0] regAddr_mem;
wire regWr_mem;
wire [31:0] regData_mem;
wire [31:0] memAddr_mem;
wire [31:0] wtData_mem;
wire memWr_mem;
wire memCe_mem;
wire wbit_mem;
wire wLLbit_mem;

// RegFile
wire [31:0] regaData_regFile, regbData_regFile;

// LLbit
wire rLLbit_llbit;
wire excpt;

// HiLo
wire [31:0] rHiData_hilo,rHiData_hilo;

// CP0
wire cp0we;
wire [31:0] cp0wData;
wire [4:0] cp0Addr;
wire [31:0] cp0rData;
wire [31:0] cause;
wire [31:0] status;

// Ctrl
wire [31:0] ejpc;


IF if0(
    .clk(clk),
    .rst(rst),
    .jAddr(jAddr),
    .jCe(jCe),
    .ce(romCe),
    .pc(instAddr)
);

ID id0(
    .rst(rst),
    .pc_i(instAddr),
    .inst(instruction),
    .regaData_i(regaData_regFile),
    .regaData_i(regbData_regFile),
    .op(op_id),
    .regaData(regaData_id),
    .regbData(regbData_id),
    .regaRead(regaRead),
    .regbRead(regaRead),
    .regcWrite(regcWrite_id),
    .regaAddr(regaAddr),
    .regbAddr(regbAddr),
    .regcAddr(regcAddr_id),
    .jAddr(jAddr),
    .jCe(jCe)
);

EX ex0(
    .rst(rst),
    .op_i(op_id),
    .regaData(regaData_id),
    .regbData(regbData_id),
    .regcWrite_i(regcWrite_id),
    .regcAddr_i(regcAddr_id),
    .regcData(regcData_ex),
    .regcWrite(regcWrite_ex),
    .regcAddr(regcAddr_ex),
    .op(op_ex),
    .memAddr(memAddr_ex),
    .memData(memData_ex),
    .rHiData(rHiData_hilo),
    .rLoData(rLoData_hilo),
    .whi(whi_ex),
    .wlo(whi_ex),
    .wHiData(wHiData_ex),
    .wLoData(wHiData_ex)
);

MEM mem0(
    .rst(rst),
    .op(op_ex),
    .regcData(regcData_ex),
    .regcAddr(regcAddr_ex),
    .regcWr(regcWrite_ex),
    .memAddr_i(memAddr_ex),
    .memData(memData_ex),
    .rdData(rdData_datamem),
    .rLLbit(rLLbit_llbit),
    .regAddr(regAddr_mem),
    .regWr(regWr_mem),
    .regData(regData_mem),
    .memAddr(memAddr_mem),
    .wtData(wtData_mem),
    .memWr(memWr_mem),
    .memCe(memCe_mem),
    .wbit(wbit_mem),
    .wLLbit(wLLbit_mem)
);

RegFile regfile0(
    .clk(clk),
    .rst(rst),
    .we(regWr_mem),
    .waddr(regAddr_mem),
    .wdata(regData_mem),
    .regaRead(regaRead),
    .regbRead(regbRead),
    .regaAddr(regaAddr),
    .regbAddr(regbAddr),
    .regaData(regaData_regFile),
    .regbData(regbData_regFile)
);

LLbit llbit0(
    .clk(clk),
    .rst(rst),
    .excpt(excpt),
    .wbit(wbit_mem),
    .wLLbit(wLLbit_mem),
    .rLLbit(rLLbit_hilo)
);

HiLo hilo0(
    .rst(rst),
    .clk(clk),
    .wHiData(whiData_ex),
    .wLoData(wloData_ex),
    .whi(whi_ex),
    .wlo(wlo_ex),
    .rHiData(rHiData_hilo),
    .rLoData(rLoData_hilo)
);

endmodule