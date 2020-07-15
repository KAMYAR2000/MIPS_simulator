module DataMemory(input [15:0] Rpoint, input [15:0] writeData, input write, load, output reg[15:0] outR);
    reg [15:0] Registers [127:0];
    
    integer i;
    initial begin
        for (i=0; i<128; i=i+1) begin
            Registers[i] = i;
        end

    end
    always@(*) begin
        if(load)begin
            outR = Registers[Rpoint];
        end
        if (write) begin 
            Registers[Rpoint] = writeData;
        end
    end
endmodule
