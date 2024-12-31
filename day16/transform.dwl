%dw 2.0
import firstWith, indexWhere from dw::core::Arrays
import lines from dw::core::Strings

output application/json

type Position = { x: Number, y: Number }
type Node = { position: Position, f: Number, g: Number }
type State = { openList: Array<Node>, closedList: Array<Node>, cameFrom: Dictionary<Array<Node>> }

var maze = lines(payload)

fun findNode(marker: String): Position = {
    x: (maze filter ($ contains marker))[0] indexOf marker,
    y: maze indexWhere ($ contains marker),
}

var start = findNode("S")
var end = findNode("E")

@TailRec()
fun reconstructPath(cameFrom: Dictionary<Array<Node>>, current: Array<Node>, path: Array<Array<Node>> = []): Array<Array<Node>> = do {
    var previous = current flatMap ((c) -> do {
        var options = cameFrom["$(c.position.x)|$(c.position.y)"] default []
        ---
        options filter ((o) ->
            sizeOf(options) == 1
                or !((path[-2] firstWith (abs($.position.x - o.position.x) + abs($.position.y - o.position.y) == 2))
                        then ($.position.x != o.position.x and $.position.y != o.position.y) default false)
                or c.g > o.g
        )
    }) distinctBy $
    ---
    if (isEmpty(previous)) path
    else reconstructPath(cameFrom, previous, path << previous)
}

fun direction(first: Position | Null, second: Position): String =
    if (isEmpty(first)) ">"
        else if (first.x < second.x) ">"
        else if (first.x > second.x) "<"
        else if (first.y < second.y) "v"
        else if (first.y > second.y) "^"
        else ">"

fun heuristic(position: Position, goal: Position, direction: String | Null = null): Number =
    abs(position.x - goal.x) + abs(position.y - goal.y)
        + if ((position.x == goal.x and direction == ">") or (position.y == goal.y and direction == "^")) 0
        else if (direction == ">" or direction == "^") 1000 else 2000

@TailRec()
fun aStar(state: State): Object =
    if (isEmpty(state.openList)) {}
    else do {
        var current: Node = (state.openList orderBy $.f)[0]
        //var mazeLogger = if (current.g == 7036)
        //        Logger::logMaze(maze, reconstructPath(state.cameFrom, [current]), start, end, state, current)
        //    else null
        ---
        if (current.position == end) { score: current.g, nodes: reconstructPath(state.cameFrom, [current]) then flatten($) distinctBy $ then sizeOf($) + 1 }
        else do {
            var previousPosition = state.cameFrom["$(current.position.x as String)|$(current.position.y as String)"][0]
            var currentDirection = direction(previousPosition.position, current.position)
            var neighbors: Array<Node> = (
                [
                    { x: current.position.x - 1, y: current.position.y },
                    { x: current.position.x + 1, y: current.position.y },
                    { x: current.position.x, y: current.position.y - 1 },
                    { x: current.position.x, y: current.position.y + 1 }
                ] filter (maze[$.y][$.x] != "#" and $ != previousPosition)
            ) map ((neighbor) -> do {
                var newDirection = direction(current.position, neighbor)
                var tentative_g = current.g + 1 + if (newDirection != currentDirection) 1000 else 0
                ---
                {
                    position: neighbor,
                    g: tentative_g,
                    f: tentative_g + heuristic(neighbor, end, newDirection)
                }
            })
            ---
            aStar(
                neighbors reduce ((n, newState = state) -> do {
                    var openNeighbor = newState.openList firstWith ($.position.x == n.position.x and $.position.y == n.position.y)
                    var closedNeighbor = newState.closedList firstWith ($.position.x == n.position.x and $.position.y == n.position.y)
                    ---
                    if (isEmpty(closedNeighbor) and isEmpty(openNeighbor))
                        newState update {
                            case .openList -> $ << n
                            case .cameFrom -> $ update { case ."$(n.position.x)|$(n.position.y)"! -> [current] }
                        }
                    else if (!isEmpty(closedNeighbor) and n.g == closedNeighbor.g + 1000)
                        newState update {
                            case .cameFrom -> $ update { case ."$(n.position.x)|$(n.position.y)" -> $ << current }
                        }
                    else if (!isEmpty(openNeighbor) and n.g < openNeighbor.g)
                        newState update {
                            case .openList -> $ - openNeighbor + n
                            case .cameFrom -> $ update { case ."$(n.position.x)|$(n.position.y)" -> [current] }
                        }
                    else newState
                }) update {
                    case .openList -> $ - current
                    case .closedList -> $ << current
                }
            )
        }
    }

var startNode = {
    position: start,
    g: 0,
    f: heuristic(start, end)
}
var shortestPaths = aStar({ openList: [startNode], closedList: [], cameFrom: {} })
---
{
    part1: shortestPaths.score,
    part2: shortestPaths.nodes
}