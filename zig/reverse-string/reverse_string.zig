const std = @import("std");

/// Writes a reversed copy of `s` to `buffer`.
pub fn reverse(buffer: []u8, s: []const u8) []u8 {
    var iter = std.mem.reverseIterator(s);
    var i: usize = 0;
    while (iter.next()) |letter| : (i += 1) {
        buffer[i] = letter;
    }
    return buffer;
}
