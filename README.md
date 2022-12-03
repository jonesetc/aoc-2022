# Advent of Code 2022

Trying out zig this time. Still not gonna finish.

## Set up

- [Install zig](https://github.com/ziglang/zig/wiki/Install-Zig-from-a-Package-Manager)
- Log into [Advent of Code 2022](https://adventofcode.com/2022) in your broser
- Open devtools, grab the value of the `session` cookie
- Set environmental variable like `export AOC_SESSION_SECRET=<your session secret>`

## Running

- Download input for the day with `./scripts/download-input.sh <day number>`
- Run desired day and part with `zig build run -- <day day number> <part number>`
