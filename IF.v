`include "define.v"

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