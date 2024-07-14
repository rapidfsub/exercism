pub fn isValidIsbn10(s: []const u8) bool {
    var sum: i64 = 0;
    var c: i64 = 10;
    for (s) |letter| {
        if (letter >= '0' and letter <= '9') {
            sum += (letter - '0') * c;
            c -= 1;
        } else if (c == 1 and letter == 'X') {
            sum += 10;
            c -= 1;
        } else if (letter != ' ' and letter != '-') {
            return false;
        }
    }
    return c == 0 and @rem(sum, 11) == 0;
}
