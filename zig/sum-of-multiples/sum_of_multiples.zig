const std = @import("std");
const mem = std.mem;
const DynamicBitSet = std.bit_set.DynamicBitSet;

pub fn sum(allocator: mem.Allocator, factors: []const u32, limit: u32) !u64 {
    var multiples = try DynamicBitSet.initEmpty(allocator, limit);
    defer multiples.deinit();
    for (factors) |factor| {
        if (factor == 0) {
            continue;
        }
        var n = factor;
        while (n < limit) : (n += factor) {
            multiples.set(n);
        }
    }
    var iter = multiples.iterator(.{});
    var result: u64 = 0;
    while (iter.next()) |multiple| {
        result += multiple;
    }
    return result;
}
