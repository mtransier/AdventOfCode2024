%dw 2.0
import lines from dw::core::Strings
import toArray from dw::util::Coercions

output application/json

var rows = lines(payload) map toArray($)
var columns = (0 to sizeOf(rows[0]) - 1 map (column) -> (0 to sizeOf(rows) - 1) map (row) -> rows[row][column])
var downDiagonals = (sizeOf(rows) -1 to 0 map (row) -> (0 to sizeOf(columns) map (column) -> rows[row + column][column]) filter !isEmpty($))
    ++ (1 to sizeOf(columns) - 1 map (column) -> (0 to sizeOf(rows) map (row) -> rows[row][row + column]) filter !isEmpty($))
var upDiagonals = (0 to sizeOf(rows) map (row) -> (0 to sizeOf(columns) map (column) -> if (row - column >= 0) rows[row - column][column] else null) filter !isEmpty($))
    ++ (1 to sizeOf(columns) - 2 map (column) -> (sizeOf(rows) - 1 to 0 map (row) -> rows[row][sizeOf(rows) - row + column]) filter !isEmpty($))

fun findXMAS(text: Array<Array<String>>): Number = text map sizeOf($ joinBy "" find "XMAS") then sum($)

fun detectXmas(row: Number, column: Number): Boolean =
    ((rows[row - 1][column - 1] == "M" and rows[row + 1][column + 1] == "S") or (rows[row - 1][column - 1] == "S" and rows[row + 1][column + 1] == "M"))
    and ((rows[row + 1][column - 1] == "M" and rows[row - 1][column + 1] == "S") or (rows[row + 1][column - 1] == "S" and rows[row - 1][column + 1] == "M"))
---
{
    part1: [
        rows, columns, downDiagonals, upDiagonals
    ] map findXMAS($) + findXMAS($ map $[-1 to 0]) then sum($),
    part2: (1 to sizeOf(rows) -2 map (row) -> 1 to sizeOf(columns) -2 map ((column) ->
        if (rows[row][column] == "A" and detectXmas(row, column)) 1 else 0) then sum($)) then sum($)
}