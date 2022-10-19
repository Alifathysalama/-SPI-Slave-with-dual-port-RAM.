module SPI_SLAVE(MOSI,MISO,SS_n,clk,rstn,rx_data,rx_valid,tx_data,tx_valid);
	//FSM parameters
	parameter IDLE=3'b000;
	parameter CHK_CMD=3'b001;
	parameter WRITE=3'b010;
	parameter READ_ADD=3'b011;
	parameter READ_DATA=3'b100;
	
	//SPI_SLAVE parameters
	input MOSI,SS_n,clk,rstn;
	input [7:0] tx_data;
	input tx_valid;
	output reg rx_valid;
	output reg [9:0] rx_data;
	output reg MISO;
	reg [3:0] counter=4'b0000; 
	reg [3:0] RAM_counter=4'b0000;
	reg [9:0] storage,RAM_storage;
	reg cmd;
	reg data_flag = 0;
	reg rd_flag=0;
	reg check_bit =0;
	reg [2:0] cs,ns;

	//next state logic
	always @(cs,MOSI) begin
		case(cs)
			IDLE: 
			if(SS_n) begin
				ns<=IDLE;
			end
			else begin
				ns<=CHK_CMD;
			end
			CHK_CMD:  begin
				if(~check_bit) begin
					cmd<=MOSI;
					check_bit<=1;
				end
				if (SS_n==0 && cmd == 0 ) begin
					ns<=WRITE;
				end
				else if(SS_n==0 && cmd==1 && rd_flag==0) begin
					ns<=READ_ADD;
				end
				else if(SS_n==0 && cmd==1 && rd_flag==1) begin
					ns<=READ_DATA;
				end
			end
			WRITE:
				if(SS_n==0 && counter !=4'b1010) begin
						storage[counter]<=MOSI;
						counter<=counter+1;
						ns<=WRITE;
				end
				else begin
					counter=4'b0000;
					check_bit<=0;
					ns<=IDLE;
				end
			READ_ADD: 
				if(SS_n==0 && counter!=4'b1010) begin
					storage[counter]<=MOSI;
					counter=counter+1;
					ns<=READ_ADD;
				end
				else begin
					counter=4'b0000;
					check_bit<=0;
					rd_flag<=1;
					ns<=IDLE;
				end
			READ_DATA: 
				if(SS_n==0  && rd_flag==1) begin
					if(counter!=4'b1010 & data_flag==1) begin
						storage[counter]<=MOSI;
						counter<=counter+1;
						ns<=READ_DATA;
					end
				end
				else begin
					rd_flag<=0;
					counter=4'b0000;
					check_bit<=0;
					ns<=IDLE;
				end
			default: ns<=IDLE;
		endcase
	end

	//state memory 
	always @(posedge clk or negedge rstn) begin
		if (~rstn) begin
			cs<=IDLE;
		end
		else  begin
			cs<=ns;
		end
	end

	//output logic
	always @(posedge clk) begin
			case(cs)
				IDLE: rx_data<=0;
				CHK_CMD: rx_data<=0;
				WRITE: begin
					rx_data<=storage;
					//if(counter==4'b1001) begin
					rx_valid<=1;
					//end
				end
				READ_ADD: begin
					rx_data<=storage;
					rx_valid<=1;
				end
				READ_DATA: begin
					// $monitor("tx_valid=%b data_flag=%b RAM_counter=%d",tx_valid,data_flag,RAM_counter);
					rx_data<=storage;
					rx_valid<=1;
					if (tx_valid==1 && RAM_counter!=4'b1010) begin
						data_flag<=1;
						MISO<=tx_data[RAM_counter];
						RAM_counter<=RAM_counter+1;
					end
					else begin
						RAM_counter<=0;
						rd_flag<=0;
						data_flag<=0;
					end
				end
				default: begin	
					rx_data<=0;
					rx_valid<=0;
				end
			endcase
	end
endmodule