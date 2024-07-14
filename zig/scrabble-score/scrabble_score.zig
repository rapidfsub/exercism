const ascii = @import("std").ascii;
pub fn score(s: []const u8) u32 {
    var result: u32 = 0;
    for (s) |letter| {
        result += switch (ascii.toUpper(letter)) {
            'A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T' => 1,
            'D', 'G' => 2,
            'B', 'C', 'M', 'P' => 3,
            'F', 'H', 'V', 'W', 'Y' => 4,
            'K' => 5,
            'J', 'X' => 8,
            'Q', 'Z' => 10,
            else => 0,
        };
    }
    return result;
}
