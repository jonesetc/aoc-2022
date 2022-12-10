const std = @import("std");

const exercises = std.ComptimeStringMap(*const fn (std.mem.Allocator, []const u8) anyerror![]const u8, .{
    .{ "0 1", @import("day0.zig").allocPart1 },
    .{ "0 2", @import("day0.zig").allocPart2 },
    .{ "1 1", @import("day1.zig").allocPart1 },
    .{ "1 2", @import("day1.zig").allocPart2 },
    .{ "2 1", @import("day2.zig").allocPart1 },
    .{ "2 2", @import("day2.zig").allocPart2 },
    .{ "3 1", @import("day3.zig").allocPart1 },
    .{ "3 2", @import("day3.zig").allocPart2 },
    .{ "4 1", @import("day4.zig").allocPart1 },
    .{ "4 2", @import("day4.zig").allocPart2 },
    .{ "5 1", @import("day5.zig").allocPart1 },
    .{ "5 2", @import("day5.zig").allocPart2 },
    .{ "6 1", @import("day6.zig").allocPart1 },
    .{ "6 2", @import("day6.zig").allocPart2 },
    .{ "7 1", @import("day7.zig").allocPart1 },
    .{ "7 2", @import("day7.zig").allocPart2 },
    .{ "8 1", @import("day8.zig").allocPart1 },
    .{ "8 2", @import("day8.zig").allocPart2 },
});

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const exercise = getExercise(args) catch {
        const stderr = std.io.getStdErr().writer();
        stderr.print("Incorrect usage, should be:\n", .{}) catch {};
        stderr.print("\t{s} <day: 0-25> <part: 1-2>\n", .{args[0]}) catch {};

        std.process.exit(1);
    };

    const input = allocDayInput(allocator, exercise.day) catch {
        const stderr = std.io.getStdErr().writer();
        stderr.print("Failed to read input file for day {}\n", .{exercise.day}) catch {};

        std.process.exit(1);
    };
    defer allocator.free(input);

    if (exercises.get(try std.fmt.allocPrint(allocator, "{} {}", exercise))) |callable| {
        const result = try callable(allocator, input);
        defer allocator.free(result);

        const stdout = std.io.getStdOut().writer();
        stdout.print("{s}\n", .{result}) catch {};
    } else {
        const stderr = std.io.getStdErr().writer();
        stderr.print("Sorry, day {} part {} isn't implemented yet\n", exercise) catch {};

        std.process.exit(1);
    }
}

fn getExercise(args: [][:0]u8) !struct { day: u8, part: u8 } {
    if (args.len < 3) return error.WrongNumberOfArgs;

    const day = try std.fmt.parseUnsigned(u8, args[1], 10);
    if (day > 25) return error.InvalidDay;

    const part = try std.fmt.parseUnsigned(u8, args[2], 10);
    if (part != 1 and part != 2) return error.InvalidPart;

    return .{ .day = day, .part = part };
}

fn allocDayInput(allocator: std.mem.Allocator, day: u8) ![]const u8 {
    const filepath = try std.fmt.allocPrint(allocator, "inputs/day{}.txt", .{day});
    return try std.fs.cwd().readFileAlloc(allocator, filepath, 1024 * 1024);
}
