pub const Classification = enum {
    deficient,
    perfect,
    abundant,
};

/// Asserts that `n` is nonzero.
pub fn classify(n: u64) Classification {
    var sum: u64 = 0;
    for (1..n) |k| {
        if (@rem(n, k) == 0) {
            sum += k;
        }
    }

    if (n < sum) {
        return .abundant;
    } else if (n == sum) {
        return .perfect;
    } else {
        return .deficient;
    }
}
