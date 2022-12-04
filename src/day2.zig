const std = @import("std");

pub fn allocPart1(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var score: u64 = 0;
    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        const opponent = line[0];
        const me = line[2];

        score += switch (opponent) {
            'A' => switch (me) {
                'X' => 4,
                'Y' => 8,
                'Z' => 3,
                else => unreachable,
            },
            'B' => switch (me) {
                'X' => 1,
                'Y' => 5,
                'Z' => 9,
                else => unreachable,
            },
            'C' => switch (me) {
                'X' => 7,
                'Y' => 2,
                'Z' => 6,
                else => unreachable,
            },
            else => unreachable,
        };
    }

    return std.fmt.allocPrint(allocator, "{}", .{score});
}

pub fn allocPart2(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var score: u64 = 0;
    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        const opponent = line[0];
        const me = line[2];

        score += switch (opponent) {
            'A' => switch (me) {
                'X' => 3,
                'Y' => 4,
                'Z' => 8,
                else => unreachable,
            },
            'B' => switch (me) {
                'X' => 1,
                'Y' => 5,
                'Z' => 9,
                else => unreachable,
            },
            'C' => switch (me) {
                'X' => 2,
                'Y' => 6,
                'Z' => 7,
                else => unreachable,
            },
            else => unreachable,
        };
    }

    return std.fmt.allocPrint(allocator, "{}", .{score});
}
