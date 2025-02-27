`include "define.v"

module CP0(
    input wire clk,
    input wire rst,
    input wire cp0we,
    input wire [4:0] cp0Addr,
    input wire [31:0] cp0wData,
    output reg [31:0] cp0rData,
    input wire [5:0] intr, // 输入硬件中断
    output reg intimer,			
	input wire[31:0] excptype, // 中断信息
	input wire[31:0] pc,		
	output wire[31:0] cause,	
	output wire[31:0] status	
);

    reg [31:0] Count; // 计数器
    reg [31:0] Compare; // 比较器，与Count完成时钟中断
    reg [31:0] Status; // [15:8]对应Cause中断IP，用于是否屏蔽某周中断源，[1]为Exl，表示是否在异常模式下 [0]为IE，表示是否响应中断 
    reg [31:0] Cause; // [15:8]为IP，用于确认中断类型 [6:2]记录发生何种异常，为0时表示中断，为8表示异常Sysall
    reg [31:0] Epc; // 异常处理程序的返回地址

    assign cause = Cause;
    assign status = Status;

    always@(*)
		Cause[15:10]= intr;

	always@(posedge clk)
		if(rst == `RstEnable)
			begin
				Count= `Zero;
				Compare = `Zero;
				Status= 32'h10000000;
				Cause = `Zero;
				Epc = `Zero;
				intimer = `IntrNotOccur;
			end
		else
			begin
				Count = Count + 1; // 计数器自增
				if(Compare != `Zero && Count == Compare)
					intimer = `IntrOccur;
				if(cp0we == `Valid)
					case(cp0Addr)
						`CP0_count:
							Count = cp0wData;
						`CP0_compare:
							begin
								Compare = cp0wData;
								intimer = `IntrNotOccur;
							end
						`CP0_status:
							Status = cp0wData;
						`CP0_epc:
							Epc = cp0wData;
						`CP0_cause:
							begin
								Cause[9:8]=cp0wData[9:8];
								Cause[23:22]= cp0wData[23:22];
							end
						default: ;
					endcase
				case(excptype)
					//定时时钟中断 定义为0号硬件中断
					32'h0000_0004: // [7:0]为表示外部中断 0100
						begin
							//保存当前pc
							Epc = pc;
							//设置异常模式
							Status[1]=1'b1;
							//确认异常是中断
							Cause[6:2]= 5'b00000; // 0表示中断
						end
					//陷入内核态 Syscall
					32'h0000_0100: // [8]为表示Syscall异常
						begin
							Epc = pc+ 4;
							Status[1]= 1'b1;
							Cause[6:2]= 5'b01000; // 8表示Syscall异常
						end
					//返回用户态 Eret
					32'h0000_0200: // [12]为表示Eret异常
						Status[1]=1'b0;
					default : ;
				endcase
			end

	always@(*)
		if(rst==`RstEnable)
			cp0rData= `Zero;
		else
			case(cp0Addr)
				`CP0_count:
					cp0rData = Count ;
				`CP0_compare:
					cp0rData = Compare;
				`CP0_status:
					cp0rData = Status;
				`CP0_epc:
					cp0rData = Epc;
				`CP0_cause:
					cp0rData= Cause;
				default:
					cp0rData= `Zero;
			endcase
endmodule