module testbench();
logic clk, reset;
logic memwrite, alusrca, alusrcb, regwrite, branch,pcsrc, zero;
logic [1:0] jump;
logic [1:0] memtoreg, aluop, regdst;
logic [31:0] pc, instr, readdata, writedata, dataadr;
 new_top dut(clk, reset, memwrite, alusrca, alusrcb, regwrite,jump, branch, memtoreg, aluop, regdst,pc, instr, readdata,writedata, dataadr, pcsrc, zero);
// initialize test
initial
begin
reset <= 1; # 22; reset <= 0;
end
// generate clock to sequence tests
initial begin
  for(int i = 0; i < 50; i++)
 begin
clk <= 1; # 5; clk <= 0; # 5;
 end
end

endmodule