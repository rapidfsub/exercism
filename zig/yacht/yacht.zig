pub const Category = enum {
    ones,
    twos,
    threes,
    fours,
    fives,
    sixes,
    full_house,
    four_of_a_kind,
    little_straight,
    big_straight,
    choice,
    yacht,
};

pub fn score(dice: [5]u3, category: Category) u32 {
    var counts: [7]u32 = .{ 0, 0, 0, 0, 0, 0, 0 };
    var sum: u32 = 0;
    for (dice) |die| {
        counts[die] += 1;
        sum += die;
    }

    var meta: [6]u32 = .{ 0, 0, 0, 0, 0, 0 };
    for (counts) |count| {
        meta[count] += 1;
    }

    return switch (category) {
        .ones => counts[1],
        .twos => counts[2] * 2,
        .threes => counts[3] * 3,
        .fours => counts[4] * 4,
        .fives => counts[5] * 5,
        .sixes => counts[6] * 6,
        .full_house => if (meta[2] > 0 and meta[3] > 0) sum else 0,
        .four_of_a_kind => for (counts, 0..) |count, die| {
            if (count > 3) break @as(u32, @intCast(die)) * 4;
        } else 0,
        .little_straight => for (counts, 0..) |count, die| {
            if (die > 0 and die < 6 and count < 1) break 0;
        } else 30,
        .big_straight => for (counts, 0..) |count, die| {
            if (die > 1 and count < 1) break 0;
        } else 30,
        .choice => sum,
        .yacht => if (meta[5] > 0) 50 else 0,
    };
}
