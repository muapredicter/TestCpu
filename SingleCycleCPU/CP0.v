`include "define.v"

// CP0模块：协处理器0，用于处理异常、中断和系统控制
module CP0(
    input wire clk,         // 时钟信号
    input wire rst,         // 复位信号
    input wire cp0we,       // CP0写使能信号
    input wire[4:0] cp0Addr, // CP0寄存器地址
    input wire[31:0] cp0wData, // CP0写入数据
    output reg[31:0] cp0rData, // CP0读取数据
    input wire[5:0] intr,   // 中断信号
    output reg intimer,     // 定时器中断信号
    input wire[31:0] excptype, // 异常类型
    input wire[31:0] pc,    // 程序计数器
    output wire[31:0] cause, // Cause寄存器
    output wire[31:0] status // Status寄存器
);

    reg[31:0] Count;        // 计数器寄存器
    reg[31:0] Compare;      // 比较寄存器
    reg[31:0] Status;       // 状态寄存器
    reg[31:0] Cause;        // 原因寄存器
    reg[31:0] Epc;          // 异常程序计数器

    assign cause = Cause;   // 输出Cause寄存器
    assign status = Status; // 输出Status寄存器

    // 将中断信号赋值给Cause寄存器的相应位
    always@(*)
        Cause[15:10] = intr; // 中断信号赋值给IP[7:2]

    // 时钟上升沿触发
    always@(posedge clk)
        if(rst == `RstEnable) begin
            // 复位时初始化寄存器
            Count = `Zero;
            Compare = `Zero;
            Status = 32'h10000000;
            Cause = `Zero;
            Epc = `Zero;
            intimer = `IntrNotOccur;
        end else begin
            Count = Count + 1; // 计数器自增
            if(Compare != `Zero && Count == Compare)
                intimer = `IntrOccur; // 计数器与比较器相等时触发中断

            if(cp0we == `Valid) begin
                // 根据地址写入CP0寄存器
                case(cp0Addr)
                    `CP0_count: Count = cp0wData;
                    `CP0_compare: begin
                        Compare = cp0wData;
                        intimer = `IntrNotOccur;
                    end
                    `CP0_status: Status = cp0wData;
                    `CP0_epc: Epc = cp0wData;
                    `CP0_cause: begin
                        Cause[9:8] = cp0wData[9:8];
                        Cause[23:22] = cp0wData[23:22];
                    end
                    default: ;
                endcase
            end

            // 处理异常
            case(excptype)
                32'h0000_0004: begin // 定时器中断
                    Epc = pc; // 保存当前PC
                    Status[1] = 1'b1; // 设置异常状态
                    Cause[6:2] = 5'b00000; // 设置异常代码
                end
                32'h0000_0100: begin // 系统调用
                    Epc = pc + 4; // 保存PC+4
                    Status[1] = 1'b1; // 设置异常状态
                    Cause[6:2] = 5'b01000; // 设置异常代码
                end
                32'h0000_0200: Status[1] = 1'b0; // 异常返回
                default: ;
            endcase
        end

    // 读取CP0寄存器
    always@(*)
        if(rst == `RstEnable)
            cp0rData = `Zero;
        else
            case(cp0Addr)
                `CP0_count: cp0rData = Count;
                `CP0_compare: cp0rData = Compare;
                `CP0_status: cp0rData = Status;
                `CP0_epc: cp0rData = Epc;
                `CP0_cause: cp0rData = Cause;
                default: cp0rData = `Zero;
            endcase
endmodule