pub const Planet = enum {
    mercury,
    venus,
    earth,
    mars,
    jupiter,
    saturn,
    uranus,
    neptune,

    pub fn age(self: Planet, seconds: usize) f64 {
        const pairs = .{
            .{ Planet.mercury, 0.240_846_7 },
            .{ Planet.venus, 0.615_197_26 },
            .{ Planet.earth, 1.0 },
            .{ Planet.mars, 1.880_815_8 },
            .{ Planet.jupiter, 11.862_615 },
            .{ Planet.saturn, 29.447_498 },
            .{ Planet.uranus, 84.016_846 },
            .{ Planet.neptune, 164.791_32 },
        };
        inline for (pairs) |pair| {
            const planet = pair[0];
            if (self == planet) {
                const seconds_per_year = pair[1] * 31_557_600;
                return @as(f64, @floatFromInt(seconds)) / seconds_per_year;
            }
        }
        unreachable;
    }
};
