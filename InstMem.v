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
        instmem [0] = 32'h34011100; // 001101|00000|00001| 0001 0001 0000 0000 #ori  $1 $0 0001 0001 0000 0000
        instmem [1] = 32'h30020020; // 001100|00000|00010| 0000 0000 0010 0000 #andi $2 $0 0000 0000 0010 0000
        instmem [2] = 32'h3803ff00; // 001110|00000|00011| 1111 1111 0000 0000 #xori $3 $0 1111 1111 0000 0000
        instmem [3] = 32'h2004ffff; // 001000|00000|00100| 1111 1111 1111 1111 #addi $4 $0 1111 1111 1111 1111
        instmem [4] = 32'h2405ffff; // 001001|00000|00101| 1111 1111 1111 1111 #subi $5 $0 1111 1111 1111 1111
        instmem [5] = 32'h3C06ffff; // 001111|00000|00110| 1111 1111 1111 1111 #lui  $6 $0 1111 1111 1111 1111

        instmem [6] ={`Inst_reg, 5'b00001, 5'b00010, 5'b00111, 5'b00000, `Inst_or};    // #or  $7  $1 $2
        instmem [7] = {`Inst_reg, 5'b00010, 5'b00011, 5'b01000, 5'b00000, `Inst_and};  // #and $8  $2 $3
        instmem [8] = {`Inst_reg, 5'b00011, 5'b00100, 5'b01001, 5'b00000, `Inst_xor};  // #xor $9  $3 $4
        instmem [9] = {`Inst_reg, 5'b00100, 5'b00101, 5'b01010, 5'b00000, `Inst_add};  // #add #10 $4 $5
        instmem [10] = {`Inst_reg, 5'b00101, 5'b00110, 5'b01011, 5'b00000, `Inst_sub}; // #sub #11 $5 $6

        instmem [11] = {`Inst_reg, 5'b00110, 5'b00000, 5'b01100, 5'b00000, `Inst_sll}; // #sll #12 #0 << 0
        instmem [12] = {`Inst_reg, 5'b00111, 5'b00000, 5'b01101, 5'b00000, `Inst_srl}; // #srl #13 #0 >>> 0
        instmem [13] = {`Inst_reg, 5'b01000, 5'b00000, 5'b01110, 5'b00000, `Inst_sra}; // #sra #14 #0 >> 0

    end
endmodule