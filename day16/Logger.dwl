%dw 2.0
import mapString from dw::core::Strings

type Position = { x: Number, y: Number }
type Node = { position: Position, f: Number, g: Number }

fun logMaze(maze: Array<String>,
            path: Array<Array<Node>>,
            start: Position,
            end: Position,
            state: Object = {},
            current: Node = { position: { x: -1, y: -1 }, f: -1, g: -1 }) = do {
    var pathNodes = flatten(path) map $.position
    ---
    log(maze map ((row, y) ->
        row mapString (spot, x) ->
            if (start == { x: x, y: y }) "S"
            else if (end == { x: x, y: y }) "E"
            else if (current.position == { x: x, y: y }) "C"
            else if (flatten(state.cameFrom pluck $) contains { x: x, y: y }) do {
                var nextNode = keysOf(state.cameFrom filterObject ($ contains { x: x, y: y }))[0] splitBy "|"
                ---
                if (x - 1 ~= nextNode[0]) "<"
                else if (y + 1 ~= nextNode[1]) "v"
                else if (x + 1 ~= nextNode[0]) ">"
                else if (y - 1 ~= nextNode[1]) "^"
                else " "
            } else if (!isEmpty(state.openList filter $.position == { x: x, y: y })) "o"
            else if (pathNodes contains { x: x, y: y }) "O"
            else if (!isEmpty(state.closedList filter $.position == { x: x, y: y })) "x"
            else spot
    ))
}