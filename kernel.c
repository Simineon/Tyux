#include "kernel.h"

extern unsigned long _bss_start;
extern unsigned long _bss_end;
extern unsigned long _stack_top;

static void delay(unsigned long count) {
    for (volatile unsigned long i = 0; i < count; i++);
}

void kernel_print_char(char ch) {
    sbi_call(ch, 0, 0, 0, 0, 0, 0, 0x1);
}

void kernel_print(const char *s) {
    while (*s) {
        kernel_print_char(*s++);
    }
}

struct sbiret sbi_call(long arg0, long arg1, long arg2, long arg3,
                       long arg4, long arg5, long fid, long eid) {
    register long a0 __asm__("a0") = arg0;
    register long a1 __asm__("a1") = arg1;
    register long a2 __asm__("a2") = arg2;
    register long a3 __asm__("a3") = arg3;
    register long a4 __asm__("a4") = arg4;
    register long a5 __asm__("a5") = arg5;
    register long a6 __asm__("a6") = fid;
    register long a7 __asm__("a7") = eid;

    __asm__ __volatile__("ecall"
                         : "+r"(a0), "+r"(a1)
                         : "r"(a2), "r"(a3), "r"(a4), "r"(a5), "r"(a6), "r"(a7)
                         : "memory");
    
    return (struct sbiret){a0, a1};
}

void kernel_main(void) {
    kernel_print("\n\n================================\n");
    kernel_print("Hello from Tyux OS!\n");
    kernel_print("Kernel is running successfully!\n");
    kernel_print("Version: Cmd 0.1.0\n");
    kernel_print("================================\n\n");
    
    kernel_print("Booting");
    for (int i = 0; i < 5; i++) {
        kernel_print_char('.');
        delay(500000);
    }
    
    kernel_print("\nSystem ready!\n");
    
    while (1) {
        asm volatile("wfi");
    }
}