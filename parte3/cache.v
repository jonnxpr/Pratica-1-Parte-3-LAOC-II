module mux2pra1 (a, b, sel, DataOut);

	input [12:0] a, b;
	input sel;
	output reg [12:0] DataOut;

	always @(a, b, sel)
	begin
	  case (sel)
		  1'b0: DataOut <= a;
		  1'b1: DataOut <= b;
	  endcase
	end
endmodule

module cache(address, clock, wren, dataIn, dataOut, hit, miss, dirty1, dirty2);

	input[4:0] address;
	input clock;
	input wren;
	input [7:0] dataIn;
	output [7:0] dataOut;
	output hit;
	output miss;
	output dirty1;
	output dirty2;

	wire lru1, lru2, dirty1, dirty2;
	wire [11:0] dataOutVia1, dataOutVia2, dataOutMux1, dataOutMux2;

   mux2pra1 muxIn1({dataOutVia1[11],~dataOutVia1[10],dataOutVia1[9:0]}, {1'b1,dataOutVia2[10],address[4:3],dataIn}, (wren || miss) && dataOutVia1[10], dataOutMux1);
	mux2pra1 muxIn2({dataOutVia2[11],~dataOutVia2[10],dataOutVia2[9:0]}, {1'b1,dataOutVia1[10],address[4:3],dataIn}, (wren || miss) && ~dataOutVia1[10], dataOutMux2);
	mux2pra1 muxOut(dataOutVia1[7:0], dataOutVia2[7:0], (dataOutVia1[9:8] == address[4:3] ? 1'b0 : 1'b1), dataOut);
  
	ramlpm v1(clock, dataOutMux1, address[2:0], address[2:0], (wren || miss), dataOutVia1);
	ramlpm v2(clock, dataOutMux2, address[2:0], address[2:0], (wren || miss), dataOutVia2);
  
  
  assign lru1 = dataOutVia1[10];
  assign lru2 = dataOutVia2[10];
  
  
  assign hit =   ((dataOutVia1[11] || dataOutVia2[11]) && ((dataOutVia1[9:8] == address[4:3]) || (dataOutVia2[9:8] == address[4:3])));
  assign miss = ~hit;
  assign dirty1 = ((hit && wren) && (dataOutVia1[9:8] == address[4:3]));
  assign dirty2 = ((hit && wren) && (dataOutVia2[9:8] == address[4:3]));
endmodule
