all: boot.bin

boot.bin: system.dtb bootgen.bif system.bit system.bit uImage.bin u-boot.elf
	bootgen -image bootgen.bif -w -o i boot.bin

boot_bit.bin: system.dtb bootgen_bitonly.bif system.bit uImage.bin u-boot.elf
	bootgen -image bootgen_bitonly.bif -w -o i boot_bit.bin

system.dtb: ./devicetree/pl.dtsi ./devicetree/skeleton.dtsi ./devicetree/system.dts ./devicetree/zynq-7000.dtsi
	dtc -I dts -O dtb ./devicetree/system.dts -o system.dtb
	dtc -I dtb -O dts system.dtb -o generated.dts

copy_bit:
	cp ../clock_fpga/clock_fpga.runs/impl_1/hw_block_wrapper.bit ./system.bit

copy_fsbl:
	cp ../clock_fpga/clock_fpga.sdk/fsbl/Release/fsbl.elf ./fsbl.elf

copy_uboot:
	cp ../u-boot-xlnx/u-boot ./u-boot.elf

copy_kernel:
	cp ../linux-xlnx/arch/arm/boot/uImage ./uImage.bin

copy_dts:
	mkdir -p devicetree
	cp ../clock_fpga/clock_fpga.sdk/device_tree_bsp_clock/*.dts* ./devicetree/

copy_all: copy_bit copy_fsbl copy_uboot copy_kernel

clean:
	rm -f system.dtb boot.bin generated.dts

distclean: clean
	rm -f FSBL.elf fsbl.elf u-boot.elf uImage.bin devicetree.dtb


