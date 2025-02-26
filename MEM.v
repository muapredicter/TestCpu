`include "define.v"

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
    // ll & sc
    input wire rLLbit,
	output wire [4:0]  regAddr,
	output wire regWr,
	output reg [31:0] regData,	
	output reg [31:0] memAddr,
	output reg [31:0] wtData,
	output reg memWr,	
	output reg memCe,
    // ll & sc
    output reg wbit,
    output reg wLLbit
);
    assign regAddr = regcAddr;    
    assign regWr = regcWr;    

    wire [31:0]regDataLL= (rLLbit==`SetFlag) ? 32'b1 : 32'b0; 
	wire [31:0]regcDataLL=  (op == `Sc ) ? regDataLL : regcData;
	assign regData = (op == `Lw) ? rdData : regcDataLL;   

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
        `Ll: //  读内存 写入寄存器 设置内存地址为已监视
            begin
                wtData = `Zero;                        
                memWr = `RamUnWrite;                     
                memCe = `RamEnable; 

                wbit = `Valid;
                wLLbit = `SetFlag;`
            end
        `Sc: // 读寄存器 写入内存 检测已监视地址是否被修改
            begin
                if (rLLbit == `SetFlag)
                    begin
                        wtData = memData;                    
                        memWr = `RamWrite;                      
                        memCe = `RamEnable;  
                        wbit = `Valid;
                        wLLbit = `ClearFlag;
                    end 
                else
                    begin
                        wbit = `Invalid;
                        wLLbit = `ClearFlag;
                    end
            end
        default:                  
            begin                    
                wtData = `Zero;                    
                memWr = `RamUnWrite;                    
                memCe = `RamDisable;                  
            end            
    endcase
endmodule
