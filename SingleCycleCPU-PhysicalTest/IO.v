`include "define.v"

module IO(
    input wire ce,
    input wire clk,
    input wire we,
    input wire [31:0] addr,
    input wire [31:0] wtData,
    output reg [31:0] rdData,
    /*IO interface*/
    input wire key, // 开关控制
    output reg [15:0] led  // 灯光控制
);
    /*access IO device*/

    reg [31:0] iomem [1023 : 0]; // 1024个32位存储器 用于io设备
        always@(*)
            if(ce == `IODisable)
                rdData = `Zero;
            else if(we == `IOUnWrite) begin 
                case(addr) 
                    `Key:
                        rdData = {30'h0, key};
                endcase
                end
            else ;
        
        always@(posedge clk)
            if(ce == `IOEnable && we == `IOWrite) begin
                case(addr) 
                    `Led:
                        led = wtData[15:0];
                endcase
                end
            else ;
        
endmodule