const mem = @import("std").mem;

pub fn toRna(allocator: mem.Allocator, dna: []const u8) mem.Allocator.Error![]const u8 {
    var rna = try allocator.alloc(u8, dna.len);
    for (dna, 0..) |c, i| {
        switch (c) {
            'G' => rna[i] = 'C',
            'C' => rna[i] = 'G',
            'T' => rna[i] = 'A',
            'A' => rna[i] = 'U',
            else => unreachable,
        }
    }
    return rna;
}
