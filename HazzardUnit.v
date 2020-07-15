module HazzardUnit(input [2:0] rs_ID, rt_ID, rt_EX, input loadEx, output reg [1:0] stall);

	always @(*) begin
		if(loadEx & (rs_ID == rt_EX | rt_ID == rt_EX)) stall = 2'b01;
		else stall <= stall;
	end
endmodule

//////////&