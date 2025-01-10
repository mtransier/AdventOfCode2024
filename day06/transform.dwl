%dw 2.0
import fail, try from dw::Runtime
import countBy, every, indexWhere, some, takeWhile from dw::core::Arrays
import lines from dw::core::Strings
import toArray from dw::util::Coercions
import update from dw::util::Values

output application/json

type Position = { x: Number, y: Number }
type Field = { m: String, right: Boolean, left: Boolean, up: Boolean, down: Boolean, block: Boolean }

var labMap = lines(payload) map (toArray($) map { m: $, right: false, left: false, up: false, down: false }) as Array<Field>
var markers = [">", "<", "^", "v"]
var blocks = ["#", "O"]
var startPos: Position = do {
    var posY = labMap indexWhere (row) -> markers some (marker) -> row.m contains marker
    ---
    { x: labMap[posY] indexWhere (field) -> markers contains field.m, y: posY }
}

fun nextPosition(labMap: Array<Array<Field>>, pos: Position, direction: String): Position =
    direction match {
        case ">" -> { x: pos.x + 1, y: pos.y }
        case "<" -> { x: pos.x - 1, y: pos.y }
        case "^" -> { x: pos.x, y: pos.y - 1 }
        case "v" -> { x: pos.x, y: pos.y + 1 }
        else -> { x: pos.x, y: pos.y }
    } then if (blocks contains labMap[$.y][$.x].m) pos else $

fun detectLoop(labMap: Array<Array<Field>>, pos: Position, direction: String): Boolean =
    direction match {
        case ">" -> labMap[pos.y][pos.x].right
        case "<" -> labMap[pos.y][pos.x].left
        case "^" -> labMap[pos.y][pos.x].up
        case "v" -> labMap[pos.y][pos.x].down
    } default false

fun hasSteppedOut(labMap: Array<Array<Field>>, pos: Position): Boolean =
    ([pos.x >= 0, pos.x < sizeOf(labMap[0]), pos.y >= 0, pos.y < sizeOf(labMap)] countBy !$) == 1

fun turnRight(labMap: Array<Array<Field>>, pos: Position, direction: String): Array<Array<Field>> = do {
    var newMarker = direction match {
        case ">" -> "v"
        case "v" -> "<"
        case "<" -> "^"
        case "^" -> ">"
        else -> direction
    }
    ---
    mark(labMap, pos, newMarker, direction)
}

fun mark(labMap: Array<Array<Field>>, pos: Position, marker: String, direction: String = ""): Array<Array<Field>> =
    labMap update pos.y with (
        labMap[pos.y] update pos.x with (
            labMap[pos.y][pos.x] update {
                case .m -> marker
                // keep track of the path
                case r at .right -> r or direction == ">"
                case l at .left -> l or direction == "<"
                case u at .up -> u or direction == "^"
                case d at .down -> d or direction == "v"
            }
        )
    ) then $ as Array<Array<Field>>

fun printPath(labMap) =
    labMap map (row) -> (
        row map (
            if ($.m == "#") "#"
            else if ($.m == "O") "O"
            else if (($.right or $.left) and ($.up or $.down)) "+"
            else if ($.right or $.left) "-"
            else if ($.down or $.up) "|"
            else " "
        ) joinBy '')

@TailRec()
fun goForward(labMap: Array<Array<Field>>, pos: Position): Array<Array<Field>> = do {
    var direction = labMap[pos.y][pos.x].m
    var newPos = nextPosition(labMap, pos, direction)
    ---
    if (detectLoop(labMap, newPos, direction))
        fail("Loop detected")
    else if (hasSteppedOut(labMap, newPos))
        mark(labMap, pos, "X", direction)
    else goForward(
        if (newPos == pos)
            turnRight(labMap, pos, direction)
        else
            mark(labMap, pos, "X", direction)
                then mark($, newPos, direction)
        , newPos
    )
}

var path = goForward(labMap, startPos)
var potentialBlocks: Array<Position> =
    path flatMap (row, y) ->
        (row map (field, x) ->
            if (field.m == "X" and (x != startPos.x or y != startPos.y))
                { x: x, y: y }
            else null
        ) filter !isEmpty($)
---
{
    part1: path map ($ countBy $.m == "X") then sum($),
    part2: (potentialBlocks map (block) ->
        labMap update block.y with (
            labMap[block.y] update block.x with (
                labMap[block.y][block.x] update "m" with "O")
        ) then try(() -> goForward($ as Array<Array<Field>>, startPos))
    ) filter !$.success then sizeOf($),
    path: printPath(path)
}