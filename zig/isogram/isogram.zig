const std = @import("std");

pub fn isIsogram(str: []const u8) bool {
    var tally: u32 = 0;
    for (str) |letter| {
        if (std.ascii.isAlphabetic(letter)) {
            const exp = std.ascii.toLower(letter) - 'a';
            const bit = std.math.pow(u32, 2, exp);
            if (tally & bit > 0) {
                return false;
            } else {
                tally |= bit;
            }
        }
    }
    return true;
}
