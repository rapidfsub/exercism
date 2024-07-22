// Take a look at the tests, you might have to change the function arguments

pub fn binarySearch(T: type, target: T, items: []const T) ?usize {
    var i: usize = 0;
    var j = items.len;
    return while (i < j) {
        const p = (i + j) / 2;
        const pivot = items[p];
        if (pivot < target) {
            i = p + 1;
        } else if (target < pivot) {
            j = p;
        } else {
            break p;
        }
    } else null;
}
