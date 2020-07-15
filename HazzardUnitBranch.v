module HazzardUnitBranch(input [2:0] rs_ID, rt_ID, rd_EX, input branch, writeEnableRF_EX, loadEx,
 input [2:0] rt_4, output reg[1:0] stall);

	// initial stall = 0;
	always @(*) begin
		if((writeEnableRF_EX & (!loadEx) & branch) & (rs_ID == rd_EX | rt_ID == rd_EX)) begin
            stall = 2'b01;
        end
		else if((loadEx & branch) & (rs_ID == rd_EX | rt_ID == rd_EX))
            begin
            stall = 2'b10;
            end
        else 
            begin 
            stall <= stall;
            end
	end
endmodule

//////////&