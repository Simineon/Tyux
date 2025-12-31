.section .text.init
.globl _start

_start:
    # Установка указателя стека
    la sp, _stack_top
    
    # Очистка BSS
    la t0, _bss_start
    la t1, _bss_end
    bgeu t0, t1, bss_done

bss_loop:
    sd zero, 0(t0)
    addi t0, t0, 8
    bltu t0, t1, bss_loop

bss_done:
    # Вызов kernel_main
    call kernel_main
    
    # Бесконечный цикл если kernel_main вернется
1:  wfi
    j 1b