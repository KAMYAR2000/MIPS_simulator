module ALU(input [15:0] A, B, input [3:0] controlSignal, output reg[15:0] out);
  always @(*) begin
    case (controlSignal)
           4'b0000: out = A + B ; // Addition
           4'b0001: out = A - B ; // Subtraction
           4'b0010: out = A & B ;  //  Logical and 
           4'b0011: out = A | B;  //  Logical or
           4'b0100: out = A ^ B;  //  Logical xor 
           4'b0101: out = ~(A ^ B);// Logical xnor
           4'b0110: out = A < B ? 16'b1 : 16'b0 ;  //Logical slt
           default: out = A + B ;       //Addition 
    endcase
  end
endmodule

//////////////////////////&
