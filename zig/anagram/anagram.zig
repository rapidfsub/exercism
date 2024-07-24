const std = @import("std");
const ascii = std.ascii;
const mem = std.mem;

/// Returns the set of strings in `candidates` that are anagrams of `word`.
/// Caller owns the returned memory.
pub fn detectAnagrams(
    allocator: mem.Allocator,
    word: []const u8,
    candidates: []const []const u8,
) !std.BufSet {
    var tally = [_]u32{0} ** 26;
    for (word) |letter| {
        if (ascii.isAlphabetic(letter)) {
            tally[ascii.toLower(letter) - 'a'] += 1;
        }
    }

    var result = std.BufSet.init(allocator);
    for (candidates) |candid| {
        var tc = [_]u32{0} ** 26;
        for (candid) |letter| {
            if (ascii.isAlphabetic(letter)) {
                tc[ascii.toLower(letter) - 'a'] += 1;
            }
        }

        if (mem.eql(u32, &tc, &tally)) {
            for (candid, word) |lhs, rhs| {
                if (ascii.toLower(lhs) != ascii.toLower(rhs)) {
                    try result.insert(candid);
                    break;
                }
            }
        }
    }
    return result;
}
