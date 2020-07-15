module Controller(input [3:0] opcode, func, input equal,
                output reg [3:0] aluControl, output reg writeEnableRF, jumpSel, jumpCondSel, branch, AluSrc, MemWrite, MemRead);

    initial {aluControl, writeEnableRF, jumpSel, jumpCondSel, branch, AluSrc, MemWrite, MemRead} = 11'b 0;
    reg [3:0] alu_ctrl;
    //Functions
    `define ADD  3'b000
    `define SUB  3'b001
    `define AND  3'b010
    `define OR   3'b011
    `define XOR  3'b100
    `define NOR  3'b101
    `define SLT  3'b110
    //I-Type Opcodes
    `define ADDI 4'b0001
    `define ANDI 4'b0010
    `define ORI  4'b0011
    `define SUBI 4'b0100
    `define LHW  4'b0111
    `define SHW  4'b1000

    `define BEQ  4'b1001
    `define BNE  4'b1010

    always @(*) begin

        writeEnableRF = ((opcode==`ADDI) || (opcode==`ANDI) || (opcode==`ORI) || (opcode==`SUBI) || (opcode==`LHW)) ? 1 : 0;
     
        case (opcode)
            4'b 0000: begin
                  writeEnableRF = 1;
               end
 
            4'b1111: begin
                jumpSel = 1;
            end
            4'b1001: begin
                branch = 1;
                jumpCondSel = equal ? 1 : 0;
            end
            4'b1010: begin
                branch = 1;
                jumpCondSel = equal ? 0 : 1;
            end
            4'b0111: begin
                AluSrc = 1;
                MemRead = 1;
                writeEnableRF = 1;
            end
            4'b1000: begin
                MemWrite = 1;
                AluSrc = 1;
            end
            default : begin
                branch = 0;
                writeEnableRF = 0;
                MemWrite = 0; 
            end
        endcase
        casex ({opcode,func})
                      {4'd0 , `ADD},
                      {`ADDI, 3'dx},
                      {`LHW , 3'dx},
                      {`SHW , 3'dx} : alu_ctrl = 4'd0;

                      {4'd0 , `SUB},
                      {`SUBI, 3'dx},
                      {`BEQ , 3'dx},
                      {`BNE , 3'dx} : alu_ctrl = 4'd1;

                      {4'd0 , `AND},
                      {`ANDI, 3'dx} : alu_ctrl = 4'd2;

                      {4'd0 , `OR} ,
                      {`ORI , 3'dx} : alu_ctrl = 4'd3;

                      {4'd0 , `XOR} : alu_ctrl = 4'd4;

                      {4'd0 , `NOR} : alu_ctrl = 4'd5;


                      default: alu_ctrl = 4'd0;
          endcase
          assign aluControl = alu_ctrl;
    end
endmodule

