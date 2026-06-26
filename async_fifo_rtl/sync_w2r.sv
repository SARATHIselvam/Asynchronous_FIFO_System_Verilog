module sync_w2r #(parameter ADDR_WIDTH = 4)
(
	input logic rclk,
	input logic rrst_n,
	input logic [ADDR_WIDTH:0] wptr,
	output logic [ADDR_WIDTH:0] rq2_wptr
);
	logic [ADDR_WIDTH:0] rq1_wptr;
	
	always @(posedge rclk or negedge rrst_n) begin
		if(!rrst_n)begin
			rq1_wptr <=0;
			rq2_wptr <=0;
		end
		else begin
			rq1_wptr <= wptr;
			rq2_wptr <= rq1_wptr;
		end
	end
endmodule