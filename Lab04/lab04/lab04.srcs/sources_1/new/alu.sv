module alu(input  logic [31:0] a, b, 
           input  logic [2:0]  alucont, 
           output logic [31:0] result,
           output logic zero);

  always_comb
  case(alucont)
    3'b010:
        begin
        result = a + b;
        zero = 0;
        end
    3'b110:
        begin
        result = a - b;
        if(result == 0)
            zero = 1;
        else
            zero = 0;
        end
    3'b000:
        begin
        result = a & b;
        zero = 0;
        end
    3'b001:
        begin
        result = a | b;
        zero = 0;
        end
    3'b111:
        begin
        if(a < b)
            result = 1;
        else
            result = 0;
        zero = 0;
        end
    3'b011:
      	begin
          result = b >> a;
          zero = 0;
        end
  endcase
endmodule