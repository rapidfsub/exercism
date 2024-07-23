const std = @import("std");
const mem = std.mem;
const ascii = std.ascii;
const ArrayList = std.ArrayList;

pub fn abbreviate(allocator: mem.Allocator, words: []const u8) mem.Allocator.Error![]u8 {
    var list = ArrayList(u8).init(allocator);
    defer list.deinit();

    var ws = mem.tokenizeAny(u8, words, " _-");
    while (ws.next()) |w| {
        try list.append(ascii.toUpper(w[0]));
    }
    return list.toOwnedSlice();
}
