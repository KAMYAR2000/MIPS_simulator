module IFID(input clk, input [15:0] ins_in, input[15:0] pc_in,
			output reg [15:0] ins_out, output reg [15:0] pc_out, input stall, jump, branch);

	initial {ins_out, pc_out} = 32'b 0;        

	always @(posedge clk) begin
		if(stall == 2'b01 || stall == 2'b10) begin					// if stall is 1, IR should be disable
			ins_out = ins_in;
			pc_out = pc_in;
		end
		if(jump || branch) ins_out = 0;                            // flush\kill after jump and branch taken
	end													// in this module branch is same as branch taken
endmodule

///////////////////&