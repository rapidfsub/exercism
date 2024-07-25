pub fn LinkedList(comptime T: type) type {
    return struct {
        pub const Node = struct {
            prev: ?*@This() = null,
            next: ?*@This() = null,
            data: T,
        };

        first: ?*Node = null,
        last: ?*Node = null,
        len: u32 = 0,

        pub fn push(this: *@This(), node: *Node) void {
            this.len += 1;
            if (this.last == null) {
                this.first = node;
                this.last = node;
            } else {
                node.prev = this.last;
                this.last.?.next = node;
                this.last = node;
            }
        }

        pub fn pop(this: *@This()) ?*Node {
            if (this.last == null) {
                return null;
            } else {
                this.len -= 1;
                var result = this.last.?;
                if (this.len > 0) {
                    if (result.prev != null) {
                        result.prev.?.next = null;
                    }
                    this.last = result.prev;
                    result.prev = null;
                } else {
                    this.first = null;
                    this.last = null;
                }
                return result;
            }
        }

        pub fn shift(this: *@This()) ?*Node {
            if (this.first == null) {
                return null;
            } else {
                this.len -= 1;
                var result = this.first.?;
                if (this.len > 0) {
                    if (result.next != null) {
                        result.next.?.prev = null;
                    }
                    this.first = result.next;
                    result.next = null;
                } else {
                    this.first = null;
                    this.last = null;
                }
                return result;
            }
        }

        pub fn unshift(this: *@This(), node: *Node) void {
            this.len += 1;
            if (this.first == null) {
                this.first = node;
                this.last = node;
            } else {
                node.next = this.first;
                this.first.?.prev = node;
                this.first = node;
            }
        }

        pub fn delete(this: *@This(), node: *Node) void {
            var curr = this.first;
            while (curr != null) : (curr = curr.?.next) {
                if (curr == node) {
                    this.len -= 1;
                    if (this.len > 0) {
                        if (node.next == null) {
                            this.last = node.prev;
                        } else {
                            node.next.?.prev = node.prev;
                        }
                        if (node.prev == null) {
                            this.first = node.next;
                        } else {
                            node.prev.?.next = node.next;
                        }
                        node.prev = null;
                        node.next = null;
                    } else {
                        this.first = null;
                        this.last = null;
                    }
                    break;
                }
            }
        }
    };
}
