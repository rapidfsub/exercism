// Please implement the `ComputationError.IllegalArgument` error.

pub const ComputationError = error{IllegalArgument};

pub fn steps(number: usize) ComputationError!usize {
    if (number > 1) {
        if (number % 2 == 0) {
            return 1 + try steps(number / 2);
        } else {
            return 1 + try steps(3 * number + 1);
        }
    } else {
        if (number > 0) {
            return 0;
        } else {
            return ComputationError.IllegalArgument;
        }
    }
}
