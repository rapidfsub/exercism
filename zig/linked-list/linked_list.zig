pub fn LinkedList(comptime T: type) type {
    return struct {
        pub const Node = struct {
            prev: ?*@This() = null,
            next: ?*@This() = null,
            data: T,

            fn connectNext(this: *Node, other: *Node) void {
                this.next = other;
                other.prev = this;
            }

            fn disconnectNext(this: *Node) void {
                if (this.next != null) {
                    this.next.?.prev = null;
                    this.next = null;
                }
            }

            fn bridge(this: *Node) void {
                if (this.prev != null) {
                    this.prev.?.next = this.next;
                }
                if (this.next != null) {
                    this.next.?.prev = this.prev;
                }
                this.prev = null;
                this.next = null;
            }
        };

        first: ?*Node = null,
        last: ?*Node = null,
        len: u32 = 0,

        pub fn push(this: *@This(), node: *Node) void {
            if (this.last == null) {
                this.first = node;
            } else {
                this.last.?.connectNext(node);
            }
            this.last = node;
            this.len += 1;
        }

        pub fn pop(this: *@This()) ?*Node {
            if (this.last == null) {
                return null;
            }

            const result = this.last.?;
            this.last = result.prev;
            if (result.prev == null) {
                this.first = null;
            } else {
                result.prev.?.disconnectNext();
            }
            this.len -= 1;
            return result;
        }

        pub fn shift(this: *@This()) ?*Node {
            if (this.first == null) {
                return null;
            }

            const result = this.first.?;
            this.first = result.next;
            if (result.next == null) {
                this.last = null;
            } else {
                result.disconnectNext();
            }
            this.len -= 1;
            return result;
        }

        pub fn unshift(this: *@This(), node: *Node) void {
            if (this.first == null) {
                this.last = node;
            } else {
                node.connectNext(this.first.?);
            }
            this.first = node;
            this.len += 1;
        }

        pub fn delete(this: *@This(), node: *Node) void {
            var curr = this.first;
            while (curr != null) : (curr = curr.?.next) {
                if (curr != node) {
                    continue;
                }

                if (this.first == node) {
                    this.first = node.next;
                }
                if (this.last == node) {
                    this.last = node.prev;
                }
                node.bridge();
                this.len -= 1;
                break;
            }
        }
    };
}
