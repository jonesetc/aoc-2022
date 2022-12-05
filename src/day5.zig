const std = @import("std");

const Stack = std.TailQueue(u8);

pub fn allocPart1(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();

    var stacks = [_]Stack{ .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} };

    var numbers = std.ArrayList(u64).init(allocator);
    defer numbers.deinit();

    var movesRemaining: u64 = 0;

    var isLoading = true;
    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        if (isLoading) {
            if (std.mem.eql(u8, line, " 1   2   3   4   5   6   7   8   9 ")) {
                isLoading = false;
            } else {
                var i: u64 = 1;
                while (i <= 33) : (i += 4) {
                    if (line[i] != ' ') {
                        var node = try arena.allocator().create(Stack.Node);
                        node.data = line[i];
                        stacks[(i - 1) / 4].prepend(node);
                    }
                }
            }
        } else {
            var parts = std.mem.tokenize(u8, line, "movefromto ");
            while (parts.next()) |part| {
                const number = try std.fmt.parseUnsigned(u64, part, 10);
                try numbers.append(number);
            }

            movesRemaining = numbers.items[0];
            while (movesRemaining > 0) : (movesRemaining -= 1) {
                if (stacks[numbers.items[1] - 1].pop()) |node| {
                    stacks[numbers.items[2] - 1].append(node);
                }
            }

            numbers.clearRetainingCapacity();
        }
    }

    return std.fmt.allocPrint(allocator, "{c}{c}{c}{c}{c}{c}{c}{c}{c}", .{
        stacks[0].pop().?.data,
        stacks[1].pop().?.data,
        stacks[2].pop().?.data,
        stacks[3].pop().?.data,
        stacks[4].pop().?.data,
        stacks[5].pop().?.data,
        stacks[6].pop().?.data,
        stacks[7].pop().?.data,
        stacks[8].pop().?.data,
    });
}

pub fn allocPart2(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();

    var stacks = [_]Stack{ .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} };

    var numbers = std.ArrayList(u64).init(allocator);
    defer numbers.deinit();

    var movesRemaining: u64 = 0;
    var moveStack: Stack = .{};

    var isLoading = true;
    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        if (isLoading) {
            if (std.mem.eql(u8, line, " 1   2   3   4   5   6   7   8   9 ")) {
                isLoading = false;
            } else {
                var i: u64 = 1;
                while (i <= 33) : (i += 4) {
                    if (line[i] != ' ') {
                        var node = try arena.allocator().create(Stack.Node);
                        node.data = line[i];
                        stacks[(i - 1) / 4].prepend(node);
                    }
                }
            }
        } else {
            var parts = std.mem.tokenize(u8, line, "movefromto ");
            while (parts.next()) |part| {
                const number = try std.fmt.parseUnsigned(u64, part, 10);
                try numbers.append(number);
            }

            movesRemaining = numbers.items[0];
            while (movesRemaining > 0) : (movesRemaining -= 1) {
                if (stacks[numbers.items[1] - 1].pop()) |node| {
                    moveStack.append(node);
                }
            }
            while (moveStack.pop()) |node| {
                stacks[numbers.items[2] - 1].append(node);
            }

            numbers.clearRetainingCapacity();
        }
    }

    return std.fmt.allocPrint(allocator, "{c}{c}{c}{c}{c}{c}{c}{c}{c}", .{
        stacks[0].pop().?.data,
        stacks[1].pop().?.data,
        stacks[2].pop().?.data,
        stacks[3].pop().?.data,
        stacks[4].pop().?.data,
        stacks[5].pop().?.data,
        stacks[6].pop().?.data,
        stacks[7].pop().?.data,
        stacks[8].pop().?.data,
    });
}
