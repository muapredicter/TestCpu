`include "define.v"

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
		/*
		//测试单周期下版
		//从KEY取出 循环处理 //给LED送入

		//初始化灯型数据
 		instmem[0] = 32'b001101_00000_00000_0000_0000_0000_0001; // ori r0, r0, 0x0001
    	instmem[1] = 32'b001101_00001_00001_0000_0000_0000_0010; // ori r1, r1, 0x0002
    	instmem[2] = 32'b001101_00010_00010_0000_0000_0000_0100; // ori r2, r2, 0x0004
    	instmem[3] = 32'b001101_00011_00011_0000_0000_0000_1000; // ori r3, r3, 0x0008
    	instmem[4] = 32'b001101_00100_00100_0000_0000_0001_0000; // ori r4, r4, 0x0010
    	instmem[5] = 32'b001101_00101_00101_0000_0000_0010_0000; // ori r5, r5, 0x0020
    	instmem[6] = 32'b001101_00110_00110_0000_0000_0100_0000; // ori r6, r6, 0x0040
    	instmem[7] = 32'b001101_00111_00111_0000_0000_1000_0000; // ori r7, r7, 0x0080
    	instmem[8] = 32'b001101_01000_01000_0000_0001_0000_0000; // ori r8, r8, 0x0100
    	instmem[9] = 32'b001101_01001_01001_0000_0010_0000_0000; // ori r9, r9, 0x0200
    	instmem[10] = 32'b001101_01010_01010_0000_0100_0000_0000; // ori r10, r10, 0x0400
    	instmem[11] = 32'b001101_01011_01011_0000_1000_0000_0000; // ori r11, r11, 0x0800
    	instmem[12] = 32'b001101_01100_01100_0001_0000_0000_0000; // ori r12, r12, 0x1000
    	instmem[13] = 32'b001101_01101_01101_0010_0000_0000_0000; // ori r13, r13, 0x2000
    	instmem[14] = 32'b001101_01110_01110_0100_0000_0000_0000; // ori r14, r14, 0x4000
    	instmem[15] = 32'b001101_01111_01111_1000_0000_0000_0000; // ori r15, r15, 0x8000
		instmem[16] = 32'b001111_10000_10000_0111_0000_0000_0000; // lui r16, r16, 0x7000
		instmem[17] = 32'b001101_10000_10000_0000_0000_0100_0000; // ori r16, r16, 0x0040
		//循环
		instmem[18]=32'b101011_10000_00000_0000_0000_0000_0000; //sw r0,0x0(r16)
		instmem[19]=32'b101011_10000_00001_0000_0000_0000_0000; //sw r1,0x0(r16)
		instmem[20]=32'b101011_10000_00010_0000_0000_0000_0000; //sw r2,0x0(r16)
		instmem[21]=32'b101011_10000_00011_0000_0000_0000_0000; //sw r3,0x0(r16)
		instmem[22]=32'b101011_10000_00100_0000_0000_0000_0000; //sw r4,0x0(r16)
    	instmem[23] = 32'b101011_10000_00101_0000_0000_0000_0000; // sw r5, 0x0(r16)
    	instmem[24] = 32'b101011_10000_00110_0000_0000_0000_0000; // sw r6, 0x0(r16)
    	instmem[25] = 32'b101011_10000_00111_0000_0000_0000_0000; // sw r7, 0x0(r16)
    	instmem[26] = 32'b101011_10000_01000_0000_0000_0000_0000; // sw r8, 0x0(r16)
    	instmem[27] = 32'b101011_10000_01001_0000_0000_0000_0000; // sw r9, 0x0(r16)
    	instmem[28] = 32'b101011_10000_01010_0000_0000_0000_0000; // sw r10, 0x0(r16)
    	instmem[29] = 32'b101011_10000_01011_0000_0000_0000_0000; // sw r11, 0x0(r16)
    	instmem[30] = 32'b101011_10000_01100_0000_0000_0000_0000; // sw r12, 0x0(r16)
    	instmem[31] = 32'b101011_10000_01101_0000_0000_0000_0000; // sw r13, 0x0(r16)
    	instmem[32] = 32'b101011_10000_01110_0000_0000_0000_0000; // sw r14, 0x0(r16)
    	instmem[33] = 32'b101011_10000_01111_0000_0000_0000_0000; // sw r15, 0x0(r16)

		instmem[34]= 32'b000010_00000000_00000000_0000010010;  	//j 13H  pc=0013H
		*/
		//???DataMEM??
		//lui  R0,7000 --R1 --70000000
		instmem[0] = 32'h3C017000;
		//lui  R0,7000 --R2 --70000000
		instmem[1] = 32'h3C027000;
		//r1=70000010
		instmem[2]= 32'b001101_00001_00001_0000_0000_0001_0000;//ori r1,r1,0010 
		//r2=70000040
		instmem[3]= 32'b001101_00010_00010_0000_0000_0100_0000;//ori r2,r2,0040
		
		//??
		instmem[4]=32'b100011_00001_00011_0000_0000_0000_0000; //lw r3,0x0(r1)
		instmem[5]=32'b101011_00010_00010_0000_0000_0000_0000; //sw r2,0x0(r2)

		instmem[6]= 32'h08000004;  	//j 4		??000010  pc=0010
		/*
        // 初始化
        instmem[0] = 32'h34011100;//r1=00001100h
		instmem[1] = 32'h34020020;//r2=00000020h
		instmem[2] = 32'h3403ff00;//r3=0000ff00h
		instmem[3] = 32'h3404ffff;//r4=0000ffffh

        // R型指令
        instmem[4] =32'b000000_00010_00001_00101_00000_100000;//add r5,r1,r2  r5=00001120
		instmem[5] =32'b000000_00010_00001_00110_00000_100101;//or r6,r1,r2   r6=00001120
		instmem[6] =32'b000000_00010_00001_00111_00000_100010;//sub r7,r1,r2  r7=000010e0
		instmem[7] =32'b000000_00010_00001_01000_00000_100100;//and r8,r1,r2  r8=00000000
		instmem[8] =32'b000000_00001_00010_01001_00000_100110;//xor r9,r1,r2  r9=00001120

		instmem[9] =32'b000000_00000_00010_01010_00011_000000;//sll r10,r2,0x3 r10=00000100
		instmem[10] =32'b000000_00000_00001_01011_00100_000010;//srl r11,r1,0x4 r11=00000110
		instmem[11] =32'b000000_00000_00001_01100_00100_000011;//sra r12,r1,0x4 r12=00000110

        // I型指令
        instmem [12] = 32'b001101_00001_01101_0000_0000_0001_0001;// ori r13,r1,32'h00000011 = 32'h00001111
        instmem [13] = 32'b001000_00010_01110_0000_0000_0000_0001;//addi r14,r2,32'h00000001 = 32'h00000021
        instmem [14] = 32'b001100_00001_01111_0000_0001_0001_0000;//andi r15,r1,32'h00000110 = 32'h00000100
        instmem [15] = 32'b001110_00011_10000_1100_1111_0000_0000;//xori r16,r3,32'h0000cf00 = 32'h00003000
		
        // J型指令
		instmem [16] = 32'b000010_00000_00000_0000_0000_0001_0010;  //j 0x00000012 
		instmem [17] =32'b000000_00010_00001_00101_00000_100000;//add r5,r1,r2

		instmem [18] = 32'b000011_00000_00000_0000_0000_0001_0100; //jal 0x00000014 返回地址存在r31
		instmem [19] =32'b000000_00010_00001_00101_00000_100000;//add r5,r1,r2 

		instmem [20] = 32'b001101_00000_10010_0000_0000_0101_1100;
		instmem [21] = 32'b000000_10010_00000_00000_00000_001000; //jr R18 
		instmem [22] = 32'b000000_00010_00001_00101_00000_100000;//add r5,r1,r2

		instmem [23] = 32'b000100_00101_00110_0000_0000_0000_0001;  //beq r5,r6,		
		instmem [24] = 32'b000101_00001_00110_0000_0000_0000_0001;  //bne r1,r6,	
		
		instmem [25] =32'b000000_00010_00001_00101_00000_100000;//add r5,r1,r2  
		instmem [26] =32'b000000_00010_00001_00111_00000_100010;//sub r7,r1,r2  

		 instmem[27]=32'b101011_00001_00110_0000_0000_0001_1000; //sw r6,0x18(r1)
		 instmem[28]=32'b100011_00001_10011_0000_0000_0001_1000; //lw r19,0x18(r1)

		instmem [29] = 32'b000000_00001_00010_10100_00000_101010;//slt,R20,R1,R2
		instmem [30] = 32'b000000_00010_00001_10101_00000_101010;//slt,R21,R2,R1

		instmem [31] = 32'b000001_00010_00000_0000_0000_0000_0001;  //bltz r2,r0,1  
		instmem [32] = 32'b000111_00001_00000_0000_0000_0000_0001;  //bgtz r1,r0,1	
		instmem [33] =32'b000000_00010_00001_00101_00000_100000;//add r5,r1,r2  
		instmem [34] =32'b000000_00010_00001_00111_00000_100010;//sub r7,r1,r2 
		//instmem [35] = 32'b000000_00111_00000_00000_00000_001001; //jalr R7 ??001001 pc=0000000C R31=00000020

		//R1=00001100 R2=00000020 
		instmem [35] = 32'b000000_00001_00010_00111_00000_011001;//multu r1,r2     ????? r1*r2=1100*20=22000
        instmem [36] = 32'b000000_00000_00100_10110_10000_000000;//sll R22,R4,10h  ffff0000
		//mult R7,R2  	ffffffff_ffe00000
        instmem [37] = 32'b000000_10110_00010_00000_00000_011000;//mult R22,R2
        instmem [38] = 32'b000000_00001_00010_00000_00000_011011;//divu r1,r2  88_0
		 //div r3,r2 	fffff800_0
        instmem [39] = 32'b000000_10110_00010_00000_00000_011010;//div r22,r2  fffff800  ???0

		instmem [41] = 32'b000000_00000_00000_10111_00000_010000;//mfhi,R23  h1->R21
		instmem [40] = 32'b000000_00000_00000_11000_00000_010010;//mflo,R24  lo->R22

		instmem [42] = 32'b000000_00001_00000_00000_00000_010001;//mthi,R1  R1->hi
		instmem [43] = 32'b000000_00010_00000_00000_00000_010011;//mtlo,R2  R2->lo


		//ll  sc
		instmem [44] = 32'b110000_00001_00111_0000_0000_0010_0000;//ll r7,0x20(r1)
		instmem [45] = 32'b000101_00111_00000_0000_0000_0000_0011;//bne,r7,r0

    	instmem [46] = 32'h34070001;	//ori  R7 0001	
		instmem [47] = 32'b111000_00001_00111_0000_0000_0010_0000;//sc r7,0x20(r1) 
		instmem [48] = 32'b000101_00111_00000_0000_0000_0000_0010;//bne,r7,r0
		instmem [49] = 32'h0800002c;//j 

        instmem [50] = 32'h30070000;	//andi R7,0000
		//lw r7,(0x20)r1
		instmem [51] =32'b100011_00001_00111_0000_0000_0010_0000; //lw r7,0x20(r1)

        //syscall
		instmem [52]=32'h0000000c;//syscall instruction

		instmem [53]=32'h3407f;
		instmem [54]=32'h3408ffff;//ori

		instmem [55]=32'h340affff;//syscall except program
		instmem [56]=32'h340bffff;//ori
		instmem [57]=32'h42000018;//eret inatruction*/
		

        
        /* intimer
		instmem[0] =32'h34020000; 	//ori $2, $0,0
		instmem[1]= 32'h34010014; 	//ori $1, $0,20
		instmem[2]= 32'h40815800; 	//mtc0 $1,$11 set compare=20
		instmem[3]=32'h3c011000;	//lui $1, 0x1000
		instmem[4]=32'h34210401;	//ori $1, $1,0x0401
		instmem[5]= 32'h40816000; 	//mtc0 $1,$12 set status,enable int
		instmem[6]= 32'h08000006; 	//lpt: j lpt
		//interproc first addr Ox0050
		instmem[20]= 32'h34030001; 	//ORI $3,$0,1
		instmem[21]= 32'h34040014;	//ORI S4, $0,20
		instmem[22]= 32'h00431020;	//ADD $2,$2,$3
		instmem[23]= 32'h40015800;	//MFC $1,$11 read compare
		instmem[24]=32'h00240820; 	//ADD $1,$1,$4
		instmem[25]= 32'h40815800;	//MTC0 s1,$11 set compare
		instmem[26]= 32'h42000018;	//eret
        */

    end
endmodule