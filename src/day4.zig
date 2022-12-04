const std = @import("std");

pub fn allocPart1(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var subsetCount: u64 = 0;
    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        var assignments = [4]u8{ 0, 0, 0, 0 };
        var assignmentIndex: usize = 0;

        var parts = std.mem.tokenize(u8, line, ",-");
        while (parts.next()) |part| {
            assignments[assignmentIndex] = try std.fmt.parseUnsigned(u8, part, 10);
            assignmentIndex = (assignmentIndex + 1) % 4;
        }

        if (
        // second pair in first
        (assignments[0] <= assignments[2] and assignments[1] >= assignments[3])
        // first pair in second
        or (assignments[2] <= assignments[0] and assignments[3] >= assignments[1])) {
            subsetCount += 1;
        }
    }

    return std.fmt.allocPrint(allocator, "{}", .{subsetCount});
}

pub fn allocPart2(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var subsetCount: u64 = 0;
    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        var assignments = [4]u8{ 0, 0, 0, 0 };
        var assignmentIndex: usize = 0;

        var parts = std.mem.tokenize(u8, line, ",-");
        while (parts.next()) |part| {
            assignments[assignmentIndex] = try std.fmt.parseUnsigned(u8, part, 10);
            assignmentIndex = (assignmentIndex + 1) % 4;
        }

        if (
        // second pair in first
        (assignments[0] <= assignments[2] and assignments[1] >= assignments[3])
        // first pair in second
        or (assignments[2] <= assignments[0] and assignments[3] >= assignments[1])
        // first pair overlaps front of second pair
        or (assignments[0] <= assignments[2] and assignments[1] >= assignments[2])
        // second pair overlaps front of first pair
        or (assignments[2] <= assignments[0] and assignments[3] >= assignments[0])) {
            subsetCount += 1;
        }
    }

    return std.fmt.allocPrint(allocator, "{}", .{subsetCount});
}
