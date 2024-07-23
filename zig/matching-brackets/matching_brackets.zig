const std = @import("std");
const mem = std.mem;
const ArrayList = std.ArrayList;

pub fn isBalanced(allocator: mem.Allocator, s: []const u8) !bool {
    var stack = ArrayList(u8).init(allocator);
    defer stack.deinit();
    for (s) |letter| {
        switch (letter) {
            '(', '{', '[' => try stack.append(letter),
            inline ')', '}', ']' => |close| {
                const open = switch (close) {
                    ')' => '(',
                    '}' => '{',
                    ']' => '[',
                    else => unreachable,
                };
                if (stack.popOrNull() != open) {
                    return false;
                }
            },
            else => {},
        }
    }
    return stack.items.len == 0;
}
