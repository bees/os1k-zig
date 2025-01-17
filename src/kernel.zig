const bss = @extern([*]u8, .{ .name = "__bss" });
const bss_end = @extern([*]u8, .{ .name = "__bss_end" });
const stack_top = @extern([*]u8, .{ .name = "__stack_top" });

export fn kernel_main() noreturn {
    const bss_len = bss_end - bss;
    @memset(bss[0..bss_len], 0);

    const hello = "well hello there!\n";

    for (hello) |c| _ = sbi_call(c, 0, 0, 0, 0, 0, 0, 1);

    while (true) asm volatile ("wfi");
}

export fn boot() linksection(".text.boot") callconv(.naked) void {
    asm volatile (
        \\mv sp, %[stack_top]
        \\j kernel_main
        :
        : [stack_top] "r" (stack_top),
    );
}

const SbiRet = struct {
    err: usize,
    value: usize,
};

fn sbi_call(
    arg0: usize,
    arg1: usize,
    arg2: usize,
    arg3: usize,
    arg4: usize,
    arg5: usize,
    extension_id: usize,
    function_id: usize,
) SbiRet {
    var err: usize = undefined;
    var value: usize = undefined;
    asm volatile ("ecall"
        : [value] "={a0}" (value),
          [err] "={a1}" (err),
        : [arg0] "{a0}" (arg0),
          [arg1] "{a1}" (arg1),
          [arg2] "{a2}" (arg2),
          [arg3] "{a3}" (arg3),
          [arg4] "{a4}" (arg4),
          [arg5] "{a5}" (arg5),
          [eid] "{a6}" (extension_id),
          [fid] "{a7}" (function_id),
        : "memory"
    );

    return .{ .err = err, .value = value };
}
