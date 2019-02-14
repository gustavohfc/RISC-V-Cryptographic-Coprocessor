vcom -93 -work work {C:/Users/gusta/git/RISC-V/testbench/RISCV_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneive -L rtl_work -L work -voptargs="+acc"  RISCV_tb

add wave *
view structure
view signals
run 1 ns
mem save -outfile $mem_dump.txt
