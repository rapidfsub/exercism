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
    const tally = getTally(word);
    var result = std.BufSet.init(allocator);
    for (candidates) |candid| {
        const tc = getTally(candid);
        if (mem.eql(u32, &tc, &tally) and !ascii.eqlIgnoreCase(candid, word)) {
            try result.insert(candid);
        }
    }
    return result;
}

fn getTally(word: []const u8) [26]u32 {
    var result = [_]u32{0} ** 26;
    for (word) |letter| {
        if (ascii.isAlphabetic(letter)) {
            result[ascii.toLower(letter) - 'a'] += 1;
        }
    }
    return result;
}
