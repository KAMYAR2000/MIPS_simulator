module IDEX(input clk, input [3:0] aluSig_in, input WB_in, extendForMem_in, WMEM_in, load_in,
			input [15:0] R1_in, R2_in, wdMem_in,
			input [2:0] rd_in, rs_in, rt_in,
			output reg [3:0] aluSig_out,
			output reg WB_out, extendForMem_out, WMEM_out, load_out,
			output reg [15:0] R1_out, R2_out, wdMem_out,
			output reg [2:0] rd_out, rs_out, rt_out,
			input reg [1:0] stall);

	initial {aluSig_out, WB_out, R1_out, R2_out, rd_out, rs_out, rt_out, extendForMem_out, WMEM_out, load_out, wdMem_out} = 65'b 0;
	
	always @(posedge clk) begin
		aluSig_out = aluSig_in; 
		WB_out = WB_in; 
		R1_out = R1_in;
		R2_out = R2_in;
		rd_out = rd_in;
		rs_out = rs_in;
		rt_out = rt_in;
		extendForMem_out = extendForMem_in;
		WMEM_out = WMEM_in;
		load_out = load_in;
		wdMem_out = wdMem_in;
		if(stall == 2'b01 || stall == 2'b10) begin    // we didn't make all control wires 0 except write controls
			WMEM_out = 0;						// because it's enough to stall with not changing RF and Memory
			WB_out = 0;
		end
	end
endmodule