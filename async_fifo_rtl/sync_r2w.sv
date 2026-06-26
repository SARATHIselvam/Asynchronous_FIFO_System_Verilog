module sync_r2w #(parameter ADDR_WIDTH = 4)
(
	input logic wclk,
	input logic wrst_n,
	input logic [ADDR_WIDTH:0] rptr,
	output logic [ADDR_WIDTH:0] wq2_rptr
);
	logic [ADDR_WIDTH:0] wq1_rptr;
	
	always @(posedge wclk or negedge wrst_n) begin
		if(!wrst_n)begin
			wq1_rptr <=0;
			wq2_rptr <=0;
		end
		else begin
			wq1_rptr <= rptr;
			wq2_rptr <= wq1_rptr;
		end
	end
endmodule