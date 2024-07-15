pub const Coordinate = struct {
    x_coord: f32,
    y_coord: f32,

    pub fn init(x_coord: f32, y_coord: f32) Coordinate {
        return Coordinate{ .x_coord = x_coord, .y_coord = y_coord };
    }

    pub fn score(self: Coordinate) usize {
        const sum_of_squares = self.x_coord * self.x_coord + self.y_coord * self.y_coord;
        if (sum_of_squares <= 1) {
            return 10;
        } else if (sum_of_squares <= 25) {
            return 5;
        } else if (sum_of_squares <= 100) {
            return 1;
        } else {
            return 0;
        }
    }
};
