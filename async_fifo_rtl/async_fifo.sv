module async_fifo #(
	parameter DATA_WIDTH = 8,
	parameter ADDR_WIDTH = 4
)(
	input logic wclk,
	input logic wrst_n,
	input logic winc,
	input logic [DATA_WIDTH-1:0]wdata,
	output logic wfull,
	
	input logic rclk,
	input logic rrst_n,
	input logic rinc,
	output logic [DATA_WIDTH-1:0]rdata,
	output logic rempty
);
	logic [ADDR_WIDTH-1:0]waddr;
	logic [ADDR_WIDTH-1:0]raddr;
	logic [ADDR_WIDTH:0]wbin;
	logic [ADDR_WIDTH:0]rbin;
	logic [ADDR_WIDTH:0] wptr;
	logic [ADDR_WIDTH:0] rptr;
	logic [ADDR_WIDTH:0]wq2_rptr;
	logic [ADDR_WIDTH:0]rq2_wptr;
	logic wren;
	
	assign wren = winc && !wfull;
	
	fifo_mem #(
	DATA_WIDTH,
	ADDR_WIDTH
	) fifomem1 (
	wclk,
	wren,
	wdata,
	waddr,
	raddr,
	rdata
	);
	
	sync_r2w #(ADDR_WIDTH)
	syncR2W (
	wclk,
	wrst_n,
	rptr,
	wq2_rptr
	);
	
	sync_w2r #(ADDR_WIDTH)
	syncW2R (
	rclk,
	rrst_n,
	wptr,
	rq2_wptr
	);
	
	wrdomain #(ADDR_WIDTH)
	write_domain (
	wclk,
	wrst_n,
	winc,
	wq2_rptr,
	waddr,
	wbin,
	wptr,
	wfull
	);
	
	readomain #(ADDR_WIDTH)
	read_domain(
	rclk,
	rrst_n,
	rinc,
	rq2_wptr,
	raddr,
	rbin,
	rptr,
	rempty
);
	
endmodule