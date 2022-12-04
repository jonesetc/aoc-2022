const std = @import("std");

const day0 = @import("day0.zig");
const day1 = @import("day1.zig");
const day2 = @import("day2.zig");

const AocExcercise = struct { day: u8, part: u8 };
const AocError = error{InvalidUsage};

pub fn main() !void {
    const allocator = std.heap.c_allocator;

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

    const result = switch (exercise.day) {
        0 => switch (exercise.part) {
            1 => day0.allocPart1(allocator, input),
            2 => day0.allocPart2(allocator, input),
            else => unreachable,
        },
        1 => switch (exercise.part) {
            1 => day1.allocPart1(allocator, input),
            2 => day1.allocPart2(allocator, input),
            else => unreachable,
        },
        2 => switch (exercise.part) {
            1 => day2.allocPart1(allocator, input),
            2 => day2.allocPart2(allocator, input),
            else => unreachable,
        },
        else => {
            const stderr = std.io.getStdErr().writer();
            stderr.print("Sorry, day {} part {} isn't implemented yet\n", exercise) catch {};

            std.process.exit(1);
        },
    } catch {
        const stderr = std.io.getStdErr().writer();
        stderr.print("Error running, day {} part {}\n", exercise) catch {};

        std.process.exit(1);
    };
    defer allocator.free(result);

    const stdout = std.io.getStdOut().writer();
    stdout.print("{s}\n", .{result}) catch {};
}

fn getExercise(args: [][:0]u8) !AocExcercise {
    if (args.len < 3) return AocError.InvalidUsage;

    const day = try std.fmt.parseUnsigned(u8, args[1], 10);
    if (day > 25) return AocError.InvalidUsage;

    const part = try std.fmt.parseUnsigned(u8, args[2], 10);
    if (part != 1 and part != 2) return AocError.InvalidUsage;

    return AocExcercise{ .day = day, .part = part };
}

fn allocDayInput(allocator: std.mem.Allocator, day: u8) ![]const u8 {
    const filepath = try std.fmt.allocPrint(allocator, "inputs/day{}.txt", .{day});
    return try std.fs.cwd().readFileAlloc(allocator, filepath, 1024 * 1024);
}
