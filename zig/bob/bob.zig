const std = @import("std");

pub fn response(s: []const u8) []const u8 {
    var hasUpper = false;
    var hasLower = false;
    var isAsking = false;
    var isSilent = true;

    for (s) |letter| {
        if (!std.ascii.isWhitespace(letter)) {
            if (std.ascii.isUpper(letter)) {
                hasUpper = true;
            } else if (std.ascii.isLower(letter)) {
                hasLower = true;
            }

            isAsking = letter == '?';
            if (isSilent) {
                isSilent = false;
            }
        }
    }

    if (isSilent) {
        return "Fine. Be that way!";
    } else if (hasUpper and !hasLower) {
        if (isAsking) {
            return "Calm down, I know what I'm doing!";
        } else {
            return "Whoa, chill out!";
        }
    } else {
        if (isAsking) {
            return "Sure.";
        } else {
            return "Whatever.";
        }
    }
}
