const std = @import("std");
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
    var buffer = try allocator.alloc(u8, s.len * 2);
    defer allocator.free(buffer);

    var i: usize = 0;
    for (s) |letter| {
        if (ascii.isAlphanumeric(letter)) {
            inline while (encoding) {
                if (@rem(i, 6) == 5) {
                    buffer[i] = ' ';
                    i += 1;
                }
                break;
            }

            if ((letter >= '0' and letter <= '9')) {
                buffer[i] = letter;
            } else {
                buffer[i] = 'z' - ascii.toLower(letter) + 'a';
            }
            i += 1;
        }
    }

    const result = try allocator.alloc(u8, i);
    mem.copyForwards(u8, result, buffer[0..i]);
    return result;
}
