module RAMP (din,rx_valid,clk,rst_n,dout,tx_valid);
	parameter MEM_DEPTH=256;
	parameter ADDR_SIZE=8;	
	input [9:0] din;
	input rx_valid,clk,rst_n;
	output reg [7:0] dout;
	output reg tx_valid;
	reg [7:0] rd_addr;
	reg [7:0] wr_addr;

	reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];

	always @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			dout<=0;
		end
		else if(rx_valid) begin
			if(din[9:8]==2'b00) begin
				wr_addr<=din[7:0];	
			end
			else if(din[9:8]==2'b01) begin
				mem[wr_addr]<=din[7:0];
			end
			else if(din[9:8]==2'b10) begin
				rd_addr<=din[7:0];
			end
			else if(din[9:8]==2'b11) begin
				dout<=mem[rd_addr];
				tx_valid<=1;
			end
		end
	end

endmodule