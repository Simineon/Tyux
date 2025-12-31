#ifndef KERNEL_H
#define KERNEL_H

struct sbiret {
    long error;
    long value;
};

struct sbiret sbi_call(long arg0, long arg1, long arg2, long arg3,
                       long arg4, long arg5, long fid, long eid);

void kernel_print_char(char ch);
void kernel_print(const char *s);

void kernel_main(void);

#endif