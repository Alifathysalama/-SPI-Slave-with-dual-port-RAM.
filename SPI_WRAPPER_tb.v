module SPI_WRAPPER_tb();
	//SPI_SLAVE
	reg  MOSI,SS_n,clk,rstn;
	wire rx_valid_SPI,MISO;
	wire [9:0] rx_data;
	//RAM
	reg rst_n;
	wire [7:0] dout;
	wire tx_valid_RAM=1;

	integer i;

	RAMP RAM2 (rx_data,rx_valid_SPI,clk,rst_n,dout,tx_valid_RAM);
	SPI_SLAVE SPI (MOSI,MISO,SS_n,clk,rstn,rx_data,rx_valid_SPI,dout,tx_valid_RAM);

	initial begin
		clk=0;
		forever
		#1 clk=~clk;
	end

	initial begin
		$monitor("MOSI=%b MISO=%b rx_data=%b rx_valid_SPI=%b  tx_valid_RAM=%b ",MOSI,MISO,rx_data,rx_valid_SPI,tx_valid_RAM);
	end

	initial begin
		$readmemh("RAMP.dat",RAM2.mem);
		for(i=0;i<10000;i=i+1) begin
			rstn=0;
			rst_n=0;
			#50
			rstn=1;
			rst_n=1;
			SS_n=1;
		//wr_addr
			MOSI=0;
			#10
			SS_n=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=0;
			#2
			MOSI=0;
			//din
			#2
			MOSI=0;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=1;
			#2
			MOSI=0;
			//rd_add
			#2
			MOSI=1;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=0;
			#2
			MOSI=1;
			//rd_data
			#2
			MOSI=1;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=$random;
			#2
			MOSI=1;
			#2
			MOSI=1;
			#2
			SS_n=1;
			#100;
		end
		$stop;
	end
endmodule