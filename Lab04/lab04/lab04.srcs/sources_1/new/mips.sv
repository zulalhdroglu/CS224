// single-cycle MIPS processor, with controller and datapath
module mips (input  logic        clk, reset,
             output logic[31:0]  pc,
             input  logic[31:0]  instr,
             output logic        memwrite,
             output logic[31:0]  aluout, writedata,
             input  logic[31:0]  readdata,
             output logic  pcsrc, zero, alusrca, alusrcb, regwrite,
             output logic [1:0] jump, 
             output logic branch,
             output logic [1:0]  memtoreg, aluop, regdst,
             output logic [2:0]  alucontrol
               );
  controller c (instr[31:26], instr[5:0], zero, aluout, memtoreg, aluop, regdst, memwrite, pcsrc, alusrca, alusrcb, regwrite, jump, branch, alucontrol);

  datapath dp (clk, reset, pcsrc, alusrca, alusrcb, regwrite, jump, memtoreg, regdst,
                          alucontrol, zero, pc, instr, aluout, writedata, readdata);

endmodule