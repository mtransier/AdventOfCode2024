%dw 2.0
import lines from dw::core::Strings

output application/json

type Position = { x: Number, y: Number }

fun add(a: Position, b: Position): Position =
    { x: a.x + b.x, y: a.y + b.y }

fun mul(a: Number, b: Position): Position =
    { x: a * b.x, y: a * b.y }

fun trunc(a: Number): Number =
    (if (a > 0) 1 else -1) * floor(abs(a))

var antennaMap = lines(payload)
var frequencies = payload scan /[\w]/ distinctBy $ then flatten($)
var antennas: Dictionary<Array<Position>> =
    frequencies reduce (frequency, antennas = {}) -> antennas ++ {
        (frequency): (0 to sizeOf(antennaMap) - 1) as Array<Number> map ((y) ->
            (0 to sizeOf(antennaMap[0]) - 1) as Array<Number> map ((x) ->
                if (antennaMap[y][x] == frequency) { x: x, y: y } else null
            ) filter !isEmpty($)
        ) then flatten($)
    }

fun calculateAntinodes(a1: Position, a2: Position, limit: Boolean = false): Array<Position> = do {
    var distance = { x: a2.x - a1.x, y: a2.y - a1.y }
    var rangeX = [trunc(-a1.x / distance.x), trunc((sizeOf(antennaMap[0]) - 1 - a1.x) / distance.x)] orderBy $
    var rangeY = [trunc(-a1.y / distance.y), trunc((sizeOf(antennaMap) - 1 - a1.y) / distance.y)] orderBy $
    var start = max([rangeX[0], rangeY[0]]) as Number then (if (limit) max([$, -1]) else $) as Number
    var end = min([rangeX[1], rangeY[1]]) as Number then (if (limit) min([$, 2]) else $) as Number
    ---
    (start to end) as Array map
        (a1 add ($ mul distance))
}

fun getAntinodes(antennas: Dictionary<Array<Position>>, limit: Boolean = true): Array<Position> =
    (keysOf(antennas) flatMap (frequency) ->
        antennas[frequency][0 to -2] flatMap (antenna1, index) ->
            antennas[frequency][index + 1 to -1] flatMap (antenna2) ->
                calculateAntinodes(antenna1, antenna2, limit)
                    then if (limit) $ - antenna1 - antenna2 else $
    ) distinctBy { x: $.x, y: $.y }

fun printMap(antinodes: Array<Position>): Array<String> =
    antennaMap map (row, y) ->
        row dw::core::Strings::mapString (character, x) ->
            if (character != ".") character
            else if (antinodes contains { x: x, y: y }) "#"
            else character
---
{
    part1: sizeOf(getAntinodes(antennas)),
    part2: sizeOf(getAntinodes(antennas, false))
}