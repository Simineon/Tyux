OUTPUT_ARCH(riscv)
ENTRY(_start)

SECTIONS
{
    . = 0x80200000;
    
    .text.init : {
        *(.text.init)
    }
    
    .text : {
        *(.text .text.*)
    }
    
    .rodata : {
        *(.rodata .rodata.*)
    }
    
    .data : {
        *(.data .data.*)
    }
    
    .bss : ALIGN(8) {
        _bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        _bss_end = .;
    }
    
    /* Стек 64KB */
    .stack : ALIGN(16) {
        _stack_bottom = .;
        . = . + 64K;
        _stack_top = .;
    }
    
    /DISCARD/ : {
        *(.eh_frame)
        *(.note.*)
        *(.comment)
    }
}