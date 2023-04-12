`timescale 1ns / 1ps

    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 26.03.2023 20:04:53
    // Design Name: 
    // Module Name: tb_test1
    // Project Name: 
    // Target Devices: 
    // Tool Versions: 
    // Description: 
    // 
    // Dependencies: 
    // 
    // Revision:
    // Revision 0.01 - File Created
    // Additional Comments:
    // 
    //////////////////////////////////////////////////////////////////////////////////
    
    
    module tb_top_intf;
    
        reg  [31:0]Addr_write;
        reg  [31:0]Addr_read;
        //wire [31:0]Data;
        reg  [31:0]Data_write;
        wire ERROR;
        reg  INIT_AXI_TXN;
        wire TXN_DONE;
        reg  clk;
        reg  resetn;
        reg  start_read;
        reg  start_write;
        //reg  push_ready;
        //wire push_valid;
        //wire [31:0] push_data;
        wire [31:0]read_data;
        reg read_data_ready;
        wire read_data_valid;
        reg [7:0] read_idx;
        reg read_idx_valid;
        wire read_idx_ready;
        reg read_will_update;
        reg [31:0] update_data;
        reg update_data_valid;
        reg [7:0]update_idx;
        reg update_idx_valid;
        wire update_ready;
        wire update_receive_ack;
        reg is_shrink;
        reg credit_ready;
        wire [7:0] credit_out;
        wire credit_valid;
        
        top_intf dut(
            .Addr_write(Addr_write),
            .Addr_read(Addr_read),
            //.Data(Data),
            .Data_write(Data_write),
            .ERROR(ERROR),
            .INIT_AXI_TXN(INIT_AXI_TXN),
            .TXN_DONE(TXN_DONE),
            .AXI_ACLK(clk),
            .AXI_ARESETN(resetn),
            .start_read(start_read),
            .start_write(start_write),
            .read_idx_valid(read_idx_valid),
            .read_idx(read_idx),
            .read_idx_ready(read_idx_ready),
            .read_data_valid(read_data_valid),
            .read_data(read_data),
            .read_data_ready(read_data_ready),
            .read_will_update(read_will_update),
            .is_shrink(is_shrink),
            .credit_valid(credit_valid),
            .credit_out(credit_out),
            .credit_ready(credit_ready),
            .update_idx(update_idx),
            .update_idx_valid(update_idx_valid),
            .update_data(update_data),
            .update_data_valid(update_data_valid),
            .update_ready(update_ready),
            .update_receive_ack(update_receive_ack)
            );
            
            always #5 clk =~ clk;
           
           
            task Task_init;
                begin
                    clk = 0;
                    resetn = 0;
                    INIT_AXI_TXN = 1;
                    read_idx = 3'b000;
                    read_idx_valid = 0;
                    read_data_ready = 1;
                    read_will_update = 1;
                    is_shrink = 0;
                    credit_ready = 1;
                    update_idx_valid = 0;
                    update_data_valid = 0;    
                end
            endtask
           
            task Task_write;
                begin
                   start_write = 1;
                   #20
                   start_write = 0; 
                end
                endtask
             
            task Task_read;
                begin
                   start_read = 1;
                   #20
                   start_read = 0; 
                end
            endtask
            
            task Task_read_req;
                begin
                    read_idx_valid = 1;
                    #20
                    read_idx_valid = 0;
                end
            endtask
            
            task Task_update;
                begin
                    update_idx_valid = 1;
                    update_data_valid = 1;
                    #20
                    update_idx_valid = 0;
                    update_data_valid = 0;
                end
            endtask

            task Task_shrink;
                begin
                    is_shrink = 1;
                    read_idx_valid = 1;
                    #20
                    is_shrink = 0;
                    read_idx_valid = 1;
                end
            endtask           
            
            initial begin
               Task_init;
               Addr_write = 32'h00000002;
               Data_write = 32'h00000010;
               start_read = 0;
               start_write = 1;
               #30 
               resetn = 1;
               #60
               Addr_write = 32'h00000001;
               Data_write = 32'h00000011;
               #30
               Task_write;
               #30
               Addr_write = 32'h00000003;
               Data_write = 32'h00000001;
               #30
               Task_write;
               #30
               Addr_read = 32'h00000001;
               #30
               Task_read;
               #30
               Addr_read = 32'h00000002;
               #30
               Task_read;
               #90
               Task_read_req;
               #30
               read_idx = 3'b001;
               #90
               Task_read_req;
               #30
               read_idx = 3'b000;
               #90
               Task_read_req;
               #30
               update_idx = 3'b000;
               update_data = 32'h00000021;
               #90
               Task_update;
              end
    endmodule