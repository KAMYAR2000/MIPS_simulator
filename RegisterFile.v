module RegisterFile(input clk, input [2:0] R1point, R2point, writeRpoint, input [15:0] writeData, input writeEnable, output reg[15:0] R1, R2);
    reg [15:0] Registers [0:15];

    integer i;
    initial begin
        for (i=0; i<15; i=i+1) begin
            Registers[i] = 0;
        end
        // Registers[0] = 3;
        // Registers[1] = 5;
        // // Registers[1] = 1;
    end

    always @(*) begin
        Registers[0] = 0;
        R1 = Registers[R1point];
		R2 = Registers[R2point];
    end

    always @(negedge clk)
		if (writeEnable) Registers[writeRpoint] = writeData;

endmodule

///////////////////////////////////&
