`define RstEnable 1'b1
`define RstDisable 1'b0
`define RomEnable 1'b1
`define RomDisable 1'b0
`define Zero 0
`define Valid 1'b1
`define Invalid 1'b0

`define RamDisable 1`b0 
`define RamEnable 1`b1
`define RamUnWrite 1`b0
`define RamWrite 1`b1

// ID begin
// I型指令
`define Inst_ori 6'b001101
`define Inst_andi 6'b001100
`define Inst_xori 6'b001110
`define Inst_addi 6'b001000
`define Inst_subi 6'b001001
`define Inst_lui 6'b001111

// lw & sw
`define Inst_lw 6'b100011
`define Inst_sw 6'b101011

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

// 乘除指令
`define Inst_mult 6`b011000 // 带符号数
`define Inst_multu 6`b011001 // 无符号数
`define Inst_div 6`b011010 // 带符号数
`define Inst_divu 6`b011011 // 无符号数

// J型指令
`define Inst_j   6'b000110
`define Inst_jal 6'b000101
`define Inst_jr  6'b001000
`define Inst_jalr 6'b001001
`define Inst_beq  6'b010000
`define Inst_bne  6'b010001
`define Inst_bltz 6'b010010
`define Inst_bgtz 6'b010011
// ID end

// Ex操作
`define Nop 6'b000000 
`define Or  6'b000001
`define And 6'b000010
`define Xor 6'b000011
`define Add 6'b000100
`define Sub 6'b000101
`define Lui 6'b100000

`define Sll 6'b000110
`define Srl 6'b000111
`define Sra 6'b001000

`define J   6'b001001
`define Jal 6'b001010
`define Jr  6'b001011

`define Beq 6'b001100
`define Bne 6'b001101
`define Bgtz 6'b001110
`define Bltz 6'b001111

`define Lw 6'b010000
`define Sw 6'b010001

`define Mult 6`b010010
`define Multu 6`b010011
`define Div 6`b010100
`define Divu 6`b010101

