const std = @import("std");

pub const ChessboardError = error{IndexOutOfBounds};

pub fn square(index: usize) ChessboardError!u64 {
    return switch (index) {
        1...64 => std.math.pow(u64, 2, index - 1),
        else => ChessboardError.IndexOutOfBounds,
    };
}

pub fn total() u64 {
    var result: u64 = 0;
    for (1..65) |index| {
        result += square(index) catch unreachable;
    }
    return result;
}
