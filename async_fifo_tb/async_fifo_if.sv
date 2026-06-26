interface async_fifo_if #(parameter DATA_WIDTH = 8);

    logic wclk;
    logic wrst_n;
    logic winc;
    logic [DATA_WIDTH-1:0] wdata;
    logic wfull;

    logic rclk;
    logic rrst_n;
    logic rinc;
    logic [DATA_WIDTH-1:0] rdata;
    logic rempty;

endinterface