%dw 2.0
import lines from dw::core::Strings

output application/json

type Position = { x: Number, y: Number }

var hikingMap = lines(payload)
var trailHeads: Array<Position> = hikingMap flatMap (row, y) -> row find /0/ map (x) -> { x: x[0], y: y }

fun findTrails(positions: Array<Position>, level: Number): Array<Position> = do {
    var nextSteps: Array<Position> = positions flatMap ((pos) -> [
        { x: pos.x - 1, y: pos.y },
        { x: pos.x + 1, y: pos.y },
        { x: pos.x, y: pos.y - 1 },
        { x: pos.x, y: pos.y + 1 }
    ] filter ($.x >= 0 and $.y >= 0 and hikingMap[$.y][$.x] == level as String))
        distinctBy $
    ---
    if (level == 9 or isEmpty(nextSteps)) nextSteps
    else findTrails(nextSteps, level + 1)
}

fun findTrails2(trails: Array<Array<Position>>, level: Number): Array<Array<Position>> = do {
    var extendedTrails: Array<Array<Position>> = trails flatMap ((trail) -> (
            [
                { x: trail[-1].x - 1, y: trail[-1].y },
                { x: trail[-1].x + 1, y: trail[-1].y },
                { x: trail[-1].x, y: trail[-1].y - 1 },
                { x: trail[-1].x, y: trail[-1].y + 1 }
            ] filter ($.x >= 0 and $.y >= 0 and hikingMap[$.y][$.x] == level as String)
        ) map ((nextStep) -> trail << nextStep)
    )
    ---
    if (level == 9) extendedTrails
    else findTrails2(extendedTrails, level + 1)
}

var trailsPerHead = trailHeads map (findTrails([$], 1) distinctBy $)
var trailsPerHead2 = trailHeads map findTrails2([[$]], 1)
---
{
    part1: trailsPerHead map sizeOf($) then sum($),
    part1_alternative: trailsPerHead2 map (($ map $[-1]) distinctBy $ then sizeOf($)) then sum($),
    part2: trailsPerHead2 map sizeOf($) then sum($)
}