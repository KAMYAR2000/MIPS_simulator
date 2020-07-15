module PC(input clk, input [15:0] in, output reg [15:0] out, input reg [1:0] stall);
	initial out = 0;
	always @(posedge clk) begin 
		if(stall == 2'b01 || stall == 2'b10) out <= in; 		// if stall is 1 or 2, pc is disable
	end
endmodule


/////////&