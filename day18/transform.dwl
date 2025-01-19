%dw 2.0
import indexWhere from dw::core::Arrays
import lines from dw::core::Strings
import update from dw::util::Values

output application/json

var xMax = 6
var yMax = 6
var blocks = lines(payload)

var start = { x: 0, y: 0 }
var end = { x: xMax, y: yMax }

fun memory(bytes: Number)  = (0 to yMax) as Array map ((y) ->
    (0 to xMax) as Array map ((x) ->
        if (blocks[0 to min([bytes, sizeOf(blocks)]) - 1] contains "$(x),$(y)") "#" else "."
    ) joinBy ''
)

type Position = { x: Number, y: Number }
type Node = { position: Position, f: Number, g: Number }
type State = { openList: Array<Node>, closedList: Array<Position> }

fun heuristic(position: Position, goal: Position): Number =
    abs(position.x - goal.x) + abs(position.y - goal.y)

@TailRec()
fun aStar(state: State, bytes: Number): Number =
    if (isEmpty(state.openList)) -1
    else do {
        var current: Node = (state.openList orderBy $.f)[0]
        ---
        if (current.position == end) current.g
        else do {
            var neighbors: Array<Position> = [
                { x: current.position.x - 1, y: current.position.y },
                { x: current.position.x + 1, y: current.position.y },
                { x: current.position.x, y: current.position.y - 1 },
                { x: current.position.x, y: current.position.y + 1 }
            ] filter (((0 to xMax) as Array contains $.x) and ((0 to yMax) as Array contains $.y))
                and memory(bytes)[$.y][$.x] != "#" and !(state.closedList contains $)
            ---
            aStar(
                neighbors reduce ((neighbor, newState = state) -> do {
                    var tentative_g = current.g + 1
                    var neighborNode = (newState.openList filter ($.position.x == neighbor.x and $.position.y == neighbor.y))[0]
                    ---
                    if (isEmpty(neighborNode))
                        newState update {
                            case .openList -> $ << {
                                position: neighbor,
                                g: tentative_g,
                                f: tentative_g + heuristic(neighbor, end)
                            }
                        }
                    else if (tentative_g < neighborNode.g)
                        newState update {
                            case .openList -> (
                                $ update ($ indexWhere ($.x == neighbor.x and $.y == neighbor.y)) with (node) -> (
                                    node update {
                                        case .g -> tentative_g
                                        case .f -> $ - (neighborNode.g - tentative_g)
                                    }
                                )
                            ) as Array<Node>
                        }
                    else newState
                }) update {
                    case .openList -> $ - current
                    case .closedList -> $ << current.position
                }, bytes
            )
        }
    }

var startNode = { openList: [{ position: start, g: 0, f: heuristic(start, end) }], closedList: [] }

@TailRec()
fun binarySearch(low: Number, high: Number): String = do {
    var bytes = round((low + high) / 2)
    ---
    if (low == high)
        if (aStar(startNode, bytes) == -1) blocks[bytes - 1]
        else blocks[bytes]
    else if (aStar(startNode, bytes) != -1)
        binarySearch(bytes + 1, high)
    else
        binarySearch(low, bytes - 1)
}
---
{
    part1: aStar(startNode, 12),
    part2: binarySearch(13, 25)
}