module IF(
    input wire clk,
    input wire rst,
    input wire [31:0] jAddr,
    input wire jCe,
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
        else if(jCe == 'Valid)
            pc =  jAddr;
        else
            pc = pc + 4;
    end
endmodule

module ID (
    input wire rst,    
    input wire [31:0] pc,	
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
    output reg [4:0] regcAddr,
    output reg [31:0] jAddr,	
    output reg jCe
);
    wire [31:0] npc = pc + 4;
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
            jCe = `Invalid;
            jAddr = `Zero;
        end 
        else begin
            jCe = `Invalid;
            jAddr = `Zero;
            case (inst_op) // R型指令
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
                        `Inst_mult: begin
                            op = `Mult;
                            regaRead = `Valid;
                            regbRead = `Valid;
                            regcWrite = `Zero;
                            regaAddr = inst[25:21];
                            regbAddr = inst[20:16];
                            regcAddr = `Zero;
                            imm = `Zero;
                        end
                        `Inst_multu: begin 
                            op = `Multu;
                            regaRead = `Valid;
                            regbRead = `Valid;
                            regcWrite = `Zero;
                            regaAddr = inst[25:21];
                            regbAddr = inst[20:16];
                            regcAddr = `Zero;
                            imm = `Zero;
                        end 
                        `Inst_div: begin
                            op = `Div;
                            regaRead = `Valid;
                            regbRead = `Valid;
                            regcWrite = `Zero;
                            regaAddr = inst[25:21];
                            regbAddr = inst[20:16];
                            regcAddr = `Zero;
                            imm = `Zero;
                        end
                        `Inst_divu: begin
                            op = `Divu;
                            regaRead = `Valid;
                            regbRead = `Valid;
                            regcWrite = `Zero;
                            regaAddr = inst[25:21];
                            regbAddr = inst[20:16];
                            regcAddr = `Zero;
                            imm = `Zero;
                        end
                        `Inst_jr: begin
					   	    op = `J;
					   	    regaRead = `Valid;
					   	    regbRead = `Invalid;
						    regcWrite = `Invalid;
				   		    regaAddr = inst[25:21];
					  	    regbAddr = `Zero;
					 	    regcAddr = `Zero;
				   		    jAddr = regaData;//regaData=(regaAddr)
			        	    jCe = `Valid;
				   		    imm = `Zero;
				 		end
					    `Inst_jalr:begin
					   	    op = `Jal;
					   	    regaRead = `Valid;
					   	    regbRead = `Invalid;
					   	    regcWrite = `Valid;
				   		    regaAddr = inst[25:21];
					   	    regbAddr = `Zero;
					  	    regcAddr = 5'b11111;
				   		    jAddr = regaData;
			                jCe = `Valid;
				   		    imm = npc;
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
        `Inst_lw: begin
                    op = `Lw;
                    regaRead = `Valid;
                    regbRead  = `Invalid;
                    regcWrite = `Valid;
                    regaAddr = inst[25:21];
                    regbAddr = `Zero;
                    regcAddr = inst[20:16];
                    imm = {{16{inst[15]}},inst[15:0]};
                end
        `Inst_sw: begin
                    op = `Sw;
                    regaRead = `Valid;
                    regbRead = `Valid;
                    regcWrite = `Invalid;
                    regaAddr = inst[25:21];
                    regbAddr = inst[20:16];
                    regcAddr = `Zero;
                    imm = {{16{inst[15]}},inst[15:0]};
                end 
        `Inst_j: begin // j型指令
                    op = `J;
                    regaRead = `Invalid;
				    regbRead = `Invalid;
				    regcWrite = `Invalid;
				    regaAddr = `Zero;
				    regbAddr = `Zero;
                    regcAddr = `Zero;
                    jAddr = {npc[31:28], inst[25:0], 2'b00};
			        jCe = `Valid;
                    imm = `Zero;
                end
        `Inst_jal: begin
                    op = `Jal;
				    regaRead = `Invalid;
				    regbRead = `Invalid;
				    regcWrite = `Valid;
				    regaAddr = `Zero;
				    regbAddr = `Zero;
				    regcAddr = 5'b11111;
				    jAddr = {npc[31:28], inst[25:0], 2'b00};
			        jCe = `Valid;
				    imm = npc;
                end
        `Inst_beq: begin
                    op = `Beq;
					regaRead = `Valid;
					regbRead = `Valid;
					regcWrite = `Invalid;
					regaAddr = inst[25:21];
					regbAddr = inst[20:16];
					regcAddr = `Zero;
					jAddr = npc + {{14{inst[15]}},inst[15:0], 2'b00};		
					if(regaData == regbData)
					    jCe = `Valid;
					else
						jCe = `Invalid;
					imm = `Zero;
                end
        `Inst_bne:begin
					op = `Bne;
					regaRead = `Valid;
					regbRead = `Valid;
					regcWrite = `Invalid;
					regaAddr = inst[25:21];
					regbAddr = inst[20:16];
					regcAddr = `Zero;
					jAddr = npc + {{14{inst[15]}}, inst[15:0], 2'b00};		
					if(regaData != regbData)
				        jCe = `Valid;
					else
					    jCe = `Invalid;
					   	imm = `Zero;
				end		
		`Inst_bltz:begin
					op = `Bltz;
					regaRead = `Valid;
					regbRead = `Valid;
					regcWrite = `Invalid;
					regaAddr = inst[25:21];
					regbAddr = inst[20:16];
					regcAddr = `Zero;
					jAddr = npc+{{14{inst[15]}},inst[15:0], 2'b00};
					if(regaData<regbData)
				        jCe = `Valid;
					else
					    jCe = `Invalid;
					   	imm = 32'b0;
				end		
		`Inst_bgtz:begin
					op = `Bgtz;
					regaRead = `Valid;
					regbRead = `Invalid;
					regcWrite = `Invalid;
					regaAddr = inst[25:21];
					regbAddr = inst[20:16];
					regcAddr = `Zero;
					jAddr = npc+{{14{inst[15]}},inst[15:0], 2'b00};		
					if(regaData>regbData)
				        jCe = `Valid;//????
					else
						jCe = `Invalid;
					   	imm = 32'b0;
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
        else if(op == `Lw || op == `Sw)               
            regaData = regaData_i + imm;      
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
    input wire [5:0] op_i,
    input wire [31:0] regaData,
    input wire [31:0] regbData,
    input wire regcWrite_i,
    input wire [4:0] regcAddr_i,
    output reg [31:0] regcData,
    output reg regcWrite,
    output reg [4:0] regcAddr
    // lw&sw指令添加
    output reg [5:0] op,
    output wire [31:0] memAddr,
    output wire [31:0] memData

);
    assign op = op_i;
    assign memAddr = regaData;
    assign memData = regbData;

    always @(*) begin
        if (rst == `RstEnable)
            regcData = `Zero;
        else begin
            case (op_i)
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
                //j型指令
                `J:
                regcData = `Zero;
		        `Jal:
                regcData = regbData;
		        `Beq:
		        regcData = `Zero;
	            `Bne:
		        regcData = `Zero;
		        `Bltz:
		        regcData = `Zero;
		        `Bgtz:
		        regcData = `Zero;
                `Mult:
                    begin
                        whi=`Valid;
                        wlo=`Valid;
                        {wHiData,wLoData}=$signed(regaData)*$signed(regbData);
                    end
                `Multu:
                    begin
                        whi=`Valid;
                        wlo=`Valid;
                        {wHiData,wLoData}=regaData*regbData;
                    end
                `Div:
                    begin
                        whi=`Valid;
                        wlo=`Valid;
                        wHiData=$signed(regaData)%$signed(regbData);
                        wLoData=$signed(regaData)/$signed(regbData);
                    end
                `Divu:
                    begin
                        whi=`Valid;
                        wlo=`Valid;
                        wHiData=regaData%regbData;
                        wLoData=regaData/regbData;
                    end

                default:
                        regcData = `Zero;
            endcase
        end

        regcWrite = regcWrite_i;
        regcAddr = regcAddr_i;
    end
endmodule

// MEM模块 访存 服务于Lw和Sw
module MEM(
	input wire rst,		
	input wire [5:0] op,
	input wire [31:0] regcData,
	input wire [4:0] regcAddr,
	input wire regcWr,
	input wire [31:0] memAddr_i,
	input wire [31:0] memData,	
	input  wire [31:0] rdData,
	output wire [4:0]  regAddr,
	output wire regWr,
	output reg [31:0] regData,	
	output reg [31:0] memAddr,
	output reg [31:0] wtData,
	output reg memWr,	
	output reg memCe
);
    assign regAddr = regcAddr;    
    assign regWr = regcWr;    
    assign regData = (op == `Lw) ? rdData : regcData;    
    assign memAddr = memAddr_i;
    always @ (*)        
        if(rst == `RstEnable)          
        begin            
            wtData = `Zero;            
            memWr = `RamUnWrite;            
            memCe = `RamDisable;          
        end        
        else
    case(op)                
        `Lw: // 读内存 写入寄存器                  
            begin                    
                wtData = `Zero;                        
                memWr = `RamUnWrite;                     
                memCe = `RamEnable;                    
            end                
        `Sw: // 读寄存器 写入内存                  
            begin                    
                wtData = memData;                    
                memWr = `RamWrite;                      
                memCe = `RamEnable;                   
            end
        default:                  
            begin                    
                wtData = `Zero;                    
                memWr = `RamUnWrite;                    
                memCe = `RamDisable;                  
            end            
    endcase
endmodule

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

module HiLo (
	input wire rst,
	input wire clk ,
	input wire [31:0] wHiData,
	input wire [31:0] wLoData,
	input wire whi ,
	input wire wlo ,
	output reg [31:0] rHiData,
	output reg [31:0] rLoData
);
	reg [31:0]hi,lo; 
	always@ (*)
		if(rst==`RstEnable)
			begin
				rHiData = `Zero;
				rLoData = `Zero;
			end
		else
			begin
				rHiData = hi;
				rLoData = lo;
			end
	always@(posedge clk)
		if (rst ==`RstDisable && whi==`Valid)
			hi=wHiData;
		else 
            ;
	always@(posedge clk)
		if (rst ==`RstDisable && wlo==`Valid)
			lo=wLoData;
		else 
            ;
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
        else 
            ; 
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

    wire [31:0] wHiData_ex;
	wire [31:0] wLoData_ex;
	wire whi;
	wire wlo;
	wire [31:0] rHiData_ex;
	wire [31:0] rLoData_ex;

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
