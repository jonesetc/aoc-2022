const std = @import("std");

pub fn allocPart1(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var maxCals: u64 = 0;
    var currentCals: u64 = 0;

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        if (std.mem.eql(u8, line, "")) {
            if (currentCals > maxCals) {
                maxCals = currentCals;
            }

            currentCals = 0;
        } else {
            currentCals += try std.fmt.parseUnsigned(u64, line, 10);
        }
    }

    return std.fmt.allocPrint(allocator, "{}", .{maxCals});
}

pub fn allocPart2(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var allCals = std.ArrayList(u64).init(allocator);
    defer allCals.deinit();

    var currentCals: u64 = 0;

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        if (std.mem.eql(u8, line, "")) {
            try allCals.append(currentCals);
            currentCals = 0;
        } else {
            currentCals += try std.fmt.parseUnsigned(u64, line, 10);
        }
    }

    var sortedCals = try allCals.toOwnedSlice();
    defer allocator.free(sortedCals);
    std.sort.sort(u64, sortedCals, {}, comptime std.sort.desc(u64));

    return std.fmt.allocPrint(allocator, "{}", .{sortedCals[0] + sortedCals[1] + sortedCals[2]});
}
