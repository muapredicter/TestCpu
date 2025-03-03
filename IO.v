module IO(
    input wire ce,
    input wire clk,
    input wire we,
    input wire [31:0] addr,
    input wire [31:0] wtData,
    output reg [31:0] rdData,
    /*IO interface*/
    input wire sw,
    output reg [15:0] led
);
    /*access IO device*/
    always(posedge clk)
        if(sw == 1)
            led = wtData[15:0];
        else
            led = 16'b0000_0000_0000_0000;
endmodule