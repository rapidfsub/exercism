pub const NucleotideError = error{Invalid};

pub const Counts = struct {
    a: u32,
    c: u32,
    g: u32,
    t: u32,

    pub fn init() Counts {
        return Counts{ .a = 0, .c = 0, .g = 0, .t = 0 };
    }
};

pub fn countNucleotides(s: []const u8) NucleotideError!Counts {
    var counts = Counts.init();
    for (s) |letter| {
        switch (letter) {
            'A' => counts.a += 1,
            'C' => counts.c += 1,
            'G' => counts.g += 1,
            'T' => counts.t += 1,
            else => return NucleotideError.Invalid,
        }
    }
    return counts;
}
