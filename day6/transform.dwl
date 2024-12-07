%dw 2.0
import countBy, every, indexWhere, some, takeWhile from dw::core::Arrays
import lines from dw::core::Strings
import toArray from dw::util::Coercions
import update from dw::util::Values

output application/json

type Position = { x: Number, y: Number }
type Field = { m: String, right: Boolean, left: Boolean, up: Boolean, down: Boolean, block: Boolean }

var labMap = lines(day6) map (toArray($) map { m: $, right: false, left: false, up: false, down: false, block: false }) as Array<Field>
var markers = [">", "<", "^", "v"]
var startPos: Position = do {
    var posY = labMap indexWhere (row) -> markers some (marker) -> row.m contains marker
    ---
    { x: labMap[posY] indexWhere (field) -> markers contains field.m, y: posY }
}

fun hasSteppedOut(labMap: Array<Array<Field>>, pos: Position): Boolean =
    ([pos.x >= 0, pos.x < sizeOf(labMap[0]), pos.y >= 0, pos.y < sizeOf(labMap)] countBy !$) == 1

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

fun setBlock(labMap: Array<Array<Field>>, pos: Position, blockPos: Position, direction: String, path: Array<Array<Field>>): Array<Array<Field>> =
    // This is too simple, it just checks the next straight line for already visited places,
    // instead it should follow the new path until it hits the old one or walks out.
    labMap update blockPos.y with (
        labMap[blockPos.y] update blockPos.x with (
            labMap[blockPos.y][blockPos.x] update {
                case b at .block -> b or (direction match {
                    case ">" -> (pos.y to sizeOf(labMap) - 1) as Array map path[$][pos.x] takeWhile $.m != "#" some $.down
                    case "<" -> (pos.y to 0) as Array map path[$][pos.x] takeWhile $.m != "#" some $.up
                    case "^" -> (pos.x to sizeOf(labMap[0]) - 1) as Array map path[pos.y][$] takeWhile $.m != "#" some $.right
                    case "v" -> (pos.x to 0) as Array map path[pos.y][$] takeWhile $.m != "#" some $.left
                })
            }
        )
    ) then $ as Array<Array<Field>>

fun rotateRight(direction: String): String =
    direction match {
        case ">" -> "v"
        case "v" -> "<"
        case "<" -> "^"
        case "^" -> ">"
        else -> direction
    }

fun turnRight(labMap: Array<Array<Field>>, pos: Position, direction: String): Array<Array<Field>> = do {
    var newMarker = rotateRight(direction)
    ---
    mark(labMap, pos, newMarker, direction)
}

fun printDirections(labMap) =
    labMap map (row) -> (row map (if ($.m == "#") "#" else if ($.block) "O" else if (($.right or $.left) and ($.up or $.down)) "+" else if ($.right or $.left) "-" else if ($.down or $.up) "|" else " ") joinBy '')

fun nextPosition(labMap: Array<Array<Field>>, pos: Position, direction: String): Position =
    direction match {
        case ">" -> { x: pos.x + 1, y: pos.y }
        case "<" -> { x: pos.x - 1, y: pos.y }
        case "^" -> { x: pos.x, y: pos.y - 1 }
        case "v" -> { x: pos.x, y: pos.y + 1 }
        else -> { x: pos.x, y: pos.y }
    } then if (labMap[$.y][$.x].m == "#") pos else $

@TailRec()
fun goForward(labMap: Array<Array<Field>>, pos: Position, path: Array<Array<Field>> = []): Array<Array<Field>> = do {
    //var logDirections = log(printDirections(labMap))
    
    var direction = labMap[pos.y][pos.x].m
    var newPos = nextPosition(labMap, pos, direction)
    ---
    if (hasSteppedOut(labMap, newPos))
        mark(labMap, pos, "X", direction)
    else goForward(
        if (newPos == pos)
            turnRight(labMap, pos, direction)
                then (if (!isEmpty(path)) setBlock($, pos, nextPosition($, pos, rotateRight(direction)), rotateRight(direction), path) else $) // only in the second part
        else
            mark(labMap, pos, "X", direction)
                then (if (!isEmpty(path)) setBlock($, pos, newPos, direction, path) else $) // only in the second part
                    then mark($, newPos, direction)
        , newPos, path
    )
}

var path = goForward(labMap, startPos)
var blocks = goForward(labMap, startPos, path)
---
{
    part1: path map ($ countBy $.m == "X") then sum($),
    part2: blocks map ($ countBy $.block) then sum($),
    directions: printDirections(blocks)
}
