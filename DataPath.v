module DataPath(input clk);

//IF
    wire [15:0] nextPC, pcOutput, pcInput, IR_1;
//ID
    wire [1:0] stall, stall_next;
    wire writeEnableRF_2, writeEnableRF_5, jumpSel, AluSrc_2, MemWrite_2, MemRead_2, branch;
    wire [3:0] aluControl_2;
    wire [2:0] DistAddress_1;
    wire [15:0] IR_2, PC_2, jumpPC, branchPC, imm_2, branchShift, writeDataRF_5, readDataA_2, readDataB_final_2, readDataB_2;
//EX
    wire writeEnableRF_3, forwardA_Mem, forwardB_Mem, forwardA_WB, forwardB_WB, branchSel, equal, MemWrite_3, MemRead_3, AluSrc_3;
    wire [3:0] aluControl_3;
    wire [2:0] rd_3, rs_3, rt_3, DistAddress_3;
    wire [15:0] readDataA_3, readDataB_final_3, AluResult_3, AluR1, AluR2, dataSW_3, readDataB_3;
//MM
    wire writeEnableRF_4, MemWrite_4, MemRead_4;
    wire [3:0] DistAddress_4;
    wire [15:0] AluResult_4, LWresult_4, dataSW_4;
//WB
    wire MemRead_5;
    wire [15:0] LWresult_5, AluResult_5;





//IF
    stall stall_new(clk, stall, stall_next);
    assign stall = stall_next;
    assign pcInput = jumpSel ? jumpPC : branchSel ? branchPC : nextPC;        
    PC pc(clk, pcInput, pcOutput, stall);                                    
    Adder next_PC(pcOutput, 2, nextPC);                                     
    InsMemory im(pcOutput, IR_1);                                          

    IFID ifid(clk, IR_1, nextPC, IR_2, PC_2, stall, jumpSel, branchSel);       // MIDDLE REGs BETWEEN IF AND ID  
                                           // branchSel is same as branch taken is generated in controller

//ID
    Controller CU(IR_2[15:12], IR_2[2:0], equal, aluControl_2, writeEnableRF_2, jumpSel, branchSel, branch, AluSrc_2, MemWrite_2, MemRead_2);     //بررسی نشد
    RegisterFile rf(clk, IR_2[11:9], IR_2[8:6], DistAddress_5, writeDataRF, writeEnableRF_5, readDataA_2, readDataB_2);         //&

    assign readDataB_final_2 = AluSrc_2 ? imm_2 : readDataB_2;        // multiplexer for B register

    Jumper jumper(PC_2, IR_2[11:0], jumpPC);                         // address of jump
    assign equal = (readDataA_2 == readDataB_final_2);                  // comparator
    SignExtend SignExtend_inst(IR_2[5:0], imm_2);                       

    ShiftLeftII shiftLeft_inst(imm_2, branchShift);                   // shift left for branch
    Adder branchAdder(branchShift, PC_2, branchPC);                  //adder for branch
    
    HazzardUnit hu(IR_2[11:9], IR_2[8:6], rt_3, MemRead_3, stall);          //stall is generated here
    HazzardUnitBranch hub(IR_2[11:9], IR_2[8:6], rd_3, branch, writeEnableRF_3, MemRead_3, rt_3, stall);

    IDEX idex(clk, aluControl_2, writeEnableRF_2, AluSrc_2, MemWrite_2, MemRead_2, readDataA_2, readDataB_final_2, readDataB_2, IR_2[5:3], IR_2[11:9], IR_2[8:6],
        aluControl_3, writeEnableRF_3, AluSrc_3, MemWrite_3, MemRead_3, readDataA_3, readDataB_final_3, readDataB_3, rd_3, rs_3, rt_3, stall);

//EX
    // در خط پایین، شرط اول میگیم که اگر دستورات جی تایپه، فروارد رو چک نکن و مستقیم ببرش توی آ ال یو
    assign AluR2 = AluSrc_3 ? readDataB_final_3 : forwardB_Mem ? AluResult_4 : forwardB_WB ? writeDataRF_5 : readDataB_final_3;
    assign AluR1 = forwardA_Mem ? AluResult_4 : forwardA_WB ? writeDataRF : readDataA_3;

    ALU alu(AluR1, AluR2, aluControl_3, AluResult_3);
    ForwardingUnit fu(rs_3, rt_3, DistAddress_4, DistAddress_5, writeEnableRF_4, writeEnableRF_5, forwardA_Mem, forwardB_Mem, forwardA_WB, forwardB_WB);
   
    assign DistAddress_3 = AluSrc_3 ? rt_3 : rd_3;          // ALUSrc instead of RegDst. they do work like each other! 
    assign dataSW_3 = forwardB_Mem ? AluResult_4 : forwardB_WB ? writeDataRF_5 : readDataB_3;    // data to store in sw
    
    EXMEM exmem(clk, writeEnableRF_3, MemWrite_3, MemRead_3, AluResult_3, dataSW_3, DistAddress_3, writeEnableRF_4, MemWrite_4, MemRead_4, AluResult_4, dataSW_4, DistAddress_4);

//MM
    DataMemory dm(AluResult_4, dataSW_4, MemWrite_4, MemRead_4, LWresult_4);

    MEMWB memwb(clk, writeEnableRF_4, MemRead_4, AluResult_4, LWresult_4, DistAddress_4, writeEnableRF_5, MemRead_5, AluResult_5, LWresult_5, DistAddress_5);

//WB
    assign writeDataRF_5 = MemRead_5 ? LWresult_5 : AluResult_5;

endmodule