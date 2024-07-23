const std = @import("std");
const EnumSet = std.EnumSet;

pub const Allergen = enum(u32) {
    eggs = 1,
    peanuts = 2,
    shellfish = 4,
    strawberries = 8,
    tomatoes = 16,
    chocolate = 32,
    pollen = 64,
    cats = 128,
};

pub fn isAllergicTo(score: u8, allergen: Allergen) bool {
    return score & @intFromEnum(allergen) > 0;
}

const allergens = std.enums.values(Allergen);
pub fn initAllergenSet(score: usize) EnumSet(Allergen) {
    var result = EnumSet(Allergen).init(.{});
    inline for (allergens) |allergen| {
        const bit = @intFromEnum(allergen);
        if (score & bit > 0) {
            result.insert(allergen);
        }
    }
    return result;
}
