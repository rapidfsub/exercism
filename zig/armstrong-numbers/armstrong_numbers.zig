const std = @import("std");

pub fn isArmstrongNumber(num: u128) bool {
    if (num > 0) {
        const exp = std.math.log10(num) + 1;
        var n = num;
        var acc: u128 = 0;
        while (n > 0) : (n /= 10) {
            const digit = n % 10;
            acc += std.math.pow(u128, digit, exp);
        }
        return num == acc;
    } else {
        return true;
    }
}
