const std = @import("std");

pub const DnaError = error{
    EmptyDnaStrands,
    UnequalDnaStrands,
};

pub fn compute(first: []const u8, second: []const u8) DnaError!usize {
    if (first.len < 1 or second.len < 1) {
        return DnaError.EmptyDnaStrands;
    } else if (first.len != second.len) {
        return DnaError.UnequalDnaStrands;
    } else {
        var result: usize = 0;
        for (first, second) |lhs, rhs| {
            if (lhs != rhs) {
                result += 1;
            }
        }
        return result;
    }
}
