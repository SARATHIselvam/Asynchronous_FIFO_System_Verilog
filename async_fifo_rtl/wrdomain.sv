module wrdomain #(parameter ADDR_WIDTH = 4)(
	input logic wclk,
	input logic wrst_n,
	input logic winc,
	input logic [ADDR_WIDTH:0] wq2_rptr,
	output logic [ADDR_WIDTH-1:0] waddr,
	output logic [ADDR_WIDTH:0] wbin,
	output logic [ADDR_WIDTH:0] wptr,
	output logic wfull
);
	logic [ADDR_WIDTH:0] wbinnext;
	logic [ADDR_WIDTH:0] wgraynext;
	
	logic wfull_val;
	
	assign wbinnext = wbin + (!wfull && winc);
	assign wgraynext = (wbinnext >>1)^wbinnext;
	assign waddr = wbin [ADDR_WIDTH-1:0];
	assign wfull_val = (wgraynext == {~wq2_rptr[ADDR_WIDTH:ADDR_WIDTH-1], wq2_rptr[ADDR_WIDTH-2:0]});
	
	always @(posedge wclk or negedge wrst_n) begin
		if(!wrst_n)begin
			wbin <=0;
			wptr <=0;
			wfull <= 1'b0;
		end
		else begin
			wbin <= wbinnext;
			wptr <= wgraynext;
			wfull <= wfull_val;
		end
	end
endmodule