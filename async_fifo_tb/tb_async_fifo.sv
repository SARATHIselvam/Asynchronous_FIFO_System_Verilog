module tb_async_fifo;
    import tb_pkg::*;

    async_fifo_if #(DATA_WIDTH) fifo_if();

    async_fifo #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) dut (
        .wclk(fifo_if.wclk),
	    .wrst_n(fifo_if.wrst_n),
	    .winc(fifo_if.winc),
	    .wdata(fifo_if.wdata),
	    .wfull(fifo_if.wfull),
	    .rclk(fifo_if.rclk),
	    .rrst_n(fifo_if.rrst_n),
	    .rinc(fifo_if.rinc),
	    .rdata(fifo_if.rdata),
	    .rempty(fifo_if.rempty)
    );

    initial begin
        fifo_if.wclk = 0;
        forever #5 fifo_if.wclk = ~fifo_if.wclk;
    end

    initial begin
        fifo_if.rclk = 0;
        forever #7 fifo_if.rclk = ~fifo_if.rclk;
    end

    initial begin
        fifo_if.wrst_n=0;
        fifo_if.rrst_n=0;

        fifo_if.winc=0;
        fifo_if.rinc=0;
        fifo_if.wdata=0;

        repeat(5)
            @(posedge fifo_if.wclk);
        fifo_if.wrst_n=1;
        fifo_if.rrst_n=1;
    end

    task automatic fifo_write(input data_t data);

    while (fifo_if.wfull)
        @(posedge fifo_if.wclk);

    fifo_if.winc  <= 1'b1;
    fifo_if.wdata <= data;

    @(posedge fifo_if.wclk);

    fifo_if.winc <= 1'b0;

    endtask 

    data_t actual_data;
    data_t expected_data;
    data_t ref_queue[$];

    integer pass_count;
    integer fail_count;

    task automatic fifo_read();

    while (fifo_if.rempty)
        @(posedge fifo_if.rclk);

    // Data currently pointed to
    actual_data = fifo_if.rdata;

    fifo_if.rinc <= 1'b1;

    @(posedge fifo_if.rclk);
    #1;
    fifo_if.rinc <= 1'b0;

    if (ref_queue.size() == 0) begin
        $error("Reference queue empty");
        fail_count++;
        return;
    end

    expected_data = ref_queue.pop_front();

    if (actual_data === expected_data) begin
        pass_count++;
        $display("[%0t] PASS expected=%02h actual=%02h",
                 $time, expected_data, actual_data);
    end
    else begin
        fail_count++;
        $display("[%0t] FAIL expected=%02h actual=%02h",
                 $time, expected_data, actual_data);
    end

    endtask
    
 

    always @(posedge fifo_if.wclk) begin

        if(fifo_if.winc && !fifo_if.wfull)begin
            ref_queue.push_back(fifo_if.wdata);

            $display("[%0t] REF WRITE: %02h", $time, fifo_if.wdata);        
        end
    end



 

    initial begin
        pass_count = 0;
        fail_count = 0;
        wait (fifo_if.wrst_n && fifo_if.rrst_n);
        $display("\n======================================");
        $display("Starting the Verification");
        $display("=====================================\n");
        $display("Basic write and read test");

        fifo_write(8'h11);
        fifo_write(8'h22);
        fifo_write(8'h33);
        
        fifo_read();
        fifo_read();
        fifo_read();

        repeat (3)
            @(posedge fifo_if.wclk);

        $display("FIFO FULL TEST");

        repeat(16)
            fifo_write($urandom);

        wait(fifo_if.wfull);

        $display("FIFO FULL ASSERTED");

        while(!fifo_if.rempty)
            fifo_read();

        $display("FIFO EMPTY");

        $display("PASS COUNT = %0h",pass_count);
        $display("FAIL COUNT = %0h", fail_count);


        $finish;
    end

endmodule