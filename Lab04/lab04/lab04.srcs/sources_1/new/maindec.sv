module maindec (input logic[5:0] op,funct, 
                  output logic[1:0] memtoreg,
	              output logic memwrite, branch,
	              output logic alusrcb, regwrite,
	              output logic [1:0] jump,
	              output logic[1:0] aluop, regdst);
  logic [10:0] controls;

  assign {regwrite, regdst, alusrcb, branch, memwrite,
                memtoreg, aluop} = controls;

  always_comb
    case(op)
        6'b000000: begin controls <= 10'b1_01_0_0_0_00_10; 
   if(funct == 6'b001000) //check for jr instruction
    jump <= 2'b10;
    else
   jump <= 2'b00; 
   end // R-type
        6'b100011: begin controls <= 10'b1_00_1_0_0_01_00; jump <= 2'b00; end // LW
        6'b101011: begin controls <= 10'b0_00_1_0_1_00_00; jump <= 2'b00; end // SW
        6'b000100: begin controls <= 10'b0_00_0_1_0_00_01; jump <= 2'b00; end // BEQ
        6'b001000: begin controls <= 10'b1_00_1_0_0_00_00; jump <= 2'b00; end // ADDI
        6'b000010: begin controls <= 10'b0_00_0_0_0_00_00; jump <= 2'b01; end // J
        6'b000011: begin controls <= 10'b1_10_0_0_0_10_00; jump <= 2'b01; end // JAL
        6'b111111: begin controls <= 10'b0_xx_1_x_0_01_00; jump <= 2'b11; end//jm
        default:   begin controls <= 10'bx_x_x_x_x_xx_xx; jump <= 2'bx; end // illegal op
    endcase
endmodule