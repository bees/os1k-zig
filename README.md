This repo tracks my effort in implementing [Operating System in 1,000
Lines](https://operating-system-in-1000-lines.vercel.app/en/) in Zig.


`zig build run` will launch QEMU


QEMU cheatsheet
```
C-a c    switch between console and monitor
C-a h    print this help
C-a x    exit emulator
C-a s    save disk data back to file (if -snapshot)
C-a t    toggle console timestamps
C-a b    send break (magic sysrq)
C-a C-a  sends C-a
```


## progression log (newest first)

### 2025-01-17

launched the empty kernel and checked the program counter
```
(qemu) info registers

CPU#0
 V      =   0
 pc       80200034
...
```
checking that address in the kernel elf dump:

```objdump
...
80200034: a001          j       0x80200034 <kernel_main+0x24>
...
```

yay :)
