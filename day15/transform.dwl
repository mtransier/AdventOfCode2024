%dw 2.0
import splitWhere from dw::core::Arrays
import lines, mapString, reverse, substring, substringBefore from dw::core::Strings
import toArray from dw::util::Coercions

output application/json

type Position = { x: Number, y: Number }

var in = lines(payload) splitWhere isBlank($)
var warehouse = in.l
var moves = in.r joinBy ''

var warehouse2 = warehouse map (toArray($) map ($ match {
    case "#" -> "##"
    case "O" -> "[]"
    case "." -> ".."
    case "@" -> "@."
}) joinBy '')

fun getPosition(warehouse: Array<String>): Position =
    (warehouse flatMap ((line, y) ->
        (0 to sizeOf(line)) as Array map (x) ->
            if (warehouse[y][x] == "@") { x: x, y: y } else { x: -1, y: -1 }
    ) filter $.x != -1)[0]

fun setPosition(warehouse: Array<String>, position: Position, value: String): Array<String> =
    warehouse update {
        case [position.y] -> warehouse[position.y] mapString if ($$ == position.x) value else $
    }

fun left(position: Position): Position =
    { x: position.x - 1, y: position.y }

fun right(position: Position): Position =
    { x: position.x + 1, y: position.y }

fun up(position: Position): Position =
    { x: position.x, y: position.y - 1 }

fun down(position: Position): Position =
    { x: position.x, y: position.y + 1 }

fun moveHorizontal(line: String): String = do {
    var pos = (line find "@")[0]
    var space = ((substring(line, pos + 1, sizeOf(line)) substringBefore "#") find ".")[0]
    ---
    if (space != null)
        substring(line, 0, pos)
            ++ ".@" ++ substring(line, pos + 1, pos + 1 + space)
            ++ substring(line, pos + 2 + space, sizeOf(line))
    else line
}

fun moveVertical(warehouse: Array<String>, position: Position, direction: String): Array<String> = do {
    var newPos = direction match  {
        case "v" -> down(position)
        case "^" -> up(position)
    }
    ---
    warehouse[newPos.y][newPos.x] match {
        case "." -> setPosition(warehouse, newPos, warehouse[position.y][position.x])
            then setPosition($, position, ".")
        case "#" -> warehouse
        case "O" -> moveVertical(warehouse, newPos, direction)
            then setPosition($, newPos, warehouse[position.y][position.x])
        case "[" -> moveVertical(warehouse, newPos, direction)
            then (movedFirstPart) ->
                if (movedFirstPart != warehouse)
                    moveVertical(movedFirstPart, right(newPos), direction)
                        then (movedBothParts) -> 
                            if (movedBothParts != movedFirstPart)
                                movedBothParts
                                    then setPosition($, position, ".")
                                        then setPosition($, newPos, warehouse[position.y][position.x])
                            else warehouse
                else warehouse
        case "]" -> moveVertical(warehouse, newPos, direction)
            then (movedFirstPart) ->
                if (movedFirstPart != warehouse)
                    moveVertical(movedFirstPart, left(newPos), direction)
                        then (movedBothParts) -> 
                            if (movedBothParts != movedFirstPart)
                                movedBothParts
                                    then setPosition($, position, ".")
                                        then setPosition($, newPos, warehouse[position.y][position.x])
                            else warehouse
                else warehouse
    }
}

fun move(warehouse: Array<String>, direction: String): Array<String> = do {
    var pos = getPosition(warehouse)
    ---
    direction match {
        case ">" -> 
            warehouse update {
                case [pos.y] -> moveHorizontal(warehouse[pos.y])
            }
        case "<" ->
            warehouse update {
                case [pos.y] -> reverse(moveHorizontal(reverse(warehouse[pos.y])))
            }
        case "v" ->
            moveVertical(warehouse, pos, direction)
                then (newWarehouse) ->
                    if (newWarehouse != warehouse)
                        newWarehouse update {
                            case [pos.y] -> newWarehouse[pos.y] mapString if ($$ == pos.x) "." else $
                            case [pos.y + 1] -> newWarehouse[pos.y + 1] mapString if ($$ == pos.x) "@" else $
                        }
                    else warehouse
        case "^" ->
            moveVertical(warehouse, pos, direction)
                then (newWarehouse) ->
                    if (newWarehouse != warehouse)
                        newWarehouse update {
                            case [pos.y] -> newWarehouse[pos.y] mapString if ($$ == pos.x) "." else $
                            case [pos.y - 1] -> newWarehouse[pos.y - 1] mapString if ($$ == pos.x) "@" else $
                        }
                    else warehouse
    }
}
---
{
    part1: moves reduce ((direction, warehouse = warehouse) ->
        move(warehouse, direction)
    ) then $ flatMap ((row, y) ->
        toArray(row) map ((spot, x) ->
            if (spot == "O") 100 * y + x else 0
        )
    ) then sum($),
    part2: moves reduce ((direction, warehouse = warehouse2) ->
        move(warehouse, direction)
    ) then $ flatMap ((row, y) ->
        toArray(row) map ((spot, x) ->
            if (spot == "[") 100 * y + x else 0
        )
    ) then sum($)
}
