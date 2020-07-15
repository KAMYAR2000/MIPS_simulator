module InsMemory(input [15:0] adress, output reg[15:0] outIns);
    integer               data_file    ; // file handler
    integer               scan_file    ; // file handler
    `define NULL 0
    
    reg [15:0] instractions [0:15];

    // initial begin
    //   data_file = $fopen("./instructions.txt", "r");
    //   if (data_file == `NULL) begin                        //?????????????????????????????????
    //     $display("data_file handle was NULL");
    //     $finish;
    //   end
    // end

    integer i;
    initial begin
      for (i=0; i<15; i=i+1) begin
        scan_file = $fscanf(data_file, "%b\n", instractions[i]); 
      end
    end

    always @(*) begin
      outIns = instractions[adress/4];
    end
    
endmodule