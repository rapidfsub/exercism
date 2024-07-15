pub fn isValid(s: []const u8) bool {
    var i: usize = 1;
    var j: u32 = 0;
    var sum: u32 = 0;
    while (i <= s.len) : (i += 1) {
        const letter = s[s.len - i];
        if (letter >= '0' and letter <= '9') {
            const n = letter - '0';
            if (@rem(j, 2) == 0) {
                sum += n;
            } else if (n < 5) {
                sum += 2 * n;
            } else {
                sum += 2 * n - 9;
            }
            j += 1;
        } else if (letter != ' ') {
            return false;
        }
    }
    return j > 1 and @rem(sum, 10) == 0;
}
