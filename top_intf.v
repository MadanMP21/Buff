`timescale 1ns / 1ps

`define IDX_WIDTH       8
`define DATA_WIDTH      32
`define SIZE            2 ** `IDX_WIDTH - 1
`define SEPARATE_WRITE_PORTS    1
`define SUPPORTS_UPDATE         1
`define READREQ_FIFO_DEPTH      8
`define UPDATE_FIFO_DEPTH       8
`define READRESP_FIFO_DEPTH     8
`define PUSH_FIFO_DEPTH         8

`define SCOREBOARD_SIZE         8
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2023 12:30:30
// Design Name: 
// Module Name: top
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


module top_intf(
    input start_read,
    input start_write,
    input [31:0] Addr_write,
    input [31:0] Addr_read,
    input [31:0] Data_write,
    input INIT_AXI_TXN,
    output ERROR,
    output TXN_DONE,
    input AXI_ACLK,
    input AXI_ARESETN,
    //output [31:0] Data,
    //input push_ready,
    output [31:0]read_data,
    input read_data_ready,
    output read_data_valid,
    input [7:0] read_idx,
    input read_idx_valid,
    output read_idx_ready,
    input read_will_update,
    input [31:0] update_data,
    input update_data_valid,
    input [7:0]update_idx,
    input update_idx_valid,
    output update_ready,
    output update_receive_ack,
    input is_shrink,
    input credit_ready,
    output [7:0] credit_out,
    output credit_valid
);

wire [31:0]AXI_AWADDR;
wire [2:0]AXI_AWPROT;
wire AXI_AWVALID;
wire AXI_AWREADY;
wire [31:0]AXI_WDATA;
wire [3:0]AXI_WSTRB;
wire AXI_WVALID;
wire AXI_WREADY;
wire [1:0]AXI_BRESP;
wire AXI_BVALID;
wire AXI_BREADY;
wire [31:0]AXI_ARADDR;
wire [2:0]AXI_ARPROT;
wire AXI_ARVALID;
wire AXI_ARREADY;
wire [31:0]AXI_RDATA;
wire [1:0]AXI_RRESP;
wire AXI_RVALID;
wire AXI_RREADY;
wire [31:0] push_data1;
wire push_valid1;
wire push_ready1;
wire [31:0]ddr_addr;
wire [31:0]ddr_din;
wire [31:0]ddr_dout;
wire we;
wire re;

buffet b1(
		.clk(AXI_ACLK),
		.nreset_i(AXI_ARESETN),
        .read_data(read_data),
        .read_data_ready(read_data_ready),
        .read_data_valid(read_data_valid),
        .read_idx(read_idx),
        .read_idx_valid(read_idx_valid),
        .read_idx_ready(read_idx_ready),
        .read_will_update(read_will_update),
        .push_data(push_data1),
        .push_data_valid(push_valid1),
        .push_data_ready(push_ready1),
        .update_data(update_data),
        .update_data_valid(update_data_valid),
        .update_idx(update_idx),
        .update_idx_valid(update_idx_valid),
        .update_ready(update_ready),
        .update_receive_ack(update_receive_ack),
        .is_shrink(is_shrink),
        .credit_ready(credit_ready),
        .credit_out(credit_out),
        .credit_valid(credit_valid)
        );

masteraxi m1(
		.start_read(start_read),
		.start_write(start_write),
        .Addr1(Addr_write),
        .Addr2(Addr_read),
        .Data_in(Data_write),
        //.Data(Data),
        .push_ready(push_ready1),
        .push_valid(push_valid1),
        .push_data(push_data1),
		.INIT_AXI_TXN(INIT_AXI_TXN),
		.ERROR(ERROR),
	    .TXN_DONE(TXN_DONE),
		.M_AXI_ACLK(AXI_ACLK),
		.M_AXI_ARESETN(AXI_ARESETN),
		.M_AXI_AWADDR(AXI_AWADDR),
		.M_AXI_AWPROT(AXI_AWPROT),
		.M_AXI_AWVALID(AXI_AWVALID),
		.M_AXI_AWREADY(AXI_AWREADY),
		.M_AXI_WDATA(AXI_WDATA),
		.M_AXI_WSTRB(AXI_WSTRB),
		.M_AXI_WVALID(AXI_WVALID),
		.M_AXI_WREADY(AXI_WREADY),
		.M_AXI_BRESP(AXI_BRESP),
		.M_AXI_BVALID(AXI_BVALID),
		.M_AXI_BREADY(AXI_BREADY),
		.M_AXI_ARADDR(AXI_ARADDR),
		.M_AXI_ARPROT(AXI_ARPROT),
		.M_AXI_ARVALID(AXI_ARVALID),
		.M_AXI_ARREADY(AXI_ARREADY),
		.M_AXI_RDATA(AXI_RDATA),
		.M_AXI_RRESP(AXI_RRESP),
		.M_AXI_RVALID(AXI_RVALID),
		.M_AXI_RREADY(AXI_RREADY)
		);
		
slaveaxi s1(
        .ddr_addr(ddr_addr),
        .ddr_din(ddr_din),
        .ddr_dout(ddr_dout),
        .we(we),
        .re(re),
		.S_AXI_ACLK(AXI_ACLK),
		.S_AXI_ARESETN(AXI_ARESETN),
		.S_AXI_AWADDR(AXI_AWADDR),
		.S_AXI_AWPROT(AXI_AWPROT),
		.S_AXI_AWVALID(AXI_AWVALID),
		.S_AXI_AWREADY(AXI_AWREADY),
		.S_AXI_WDATA(AXI_WDATA),
		.S_AXI_WSTRB(AXI_WSTRB),
		.S_AXI_WVALID(AXI_WVALID),
		.S_AXI_WREADY(AXI_WREADY),
		.S_AXI_BRESP(AXI_BRESP),
		.S_AXI_BVALID(AXI_BVALID),
		.S_AXI_BREADY(AXI_BREADY),
		.S_AXI_ARADDR(AXI_ARADDR),
		.S_AXI_ARPROT(AXI_ARPROT),
		.S_AXI_ARVALID(AXI_ARVALID),
		.S_AXI_ARREADY(AXI_ARREADY),
		.S_AXI_RDATA(AXI_RDATA),
		.S_AXI_RRESP(AXI_RRESP),
		.S_AXI_RVALID(AXI_RVALID),
		.S_AXI_RREADY(AXI_RREADY)
        );
ddr ddr1(
        .clk(AXI_ACLK),
        .rstn(AXI_ARESETN),
        .addr(ddr_addr),
        .data_in(ddr_dout),
        .data_out(ddr_din),
        .we(we),
        .re(re)
         );      
        

endmodule
