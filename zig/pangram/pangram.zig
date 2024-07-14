const std = @import("std");

pub fn isPangram(str: []const u8) bool {
    var tally: u32 = 0;
    for (str) |letter| {
        if (std.ascii.isAlphabetic(letter)) {
            const exp = std.ascii.toLower(letter) - 'a';
            tally |= std.math.pow(u32, 2, exp);
        }
    }
    return tally == 0x3_FF_FF_FF;
}
