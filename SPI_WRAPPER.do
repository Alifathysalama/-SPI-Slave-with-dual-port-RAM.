vlib work
vlog SPI_SLAVE.v RAMP.v SPI_WRAPPER_tb.v
vsim -voptargs=+acc work.SPI_WRAPPER_tb
add wave *
add wave -position insertpoint  \
sim:/SPI_WRAPPER_tb/SPI/cs \
sim:/SPI_WRAPPER_tb/SPI/ns \
sim:/SPI_WRAPPER_tb/RAM2/mem
run -all