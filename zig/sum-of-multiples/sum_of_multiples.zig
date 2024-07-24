const std = @import("std");
const mem = std.mem;
const sort = std.sort;
const ArrayList = std.ArrayList;

pub fn sum(allocator: mem.Allocator, factors: []const u32, limit: u32) !u64 {
    var multiples = ArrayList(u32).init(allocator);
    defer multiples.deinit();
    for (factors) |factor| {
        if (factor > 0) {
            var n = factor;
            while (n < limit) : (n += factor) {
                try multiples.append(n);
            }
        }
    }
    sort.heap(u32, multiples.items, {}, sort.asc(u32));

    var prev: ?u32 = null;
    var result: u64 = 0;
    for (multiples.items) |multiple| {
        if (prev != multiple) {
            result += multiple;
            prev = multiple;
        }
    }
    return result;
}
