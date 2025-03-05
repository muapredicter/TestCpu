`include "define.v";
//6、指令存储器
module InstMem(
    input wire ce,
    input wire [31:0] addr,
    output reg [31:0] data
);
    reg [31:0] instmem [1023 : 0];    
    always@(*)      
        if(ce == `RomDisable)
			data = `Zero;
        else
			data = instmem[addr[11 : 2]];   
    initial
		begin
		//测试流水数据冲突
		//ori R0,1100 -- R1 --00001100
        instmem [0] = 32'h34011100;
		//ori R0,0020 -- R2 --00000020
        instmem [1] = 32'h34020020;
		//ori R0,ff00 -- R3 --0000ff00
        instmem [2] = 32'h3403ff00;
		//ori R0,ffff -- R4 --0000ffff
        instmem [3] = 32'h3404ffff;

		//相邻两条指令 	//ori R4,0000 -- R5 --0000ffff
        instmem [4] = 32'h34850000;	
		//相隔一条指令	//ori R4,0000 -- R6 --0000ffff
        instmem [5] = 32'h34860000;	
		//相隔两条指令	//ori R4,0000 -- R7 --0000ffff
		instmem [6] = 32'h34870000;	
		//load 相关
		//mem[0]=(r1)
		instmem[7]=32'b101011_00000_00001_0000_0000_0000_0000; //sw r1,0x0(r0)
		//(r8)=mem[0]
		instmem[8]=32'b100011_00000_01000_0000_0000_0000_0000; //lw r8,0x0(r0)
		instmem[9]=32'b001101_01000_01001_0000_0000_0000_0000; // ori r9 r8,0000	
		instmem[10]=32'b001100_01001_01010_1111_1111_1111_1111; // andi r10 r9,ffff	
		end
endmodule
