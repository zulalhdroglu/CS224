// Top level system including MIPS and memories
module new_top(input   logic clk, reset,            
	     output  logic       memwrite,
         output logic alusrca, alusrcb, regwrite,
         output logic [1:0] jump, 
         output logic branch,
         output logic [1:0]  memtoreg, aluop, regdst,
         output logic [31:0] pc, instr, readdata, writedata, dataadr,
         output logic pcsrc, zero
	     );
	
	
	logic [2:0]  alucontrol;
    mips mips (clk, reset, pc, instr, memwrite, dataadr, writedata, 
    readdata, pcsrc, zero, alusrca, alusrcb, regwrite, jump, branch, memtoreg, aluop, regdst, alucontrol);
      
    imem imem (pc[7:2], instr);  
    dmem dmem (clk, memwrite, dataadr, writedata, readdata);
    
endmodule