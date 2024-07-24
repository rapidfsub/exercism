const std = @import("std");
const math = std.math;
const mem = std.mem;
const ArrayList = std.ArrayList;

pub const ConversionError = error{
    InvalidInputBase,
    InvalidOutputBase,
    InvalidDigit,
};

/// Converts `digits` from `input_base` to `output_base`, returning a slice of digits.
/// Caller owns the returned memory.
pub fn convert(
    allocator: mem.Allocator,
    digits: []const u32,
    input_base: u32,
    output_base: u32,
) (mem.Allocator.Error || ConversionError)![]u32 {
    if (input_base < 2) {
        return ConversionError.InvalidInputBase;
    } else if (output_base < 2) {
        return ConversionError.InvalidOutputBase;
    }

    var value: u32 = 0;
    for (digits) |digit| {
        if (digit < input_base) {
            value *= input_base;
            value += digit;
        } else {
            return ConversionError.InvalidDigit;
        }
    }

    var result = ArrayList(u32).init(allocator);
    defer result.deinit();
    while (value > 0) : (value /= output_base) {
        try result.insert(0, @rem(value, output_base));
    }
    if (result.items.len < 1) {
        try result.append(0);
    }
    return result.toOwnedSlice();
}
