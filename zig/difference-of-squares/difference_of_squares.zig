const math = @import("std").math;

pub fn squareOfSum(number: usize) usize {
    var sum: usize = 0;
    for (1..number + 1) |n| {
        sum += n;
    }
    return math.pow(usize, sum, 2);
}

pub fn sumOfSquares(number: usize) usize {
    var result: usize = 0;
    for (1..number + 1) |n| {
        result += math.pow(usize, n, 2);
    }
    return result;
}

pub fn differenceOfSquares(number: usize) usize {
    return squareOfSum(number) - sumOfSquares(number);
}
