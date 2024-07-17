const std = @import("std");

pub fn response(s: []const u8) []const u8 {
    if (isSilent(s)) {
        return "Fine. Be that way!";
    } else if (isYelling(s)) {
        if (isAsking(s)) {
            return "Calm down, I know what I'm doing!";
        } else {
            return "Whoa, chill out!";
        }
    } else {
        if (isAsking(s)) {
            return "Sure.";
        } else {
            return "Whatever.";
        }
    }
}

fn isYelling(s: []const u8) bool {
    var hasUpper = false;
    return for (s) |letter| {
        if (std.ascii.isUpper(letter)) {
            hasUpper = true;
        } else if (std.ascii.isLower(letter)) {
            break false;
        }
    } else hasUpper;
}

fn isAsking(s: []const u8) bool {
    var result = false;
    return for (s) |letter| {
        if (!std.ascii.isWhitespace(letter)) {
            result = letter == '?';
        }
    } else result;
}

fn isSilent(s: []const u8) bool {
    return for (s) |letter| {
        if (!std.ascii.isWhitespace(letter)) {
            break false;
        }
    } else true;
}
