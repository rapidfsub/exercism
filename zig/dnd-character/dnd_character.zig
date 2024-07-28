const std = @import("std");
const time = std.time;
const Random = std.Random;

pub fn modifier(score: i8) i8 {
    return @divFloor(score - 10, 2);
}

pub fn ability() i8 {
    var prng = Random.DefaultPrng.init(@as(u64, @intCast(time.timestamp())));
    var rand = prng.random();
    var sum: i8 = 0;
    var min: i8 = 7;
    for (0..4) |_| {
        const die = rand.intRangeAtMost(i8, 1, 6);
        sum += die;
        min = @min(min, die);
    }
    return sum - min;
}

pub const Character = struct {
    strength: i8,
    dexterity: i8,
    constitution: i8,
    intelligence: i8,
    wisdom: i8,
    charisma: i8,
    hitpoints: i8,

    pub fn init() Character {
        const constitution = ability();
        return Character{
            .strength = ability(),
            .dexterity = ability(),
            .constitution = constitution,
            .intelligence = ability(),
            .wisdom = ability(),
            .charisma = ability(),
            .hitpoints = modifier(constitution) + 10,
        };
    }
};
