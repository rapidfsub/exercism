// Please implement the `ComputationError.IllegalArgument` error.

pub const ComputationError = error{IllegalArgument};

pub fn steps(number: usize) ComputationError!usize {
    if (number > 0) {
        var value = number;
        var result: usize = 0;
        while (value > 1) : (result += 1) {
            if (value % 2 == 0) {
                value /= 2;
            } else {
                value = 3 * value + 1;
            }
        }
        return result;
    } else {
        return ComputationError.IllegalArgument;
    }
}
