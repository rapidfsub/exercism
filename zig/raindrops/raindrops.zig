const std = @import("std");

pub fn convert(buffer: []u8, n: u32) []const u8 {
    var stream = std.io.fixedBufferStream(buffer);
    inline for (.{ 3, 5, 7 }) |factor| {
        const sound = switch (factor) {
            3 => "Pling",
            5 => "Plang",
            7 => "Plong",
            else => unreachable,
        };
        if (@rem(n, factor) == 0) {
            stream.writer().writeAll(sound) catch unreachable;
        }
    }
    if (stream.pos == 0) {
        stream.writer().print("{}", .{n}) catch unreachable;
    }
    return stream.getWritten();
}
