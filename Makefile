CC = riscv64-unknown-elf-gcc
AS = riscv64-unknown-elf-as
CFLAGS = -march=rv64imafd -mabi=lp64d -mcmodel=medany -nostdlib -ffreestanding -Wall -Wextra -O1 -I.
ASFLAGS = -march=rv64imafd -mabi=lp64d
LDFLAGS = -T kernel.ld -nostdlib -static -Wl,--gc-sections

SRCS = kernel.c
ASMSRCS = asm/start.asm


OBJS = build/kernel.o build/start.o
TARGET = build/kernel.elf
BINARY = build/kernel.bin

$(shell mkdir -p build)

all: $(BINARY)

$(TARGET): $(OBJS) kernel.ld
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS)

$(BINARY): $(TARGET)
	riscv64-unknown-elf-objcopy -O binary $(TARGET) $(BINARY)

build/%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

build/start.o: asm/start.asm
	$(AS) $(ASFLAGS) -c -o $@ $<

clean:
	rm -rf build/*

run: $(BINARY)
	qemu-system-riscv64 -machine virt \
		-nographic \
		-bios default \
		-kernel $(BINARY) \
		-smp 1 \
		-m 128M

debug: $(BINARY)
	qemu-system-riscv64 -machine virt \
		-nographic \
		-bios default \
		-kernel $(BINARY) \
		-smp 1 \
		-m 128M \
		-s -S

disasm: $(TARGET)
	riscv64-unknown-elf-objdump -D $(TARGET)

size: $(TARGET)
	riscv64-unknown-elf-size $(TARGET)

.PHONY: all clean run debug disasm size