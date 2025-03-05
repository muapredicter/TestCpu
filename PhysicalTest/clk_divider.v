`include "define.v"

module clk_divider (
    input  wire out_clk,    // ????
    input  wire reset_n,    // ??????????
    output reg  clk         // ????
);
 // ?????????? `COUNTER_MAX` ? `define.v` ????

reg [31:0] count;
	initial begin
		count = 32'd0;
        clk = 1'b0;
	end

always @(posedge out_clk) begin
         begin
        if (count == `COUNTER_MAX - 1) begin
            count <= 32'd0;
            clk <= ~clk;
        end else begin
            count <= count + 1'b1;
        end
    end
end

endmodule