const std = @import("std");
const mem = std.mem;
const ArrayList = std.ArrayList;

pub const Signal = enum(u32) {
    wink = 1,
    double_blink = 2,
    close_your_eyes = 4,
    jump = 8,
};

pub fn calculateHandshake(allocator: mem.Allocator, number: u5) mem.Allocator.Error![]const Signal {
    var result = ArrayList(Signal).init(allocator);
    defer result.deinit();

    const bits: [4]u32 = switch (number & 16) {
        0 => .{ 1, 2, 4, 8 },
        else => .{ 8, 4, 2, 1 },
    };
    for (bits) |bit| {
        const signal: Signal = @enumFromInt(bit);
        if (number & bit > 0) {
            try result.append(signal);
        }
    }
    return result.toOwnedSlice();
}
