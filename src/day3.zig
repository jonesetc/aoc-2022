const std = @import("std");

pub fn allocPart1(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var compartment = std.AutoHashMap(u8, void).init(allocator);
    defer compartment.deinit();

    var prioritySum: u64 = 0;
    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        for (line[0 .. line.len / 2]) |letter| {
            try compartment.put(letter, void{});
        }
        for (line[line.len / 2 ..]) |letter| {
            if (compartment.contains(letter)) {
                prioritySum += switch (letter) {
                    'a'...'z' => letter - 96,
                    'A'...'Z' => letter - 38,
                    else => unreachable,
                };
                break;
            }
        }
        compartment.clearRetainingCapacity();
    }

    return std.fmt.allocPrint(allocator, "{}", .{prioritySum});
}

pub fn allocPart2(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var groupLetters = std.AutoHashMap(u8, u64).init(allocator);
    defer groupLetters.deinit();

    var prioritySum: u64 = 0;
    var lines = std.mem.tokenize(u8, input, "\n");
    var groupIndex: usize = 1;
    while (lines.next()) |line| {
        if (groupIndex == 3) {
            for (line) |letter| {
                if (groupLetters.get(letter)) |value| {
                    if (value == groupIndex) {
                        prioritySum += switch (letter) {
                            'a'...'z' => letter - 96,
                            'A'...'Z' => letter - 38,
                            else => unreachable,
                        };
                        break;
                    }
                }
            }
            groupLetters.clearRetainingCapacity();
        } else {
            for (line) |letter| {
                var entry = try groupLetters.getOrPut(letter);
                if (!entry.found_existing) {
                    entry.value_ptr.* = 0;
                }
                entry.value_ptr.* |= groupIndex;
            }
        }

        groupIndex = (groupIndex % 3) + 1;
    }

    return std.fmt.allocPrint(allocator, "{}", .{prioritySum});
}
