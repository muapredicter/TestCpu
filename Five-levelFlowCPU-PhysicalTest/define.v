`define RomDisable 0
`define RomEnable 1
`define Zero 0
`define RstEnable 1
`define RstDisable 0
`define Valid 1
`define Invalid 0
`define nop 6'b000000
`define SetFlag 1'b1
`define ClearFlag 1'b0

//MEM
`define RamWrite 1'b1
`define RamUnWrite 1'b0
`define RamEnable 1'b1
`define RamDisable 1'b0

//中断处理
`define CP0_epc 32'b0
`define IntrOccur 1'b1
`define IntrNotOccur 1'b0

//CPO寄存器号
`define CP0_count 5'd9
`define CP0_compare 5'd11
`define CP0_status 5'd12
`define CP0_epc 5'd14
`define CP0_cause 5'd13

//流水线CPU
`define ZeroWord 32'b0000
`define Stop 1'b1
`define NoStop 1'b0

//I型
`define Inst_addi 6'b001000
`define Inst_ori 6'b001101
`define Inst_andi 6'b001100
`define Inst_xori 6'b001110
`define Inst_lui 6'b001111
`define Inst_beq 6'b000100
`define Inst_bne 6'b000101
`define Inst_lw  6'b100011
`define Inst_sw  6'b101011

//R型
`define Inst_reg 6'b000000 
`define Inst_add 6'b100000
`define Inst_sub 6'b100010
`define Inst_and 6'b100100
`define Inst_or  6'b100101
`define Inst_xor 6'b100110
`define Inst_sll 6'b000000
`define Inst_srl 6'b000010
`define Inst_sra 6'b000011

//J型
`define Inst_j 	 6'b000010
`define Inst_jr  6'b001000
`define Inst_jal 6'b000011
`define Inst_slt 6'b101010
`define Inst_bgtz 6'b000111
`define Inst_bltz 6'b000001	
`define Inst_jalr 6'b001001	

//乘除
`define Inst_mult 6'b011000	 
`define Inst_multu 6'b011001 
`define Inst_div 6'b011010
`define Inst_divu 6'b011011 
`define Inst_mfhi 6'b010000	 
`define Inst_mflo 6'b010010	 
`define Inst_mthi 6'b010001	 
`define Inst_mtlo 6'b010011	 

//ll&sc 原子指令
`define Inst_ll 6'b110000	 
`define Inst_sc 6'b111000	 

//中断处理
`define Inst_syscall 32'b000000_00000_000000000000000_001100 
`define Inst_eret 32'b010000_10000_000000000000000_011000 
`define Inst_cp0  6'b010000	 // 二级译码
`define Inst_mfc0 5'b00000	
`define Inst_mtc0 5'b00100	 

//EX
`define Nop 6'b000000
`define Or  6'b000001
`define And 6'b000010
`define Xor 6'b000011
`define Add 6'b000100
`define Sub 6'b000101
`define Sll 6'b000110
`define Srl 6'b000111
`define Sra 6'b001000
`define Jr  6'b001001
`define Addi 6'b001010
`define Ori 6'b001011
`define Andi 6'b001100
`define Xori 6'b001101
`define Lui 6'b001110
`define Beq 6'b001111
`define Bne 6'b010000
`define J   6'b010001
`define Jal 6'b010010
`define Lw 6'b010011
`define Sw 6'b010100
`define Slt 6'b010101
`define Bgtz 6'b010110
`define Bltz 6'b010111
`define Jalr 6'b011000
`define Mult 6'b011001
`define Multu 6'b011010
`define Div 6'b011011
`define Divu 6'b011100
`define Mfhi 6'b011101
`define Mflo 6'b011110
`define Mthi 6'b011111
`define Mtlo 6'b100000
`define Ll 6'b100001
`define Sc 6'b100010
`define Syscall 6'b100011
`define Eret 6'b100100
`define Mfc0 6'b100101
`define Mtc0 6'b100110