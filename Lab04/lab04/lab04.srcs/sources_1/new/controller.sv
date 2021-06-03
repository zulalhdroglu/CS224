module controller(input  logic[5:0] op, funct,
                  input  logic zero,
                  input  logic[31:0] aluout,
                  output logic[1:0]  memtoreg, aluop, regdst,
                  output logic memwrite,
                  output logic pcsrc, alusrca, alusrcb,
                  output logic regwrite,
                  output logic [1:0] jump, 
                  output logic branch, 
                  output logic[2:0] alucontrol);
                  
  maindec md (op,funct, memtoreg, memwrite, branch, alusrcb, regwrite, jump, aluop, regdst);

   aludec  ad (funct, aluop, alucontrol);

   assign pcsrc = (branch & zero);
  
   assign alusrca = (funct == 6'b000010); // If it is shift right logic

endmodule