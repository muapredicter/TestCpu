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
    output reg [31:0] wLoData
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