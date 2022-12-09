const std = @import("std");

const FileMap = std.StringHashMap(*File);
const DirMap = std.StringHashMap(*Directory);

const File = struct {
    size: u64,

    pub fn init(allocator: std.mem.Allocator, size: u64) !*File {
        var self = try allocator.create(File);
        self.*.size = size;

        return self;
    }
};

const Directory = struct {
    files: FileMap,
    dirs: DirMap,

    pub fn init(allocator: std.mem.Allocator) !*Directory {
        var self = try allocator.create(Directory);
        self.*.files = FileMap.init(allocator);
        self.*.dirs = DirMap.init(allocator);

        return self;
    }

    pub fn addDir(self: *Directory, name: []const u8, dir: *Directory) !void {
        try self.dirs.put(name, dir);
    }

    pub fn addFile(self: *Directory, name: []const u8, file: *File) !void {
        try self.files.put(name, file);
    }

    pub fn size(self: Directory) u64 {
        var sum: u64 = 0;

        var files = self.files.valueIterator();
        while (files.next()) |file| sum += file.*.size;

        var dirs = self.dirs.valueIterator();
        while (dirs.next()) |dir| sum += dir.*.size();

        return sum;
    }
};

pub fn allocPart1(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();

    var allDirs = std.ArrayList(*Directory).init(arena.allocator());
    var dirStack = std.ArrayList(*Directory).init(arena.allocator());

    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        if (std.mem.startsWith(u8, line, "$")) {
            if (std.mem.startsWith(u8, line[2..4], "cd")) {
                const name = line[5..];
                if (std.mem.eql(u8, name, "/")) {
                    dirStack.clearRetainingCapacity();
                    var root = try Directory.init(arena.allocator());
                    try allDirs.append(root);
                    try dirStack.append(root);
                } else if (std.mem.eql(u8, name, "..")) {
                    _ = dirStack.pop();
                } else {
                    var curr = dirStack.pop();
                    var next = curr.*.dirs.get(name).?;
                    try dirStack.append(curr);
                    try dirStack.append(next);
                }
            }
        } else {
            var curr = dirStack.pop();
            if (std.mem.startsWith(u8, line, "dir ")) {
                var sub = try Directory.init(arena.allocator());
                try allDirs.append(sub);
                try curr.addDir(line[4..], sub);
            } else {
                var parts = std.mem.tokenize(u8, line, " ");
                var size = try std.fmt.parseUnsigned(u64, parts.next().?, 10);
                var name = parts.next().?;
                try curr.addFile(name, try File.init(arena.allocator(), size));
            }
            try dirStack.append(curr);
        }
    }

    var sum: u64 = 0;
    var curr: u64 = 0;
    for (allDirs.items) |dir| {
        curr = dir.*.size();
        if (curr <= 100000) sum += curr;
    }

    return std.fmt.allocPrint(allocator, "{}", .{sum});
}

pub fn allocPart2(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();

    var allDirs = std.ArrayList(*Directory).init(arena.allocator());
    var dirStack = std.ArrayList(*Directory).init(arena.allocator());

    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        if (std.mem.startsWith(u8, line, "$")) {
            if (std.mem.startsWith(u8, line[2..4], "cd")) {
                const name = line[5..];
                if (std.mem.eql(u8, name, "/")) {
                    dirStack.clearRetainingCapacity();
                    var root = try Directory.init(arena.allocator());
                    try allDirs.append(root);
                    try dirStack.append(root);
                } else if (std.mem.eql(u8, name, "..")) {
                    _ = dirStack.pop();
                } else {
                    var curr = dirStack.pop();
                    var next = curr.*.dirs.get(name).?;
                    try dirStack.append(curr);
                    try dirStack.append(next);
                }
            }
        } else {
            var curr = dirStack.pop();
            if (std.mem.startsWith(u8, line, "dir ")) {
                var sub = try Directory.init(arena.allocator());
                try allDirs.append(sub);
                try curr.addDir(line[4..], sub);
            } else {
                var parts = std.mem.tokenize(u8, line, " ");
                var size = try std.fmt.parseUnsigned(u64, parts.next().?, 10);
                var name = parts.next().?;
                try curr.addFile(name, try File.init(arena.allocator(), size));
            }
            try dirStack.append(curr);
        }
    }

    const used = allDirs.items[0].*.size();
    const needed = 30_000_000 - (70_000_000 - used);
    var closest = used;
    var curr: u64 = 0;
    for (allDirs.items) |dir| {
        curr = dir.*.size();
        if (curr >= needed and curr < closest) closest = curr;
    }

    return std.fmt.allocPrint(allocator, "{}", .{closest});
}
