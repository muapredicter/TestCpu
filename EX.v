`include "define.v"

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
    // 乘法除法指令添加
    input wire [31:0] rHiData,
    input wire [31:0] rLoData,
    output reg whi,	
    output reg wlo,	
    output reg [31:0] wHiData,	
    output reg [31:0] wLoData,
    // 中断处理指令添加
    output reg cp0we,			
	output reg [4:0] cp0Addr,	
	output reg [31:0] cp0wData,	
	input wire[31:0] cp0rData,	
	input wire[31:0] pc_i,		
	input wire [31:0] excptype_i,
	output reg [31:0] excptype,	
	output wire [31:0] epc, // 从中断处理程序的返回地址
	output wire [31:0] pc,  // 中断处理的pc
	input wire [31:0] cause,	
	input wire [31:0] status	
);
    assign op = op_i;
    assign memAddr = regaData;
    assign memData = regbData;

    assign pc = pc_i;
	assign op = (excptype == `Zero) ? op_i : `Nop;
	assign regcWrite =(excptype == `Zero) ? regcWrite_i : `Invalid;

    always @(*) begin
        if (rst == `RstEnable) begin
            regcData = `Zero;
            whi = `Invalid;
            wlo = `Invalid;
            wHiData = `Zero;
            wLoData = `Zero;
            cp0we = `Invalid;
            cp0wData = `Zero;
            cp0Addr = `CP0_epc;
        end
        else begin
            regcData = `Zero;
            wHiData = `Zero;
            wLoData = `Zero;
            cp0we = `Invalid;
            cp0wData = `Zero;
            cp0Addr = `CP0_epc;
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
                // 中断处理指令
                `Mfc0:
                    begin
                        cp0Addr = regbData[4:0];
                        regcData = cp0rData;
                    end
                `Mtc0:
                    begin
                        regcData= `Zero;
                        cp0we = `Valid;
                        cp0Addr = regbData[4:0];
                        cp0wData = regaData;
                    end
                default:
                        regcData = `Zero;
            endcase
        end

    assign epc = (excptype == 32'h0000_0200) ? cp0rData : `Zero;

	always@(*)
		if(rst ==`RstEnable)
			excptype = `Zero;
		else if(cause[10]&& status[10]== 1'b1 && status[1:0] == 2'b01)
			//定时时钟中断
			excptype = 32'h0000_0004;
		else if(excptype_i[8] == 1'b1 && status[1] == 1'b0)
			//陷入内核态   
			excptype = 32'h00000100;
		else if(excptype_i[9]== 1'b1)
			//返回用户态
			excptype = 32'h0000_0200;
		else
			excptype = `Zero;    
	assign regcWrite = regcWrite_i;
	assign regcAddr = regcAddr_i;
    end
endmodule