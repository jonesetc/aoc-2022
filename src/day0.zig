const std = @import("std");

pub fn allocPart1(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    return std.fmt.allocPrint(allocator, "part 1: {s}", .{input});
}

pub fn allocPart2(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    return std.fmt.allocPrint(allocator, "part 2: {s}", .{input});
}
