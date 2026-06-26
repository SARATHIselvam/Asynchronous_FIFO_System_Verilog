module fifo_mem #(
	parameter DATA_WIDTH = 8,
	parameter ADDR_WIDTH = 4
	)(
	input logic wclk,
	input logic wren,
	input logic [DATA_WIDTH-1:0] wdata,
	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
	output logic [DATA_WIDTH-1:0] rdata
	);
	
	localparam DEPTH = (1<<ADDR_WIDTH);
	
	logic [DATA_WIDTH-1:0] fifomem [0:DEPTH-1];
	
	always @(posedge wclk)begin
		if(wren)begin
			fifomem[waddr] <= wdata;
		end
	end
	
	assign rdata = fifomem[raddr];
endmodule