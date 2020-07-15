module ForwardingUnit(input [2:0] rs_Ex, rt_Ex, rd_MM, rd_WB, input WB_MM, WB_WB,
					output reg MM_sel_R1, MM_sel_R2, WB_sel_R1, WB_sel_R2);

	initial {MM_sel_R1, MM_sel_R2, WB_sel_R1, WB_sel_R2} = 4'b 0;
	always @(*) begin
		MM_sel_R1 = (rs_Ex == rd_MM) & WB_MM;
		MM_sel_R2 = (rt_Ex == rd_MM) & WB_MM;
		WB_sel_R1 = (rs_Ex == rd_WB) & WB_WB;
		WB_sel_R2 = (rt_Ex == rd_WB) & WB_WB;
	end
endmodule