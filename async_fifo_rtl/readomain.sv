module readomain #(parameter ADDR_WIDTH = 4)(
	input logic rclk,
	input logic rrst_n,
	input logic rinc,
	input logic [ADDR_WIDTH:0] rq2_wptr,
	output logic [ADDR_WIDTH-1:0] raddr,
	output logic [ADDR_WIDTH:0] rbin,
	output logic [ADDR_WIDTH:0] rptr,
	output logic rempty
);
	logic [ADDR_WIDTH:0] rbinnext;
	logic [ADDR_WIDTH:0] rgraynext;
	
	logic rempty_val;
	
	assign rbinnext = rbin + (!rempty && rinc);
	assign rgraynext = (rbinnext >>1)^rbinnext;
	assign raddr = rbin [ADDR_WIDTH-1:0];
	assign rempty_val = (rgraynext == rq2_wptr);
	
	always @(posedge rclk or negedge rrst_n) begin
		if(!rrst_n)begin
			rbin <=0;
			rptr <=0;
			rempty <= 1'b1;
		end
		else begin
			rbin <= rbinnext;
			rptr <= rgraynext;
			rempty <= rempty_val;
		end
	end
endmodule