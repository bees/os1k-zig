const std = @import("std");

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

pub const console: std.io.AnyWriter = .{
    .context = undefined,
    .writeFn = write_fn,
};

fn write_fn(_: *const anyopaque, bytes: []const u8) !usize {
    for (bytes) |c| _ = sbi_call(c, 0, 0, 0, 0, 0, 0, 1);
    return bytes.len;
}
