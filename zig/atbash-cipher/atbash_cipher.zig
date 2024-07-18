const std = @import("std");
const ArrayList = std.ArrayList;
const ascii = std.ascii;
const mem = std.mem;

/// Encodes `s` using the Atbash cipher. Caller owns the returned memory.
pub fn encode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    return try transform(allocator, s, true);
}

/// Decodes `s` using the Atbash cipher. Caller owns the returned memory.
pub fn decode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    return try transform(allocator, s, false);
}

fn transform(allocator: mem.Allocator, s: []const u8, comptime encoding: bool) mem.Allocator.Error![]u8 {
    var result = ArrayList(u8).init(allocator);
    for (s) |letter| {
        if (ascii.isAlphanumeric(letter)) {
            inline while (encoding) {
                if (@rem(result.items.len, 6) == 5) {
                    try result.append(' ');
                }
                break;
            }
            try result.append(switch (letter) {
                '0'...'9' => letter,
                else => 'z' - ascii.toLower(letter) + 'a',
            });
        }
    }
    return result.toOwnedSlice();
}
