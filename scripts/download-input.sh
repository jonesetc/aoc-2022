#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
INPUT_DIR="$SCRIPT_DIR/../inputs"

if [[ "$#" -ne 1 ]] || [[ "$1" -lt 1 ]] || [[ "$1" -gt 25 ]]; then
    echo "Incorrect usage, should be:" >&2
    echo -e "\t$0 <day 1-25>" >&2

    exit 1
fi

if [[ -z "$AOC_SESSION_SECRET" ]]; then
    echo "Must set AOC_SESSION_SECRET variable before calling" >&2

    exit 1
fi;

mkdir -p "$INPUT_DIR"
curl -sf \
    --cookie "session=$AOC_SESSION_SECRET" \
    -o "$INPUT_DIR/day$1.txt" \
    "https://adventofcode.com/2022/day/$1/input" \
    || (echo "Failed to download file for day $1" >&2 && exit 1)
