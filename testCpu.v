`define RstEnable 1'b1
`define RstDisable 1'b0
`define RomEnable 1'b1
`define RomDisable 1'b0
`define Zero 0
`define Valid 1'b1
`define Invalid 1'b0

`define Nop 6'b000000

// ID begin
// I型指令
`define Inst_ori 6'b001101
`define Inst_andi 6'b001100
`define Inst_xori 6'b001110
`define Inst_addi 6'b001000
`define Inst_subi 6'b001001
`define Inst_lui 6'b001111

// R型指令
`define Inst_r 6'b000000 
`define Inst_or 6'b100101 
`define Inst_and 6'b100000 
`define Inst_xor 6'b100110
`define Inst_add 6'b100100
`define Inst_sll 6'b000000  
`define Inst_sub 6'b100010 
`define Inst_srl 6'b000010 
`define Inst_sra 6'b000011 

// J型指令

// ID end

// Ex操作
`define Or 6'b001101
`define And 6'b001100
`define Xor 6'b001110
`define Add 6'b001000
`define Sub 6'b001001
`define Lui 6'b001111
`define Sll 6'b000000
`define Subr 6'b100010
`define Srl 6'b000010
`define Sra 6'b000011


module IF(
    input wire clk,
    input wire rst,
    output reg ce, 
    output reg [31:0] pc
);
    always @(*) begin
        if (rst == `RstEnable)
            ce = `RomDisable;
        else
            ce = `RomEnable;
    end

    always @(posedge clk) begin
        if (ce == `RomDisable)
            pc = `Zero;
        else
            pc = pc + 4;
    end
endmodule

module ID (
    input wire rst,    
    input wire [31:0] inst,
    input wire [31:0] regaData_i,
    input wire [31:0] regbData_i,
    output reg [5:0] op,    
    output reg [31:0] regaData,
    output reg [31:0] regbData,
    output reg regaRead,
    output reg regbRead,
    output reg regcWrite,
    output reg [4:0] regaAddr,
    output reg [4:0] regbAddr,    
    output reg [4:0] regcAddr
);

    wire [5:0] inst_op = inst[31:26]; 
    wire [5:0] inst_func =inst[5:0];
    reg [31:0] imm;
    
    always @(*) begin
        if (rst == `RstEnable) begin
            op = `Nop;
            regaRead = `Invalid;
            regbRead = `Invalid;
            regcWrite = `Invalid;
            regaAddr = 5'h0;
            regbAddr = 5'h0;
            regcAddr = 5'h0;
            imm = `Zero;
        end else begin
            case (inst_op)
        `Inst_r: begin
        case(inst_func)
            `Inst_or: begin
            op = `Or;
                regaRead = `Valid;
                regbRead = `Valid;
                regcWrite = `Valid;
                regaAddr = inst[25:21]; 
                regbAddr = inst[20:16];
                regcAddr = inst[15:11]; 
                imm = `Zero;
            end
            `Inst_and: begin
                        op = `And; 
                        regaRead = `Valid;
                        regbRead = `Valid;
                        regcWrite = `Valid;
                        regaAddr = inst[25:21]; 
                        regbAddr = inst[20:16];
                        regcAddr = inst[15:11]; 
                        imm = `Zero;
                    end
                    `Inst_xor: begin
                        op = `Xor;
                        regaRead = `Valid;
                        regbRead = `Valid;
                        regcWrite = `Valid;
                        regaAddr = inst[25:21];
                        regbAddr = inst[20:16];
                        regcAddr = inst[15:11];
                        imm = `Zero;
                    end
                    `Inst_add: begin
                        op = `Add;
                        regaRead = `Valid;
                        regbRead = `Valid;
                        regcWrite = `Valid;
                        regaAddr = inst[25:21];
                        regbAddr = inst[20:16];
                        regcAddr = inst[15:11];
                        imm = `Zero;
                    end
                    `Inst_sub: begin
                        op = `Subr;
                        regaRead = `Valid;
                        regbRead = `Valid;
                        regcWrite = `Valid;
                        regaAddr = inst[25:21];
                        regbAddr = inst[20:16];
                        regcAddr = inst[15:11];
                        imm = `Zero;
                    end
                    `Inst_sll: begin
                        op = `Sll; 
                regaRead = `Invalid;
                        regbRead = `Valid; 
                        regcWrite = `Valid;
                        regaAddr = 5'h0;
                        regbAddr = inst[20:16];
                        regcAddr = inst[15:11];
                        imm = {27'h0, inst[10:6]};
                    end
                    `Inst_srl: begin
                        op = `Srl;
                        regaRead = `Invalid;
                        regbRead = `Valid;
                        regcWrite = `Valid;
                        regaAddr = 5'h0;
                        regbAddr = inst[20:16];
                        regcAddr = inst[15:11];
                        imm = {27'h0, inst[10:6]};
                    end
                    `Inst_sra: begin
                        op = `Sra;
                        regaRead = `Invalid;
                        regbRead = `Valid;
                        regcWrite = `Valid;
                        regaAddr = 5'h0;
                        regbAddr = inst[20:16];
                        regcAddr = inst[15:11];
                        imm = {27'h0, inst[10:6]};
                    end

            default: begin
                    op = `Nop;
                    regaRead = `Invalid;
                    regbRead = `Invalid;
                    regcWrite = `Invalid;
                    regaAddr = 5'h0;
                    regbAddr = 5'h0;
                    regcAddr = 5'h0;
                    imm = `Zero;    
            end         
        endcase
        end            
        `Inst_ori: begin
                    op = `Or;
                    regaRead = `Valid;
                    regbRead = `Invalid;
                    regcWrite = `Valid;
                    regaAddr = inst[25:21];
                    regbAddr = 5'h0;
                    regcAddr = inst[20:16];
                    imm = {16'h0, inst[15:0]};
                end
                `Inst_andi: begin
                    op = `And;
                    regaRead = `Valid;
                    regbRead = `Invalid;
                    regcWrite = `Valid;
                    regaAddr = inst[25:21];
                    regbAddr = 5'h0;
                    regcAddr = inst[20:16];
                    imm = {16'h0, inst[15:0]};
                end
                `Inst_xori: begin
                    op = `Xor;
                    regaRead = `Valid;
                    regbRead = `Invalid;
                    regcWrite = `Valid;
                    regaAddr = inst[25:21];
                    regbAddr = 5'h0;
                    regcAddr = inst[20:16];
                    imm = {16'h0, inst[15:0]};
                end
                `Inst_addi: begin
                    op = `Add;
                    regaRead = `Valid;
                    regbRead = `Invalid;
                    regcWrite = `Valid;
                    regaAddr = inst[25:21];
                    regbAddr = 5'h0;
                    regcAddr = inst[20:16];
                    imm = {{16{inst[15]}}, inst[15:0]};
                end
                `Inst_subi: begin
                    op = `Sub;
                    regaRead = `Valid;
                    regbRead = `Invalid;
                    regcWrite = `Valid;
                    regaAddr = inst[25:21];
                    regbAddr = 5'h0;
                    regcAddr = inst[20:16];
                    imm = {16'h0, inst[15:0]};
                end
                `Inst_lui: begin
                    op = `Lui;
                    regaRead = `Valid;
                    regbRead = `Invalid;
                    regcWrite = `Valid;
                    regaAddr = inst[25:21];
                    regbAddr = 5'h0;
                    regcAddr = inst[20:16];
                    imm = {inst[15:0], 16'h0}; 
                end
                default: begin
                    op = `Nop;
                    regaRead = `Invalid;
                    regbRead = `Invalid;
                    regcWrite = `Invalid;
                    regaAddr = 5'h0;
                    regbAddr = 5'h0;
                    regcAddr = 5'h0;
                    imm = `Zero;
                end
            endcase
        end
    end

    always @(*) begin
        if (rst == `RstEnable)
            regaData = `Zero;
        else if (regaRead == `Valid)
            regaData = regaData_i;
        else
            regaData = imm;
    end

    always @(*) begin
        if (rst == `RstEnable)
            regbData = `Zero;
        else if (regbRead == `Valid)
            regbData = regbData_i;
        else
            regbData = imm;
    end
endmodule

module EX (
    input wire rst,
    input wire [5:0] op,
    input wire [31:0] regaData,
    input wire [31:0] regbData,
    input wire regcWrite_i,
    input wire [4:0] regcAddr_i,
    output reg [31:0] regcData,
    output reg regcWrite,
    output reg [4:0] regcAddr
);

    always @(*) begin
        if (rst == `RstEnable)
            regcData = `Zero;
        else begin
            case (op)
                `Or:
                    regcData = regaData | regbData;
                `And:
                    regcData = regaData & regbData;
                `Xor:
                    regcData = regaData ^ regbData;
                `Add:
                    regcData = regaData + regbData; 
                `Sub:
                    regcData = regaData - regbData; 
                `Lui:
                    regcData = regbData; 
                `Subr:
                    regcData = regaData - regbData;
                `Sll:
                regcData = regbData << regaData; 
                `Srl:
                regcData = regbData >> regaData;
                `Sra:
                regcData = $signed(regbData) >>> regaData; 

    default:
                    regcData = `Zero;
            endcase
        end

        regcWrite = regcWrite_i;
        regcAddr = regcAddr_i;
    end
endmodule

module RegFile(
    input wire clk,
    input wire rst,
    input wire we,
    input wire [4:0] waddr,
    input wire [31:0] wdata,
    input wire regaRead,
    input wire regbRead,
    input wire [4:0] regaAddr,
    input wire [4:0] regbAddr,
    output reg [31:0] regaData,
    output reg [31:0] regbData
);
    reg [31:0] reg32 [31 : 0];
    always@(*)
        if(rst == `RstEnable)          
            regaData = `Zero;
        else if(regaAddr == `Zero)
            regaData = `Zero;
        else
            regaData = reg32[regaAddr];
    always@(*)
        if(rst == `RstEnable)          
            regbData = `Zero;
        else if(regbAddr == `Zero)
            regbData = `Zero;
        else    
            regbData = reg32[regbAddr];
    always@(posedge clk)
        if(rst == `RstDisable)
            if((we == `Valid) && (waddr != `Zero))
                reg32[waddr] = wdata;
        else ; 
endmodule

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
    wire [5:0] op;    
    wire regaRead, regbRead;
    wire [4:0] regaAddr, regbAddr;
    wire regcWrite_id, regcWrite_ex;
    wire [4:0] regcAddr_id, regcAddr_ex;

    IF if1(
    .clk(clk),
    .rst(rst),
    .ce(romCe), 
    .pc(instAddr)
    );

    ID id1(
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

    EX ex1(
    .rst(rst),
    .op(op),        
    .regaData(regaData_id),
    .regbData(regbData_id),
    .regcWrite_i(regcWrite_id),
    .regcAddr_i(regcAddr_id),
    .regcData(regcData_ex),
    .regcWrite(regcWrite_ex),
    .regcAddr(regcAddr_ex)
    );

    RegFile regfile1(
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

endmodule

module InstMem(
    input wire ce,
    input wire [31:0] addr,
    output reg [31:0] data
);

    reg [31:0] instmem [1023 : 0];

    always @(*) begin
        if (ce == `RomDisable)
            data = `Zero;
        else
            data = instmem[addr[11 : 2]];
    end

    initial begin
        instmem [0] = 32'h34011100; // 001101|00000|00001| 0001 0001 0000 0000 #ori  $1 $0 0001 0001 0000 0000
        instmem [1] = 32'h30020020; // 001100|00000|00010| 0000 0000 0010 0000 #andi $2 $0 0000 0000 0010 0000
        instmem [2] = 32'h3803ff00; // 001110|00000|00011| 1111 1111 0000 0000 #xori $3 $0 1111 1111 0000 0000
        instmem [3] = 32'h2004ffff; // 001000|00000|00100| 1111 1111 1111 1111 #addi $4 $0 1111 1111 1111 1111
        instmem [4] = 32'h2405ffff; // 001001|00000|00101| 1111 1111 1111 1111 #subi $5 $0 1111 1111 1111 1111
        instmem [5] = 32'h3C06ffff; // 001111|00000|00110| 1111 1111 1111 1111 #lui  $6 $0 1111 1111 1111 1111

        instmem [6] ={`Inst_r, 5'b00001, 5'b00010, 5'b00111, 5'b00000, `Inst_or};    // #or  $7  $1 $2
        instmem [7] = {`Inst_r, 5'b00010, 5'b00011, 5'b01000, 5'b00000, `Inst_and};  // #and $8  $2 $3
        instmem [8] = {`Inst_r, 5'b00011, 5'b00100, 5'b01001, 5'b00000, `Inst_xor};  // #xor $9  $3 $4
        instmem [9] = {`Inst_r, 5'b00100, 5'b00101, 5'b01010, 5'b00000, `Inst_add};  // #add #10 $4 $5
        instmem [10] = {`Inst_r, 5'b00101, 5'b00110, 5'b01011, 5'b00000, `Inst_sub}; // #sub #11 $5 $6

        instmem [11] = {`Inst_r, 5'b00110, 5'b00000, 5'b01100, 5'b00000, `Inst_sll}; // #sll #12 #0 << 0
        instmem [12] = {`Inst_r, 5'b00111, 5'b00000, 5'b01101, 5'b00000, `Inst_srl}; // #srl #13 #0 >>> 0
        instmem [13] = {`Inst_r, 5'b01000, 5'b00000, 5'b01110, 5'b00000, `Inst_sra}; // #sra #14 #0 >> 0

    end
endmodule

module SoC(
    input wire clk,
    input wire rst
);

    wire [31:0] instAddr;
    wire [31:0] instruction;
    wire romCe;

    MIPS mips1(
    .clk(clk),
    .rst(rst),
    .instruction(instruction),
    .instAddr(instAddr),
    .romCe(romCe)
    );

    InstMem instrom1(
    .ce(romCe),
    .addr(instAddr),
    .data(instruction)
    );

endmodule

module soc_tb;

    reg clk;
    reg rst;

    initial begin
        clk = 0;
        rst = `RstEnable;
        #100
        rst = `RstDisable;
        #1000 $stop;
    end

    always #10 clk = ~ clk;

    SoC soc(
    .clk(clk), 
    .rst(rst)
    );

endmodule
