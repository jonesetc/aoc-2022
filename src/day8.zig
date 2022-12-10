const std = @import("std");

const size: usize = 99;

pub fn allocPart1(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var grid = std.mem.zeroes([size][size]u8);
    var transposed = std.mem.zeroes([size][size]u8);

    {
        var i: usize = 0;
        var lines = std.mem.tokenize(u8, input, "\n");
        while (lines.next()) |line| : (i += 1) {
            for (line) |char, j| {
                grid[i][j] = char;
                transposed[j][i] = char;
            }
        }
    }

    var count: u64 = 0;
    for (grid) |row, i| {
        for (row) |height, j| {
            if (i == 0 or i == (size - 1) or j == 0 or j == (size - 1)) {
                count += 1;
            } else {
                const left = std.mem.max(u8, grid[i][0..j]) < height;
                const right = std.mem.max(u8, grid[i][(j + 1)..]) < height;
                const up = std.mem.max(u8, transposed[j][0..i]) < height;
                const down = std.mem.max(u8, transposed[j][(i + 1)..]) < height;

                if (left or right or up or down) {
                    count += 1;
                }
            }
        }
    }

    return std.fmt.allocPrint(allocator, "{}", .{count});
}

pub fn allocPart2(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var grid = std.mem.zeroes([size][size]u8);
    var transposed = std.mem.zeroes([size][size]u8);

    {
        var i: usize = 0;
        var lines = std.mem.tokenize(u8, input, "\n");
        while (lines.next()) |line| : (i += 1) {
            for (line) |digit, j| {
                const height = try std.fmt.charToDigit(digit, 10);
                grid[i][j] = height;
                transposed[j][i] = height;
            }
        }
    }

    const heights = [_]u8{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

    var max: u64 = 0;
    for (grid) |row, i| {
        for (row) |height, j| {
            var left: u64 = 0;
            if (j != 0) {
                if (std.mem.lastIndexOfAny(u8, grid[i][0..j], heights[@as(usize, height)..])) |index| {
                    left = j - index;
                } else {
                    left = j;
                }
            }

            var right: u64 = 0;
            if (j != (size - 1)) {
                if (std.mem.indexOfAny(u8, grid[i][(j + 1)..], heights[@as(usize, height)..])) |index| {
                    right = index + 1;
                } else {
                    right = (size - 1) - j;
                }
            }

            var up: u64 = 0;
            if (i != 0) {
                if (std.mem.lastIndexOfAny(u8, transposed[j][0..i], heights[@as(usize, height)..])) |index| {
                    up = i - index;
                } else {
                    up = i;
                }
            }

            var down: u64 = 0;
            if (i != (size - 1)) {
                if (std.mem.indexOfAny(u8, transposed[j][(i + 1)..], heights[@as(usize, height)..])) |index| {
                    down = index + 1;
                } else {
                    down = (size - 1) - i;
                }
            }

            max = std.math.max(max, left * right * up * down);
        }
    }

    return std.fmt.allocPrint(allocator, "{}", .{max});
}
