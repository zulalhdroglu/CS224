module datapath (input  logic clk, reset, pcsrc, alusrca, alusrcb,
                 input  logic regwrite,
                 input logic [1:0] jump,
                 input  logic[1:0] memtoreg, regdst,
		         input  logic[2:0]  alucontrol, 
                 output logic zero, 
		         output logic[31:0] pc, 
	             input  logic[31:0] instr,
                 output logic[31:0] aluout, writedata, 
	             input  logic[31:0] readdata);

  logic [4:0]  writereg;
  logic [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
  logic [31:0] signimm, signimmsh, rd1, srca, srcb, result;
 

   // register file logic
   regfile     rf (clk, regwrite, instr[25:21], instr[20:16], writereg,
                   result, rd1, writedata);

  mux4 #(5)    wrmux (instr[20:16], instr[15:11], 5'h0001F, 0, regdst, writereg);
   signext         se (instr[15:0], signimm);
   
   mux4 #(32)  resmux (aluout, readdata, pcplus4, 32'b0, memtoreg, result);
   
     // next PC logic
    mux4 #(32)  pcmux(pcnextbr, {pcplus4[31:28], 
                                 instr[25:0], 2'b00},rd1, result, jump, pcnext);
  flopr #(32) pcreg(clk, reset, pcnext, pc);
  adder       pcadd1(pc, 32'b100, pcplus4);
  sl2         immsh(signimm, signimmsh);
  adder       pcadd2(pcplus4, signimmsh, pcbranch);
  mux2 #(32)  pcbrmux(pcplus4, pcbranch, pcsrc,
                      pcnextbr);
   
   // ALU logic
   mux2 #(32)  srcamux (rd1, {27'b0, instr[10:6]}, alusrca, srca);
   mux2 #(32)  srcbmux (writedata, signimm, alusrcb, srcb);
   alu         alu (srca, srcb, alucontrol, aluout, zero);

endmodule