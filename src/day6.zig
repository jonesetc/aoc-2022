const std = @import("std");

pub fn allocPart1(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    return allocPartX(allocator, input, 4);
}

pub fn allocPart2(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    return allocPartX(allocator, input, 14);
}

fn allocPartX(allocator: std.mem.Allocator, input: []const u8, comptime size: comptime_int) ![]const u8 {
    var recentSet = std.AutoHashMap(u8, void).init(allocator);
    defer recentSet.deinit();
    try recentSet.ensureTotalCapacity(size);

    var recent = std.mem.zeroes([size]u8);
    var lines = std.mem.tokenize(u8, input, "\n");
    for (lines.next().?) |letter, i| {
        recent[i % size] = letter;

        for (recent) |old| recentSet.putAssumeCapacity(old, void{});

        if (recentSet.count() == size) return std.fmt.allocPrint(allocator, "{}", .{i + 1});

        recentSet.clearRetainingCapacity();
    }

    unreachable;
}
