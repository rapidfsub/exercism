const std = @import("std");
const StaticBitSet = std.StaticBitSet;

pub fn primes(buffer: []u32, comptime limit: u32) []u32 {
    var set = StaticBitSet(limit + 1).initFull();
    set.unset(0);
    set.unset(1);

    var n: u32 = 2;
    var i: usize = 0;
    while (n <= limit) : (n += 1) {
        if (set.isSet(n)) {
            buffer[i] = n;
            i += 1;

            var x = 2 * n;
            while (x <= limit) : (x += n) {
                set.unset(x);
            }
        }
    }
    return buffer[0..i];
}
