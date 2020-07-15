module stall(input clk, input reg[1:0] stall, output reg[1:0] stall2);

	always @(posedge clk) begin 
		if(stall == 2'b10) stall2 = 2'b01; 		// if stall is 2 set it to 1
   	        else if (stall == 2'b01) stall2 = 2'b00;       // if stall is 1 set it to 0
                else if (stall == 2'b00) stall2 <= stall;      // if stall is 0 set it to 0
	end

endmodule

