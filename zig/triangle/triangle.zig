const std = @import("std");

pub const TriangleError = error{Invalid};

pub const Triangle = struct {
    a: f64,
    b: f64,
    c: f64,

    pub fn init(a: f64, b: f64, c: f64) TriangleError!Triangle {
        var sides = [_]f64{ a, b, c };
        std.mem.sort(f64, &sides, {}, std.sort.asc(f64));
        if (sides[0] + sides[1] > sides[2]) {
            return Triangle{
                .a = sides[0],
                .b = sides[1],
                .c = sides[2],
            };
        } else {
            return TriangleError.Invalid;
        }
    }

    pub fn isEquilateral(self: Triangle) bool {
        return self.a == self.b and self.b == self.c;
    }

    pub fn isIsosceles(self: Triangle) bool {
        return self.a == self.b or self.b == self.c;
    }

    pub fn isScalene(self: Triangle) bool {
        return !isIsosceles(self);
    }
};
