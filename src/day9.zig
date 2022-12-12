const std = @import("std");

const Point = struct { x: i64, y: i64 };

pub fn allocPart1(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var positions = std.AutoHashMap(Point, void).init(allocator);
    defer positions.deinit();

    var head = Point{ .x = 0, .y = 0 };
    var tail = Point{ .x = 0, .y = 0 };

    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        const direction = line[0];
        const moves = try std.fmt.parseUnsigned(u64, line[2..], 10);

        var move: usize = 0;
        while (move < moves) : (move += 1) {
            const prev = head;
            head = switch (direction) {
                'L' => Point{ .x = head.x - 1, .y = head.y },
                'R' => Point{ .x = head.x + 1, .y = head.y },
                'U' => Point{ .x = head.x, .y = head.y - 1 },
                'D' => Point{ .x = head.x, .y = head.y + 1 },
                else => unreachable,
            };

            const dx = try std.math.absInt(head.x - tail.x);
            const dy = try std.math.absInt(head.y - tail.y);

            if (dx + dy > 2 or (dx == 2 and dy == 0) or (dx == 0 and dy == 2)) {
                tail = prev;
            }

            try positions.put(tail, {});
        }
    }

    return std.fmt.allocPrint(allocator, "{}", .{positions.count()});
}

pub fn allocPart2(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var positions = std.AutoHashMap(Point, void).init(allocator);
    defer positions.deinit();

    var knots = std.mem.zeroes([10]Point);

    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        const direction = line[0];
        const moves = try std.fmt.parseUnsigned(u64, line[2..], 10);

        var move: usize = 0;
        while (move < moves) : (move += 1) {
            knots[0] = switch (direction) {
                'L' => Point{ .x = knots[0].x - 1, .y = knots[0].y },
                'R' => Point{ .x = knots[0].x + 1, .y = knots[0].y },
                'U' => Point{ .x = knots[0].x, .y = knots[0].y - 1 },
                'D' => Point{ .x = knots[0].x, .y = knots[0].y + 1 },
                else => unreachable,
            };

            var headIndex: usize = 1;
            while (headIndex < 10) : (headIndex += 1) {
                const dx = try std.math.absInt(knots[headIndex - 1].x - knots[headIndex].x);
                const dy = try std.math.absInt(knots[headIndex - 1].y - knots[headIndex].y);

                if (dx == 2 and dy == 0) {
                    knots[headIndex] = Point{ .x = @divExact(knots[headIndex].x + knots[headIndex - 1].x, 2), .y = knots[headIndex].y };
                } else if (dx == 0 and dy == 2) {
                    knots[headIndex] = Point{ .x = knots[headIndex].x, .y = @divExact(knots[headIndex].y + knots[headIndex - 1].y, 2) };
                } else if (dx == 2 and dy == 1) {
                    knots[headIndex] = Point{ .x = @divExact(knots[headIndex].x + knots[headIndex - 1].x, 2), .y = knots[headIndex - 1].y };
                } else if (dx == 1 and dy == 2) {
                    knots[headIndex] = Point{ .x = knots[headIndex - 1].x, .y = @divExact(knots[headIndex].y + knots[headIndex - 1].y, 2) };
                } else if (dx == 2 and dy == 2) {
                    knots[headIndex] = Point{ .x = @divExact(knots[headIndex].x + knots[headIndex - 1].x, 2), .y = @divExact(knots[headIndex].y + knots[headIndex - 1].y, 2) };
                }
            }
            try positions.put(knots[9], {});
        }
    }

    return std.fmt.allocPrint(allocator, "{}", .{positions.count()});
}
