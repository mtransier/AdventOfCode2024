%dw 2.0
import indexWhere from dw::core::Arrays
import lines, repeat from dw::core::Strings
import toArray from dw::util::Coercions

output application/json

var codes = lines(payload) map toArray($)

type Button = { x: Number, y: Number }
type Pad = Array<Array<String>>
type State = { cache: Dictionary<Number>, result: Number }

var numPad: Pad = [
    ["7", "8", "9"],
    ["4", "5", "6"],
    ["1", "2", "3"],
    [" ", "0", "A"]
]

var dirPad: Pad = [
    [" ", "^", "A"],
    ["<", "v", ">"]
]

fun button(pad: Pad, button: String): Button = {
    x: pad[pad indexWhere ($ contains button)] indexWhere ($ == button),
    y: pad indexWhere ($ contains button)
}

fun pushButton(pad: Pad, prev: String, next: String): Array<String> = do {
    var prevButton = button(pad, prev)
    var nextButton = button(pad, next)
    var horizontalMoves =
        if (prevButton.x > nextButton.x) (1 to prevButton.x - nextButton.x) as Array map "<"
        else if (prevButton.x < nextButton.x) (1 to nextButton.x - prevButton.x) as Array map ">"
        else []
    var verticalMoves = if (prevButton.y > nextButton.y) (1 to prevButton.y - nextButton.y) as Array map "^"
        else if (prevButton.y < nextButton.y) (1 to nextButton.y - prevButton.y) as Array map "v"
        else []
    var moves = 
        if (horizontalMoves[0] == "<") horizontalMoves ++ verticalMoves
        else verticalMoves ++ horizontalMoves
    ---
    (
        if ((prevButton.y == 3 and nextButton.x == 0) or (prevButton.x == 0 and nextButton.y == 3)
            or (prev == "<" and nextButton.y == 0) or (prevButton.y == 0 and next == "<")) moves[-1 to 0]
        else moves
    ) << "A"
}

fun getMoves(code: Array<String>): Array<Array<String>> =
    code map (numKey, index) ->
        [if (index == 0) "A" else code[index - 1], numKey]

fun createCacheKey(depth: Number, move: Array<String>): String =
    "$(depth as String)|$(move joinBy '')"

fun getSequenceCached(code: Array<String>, depth: Number, state: State = { cache: {}, result: 0 }): State = do {
    var moves = getMoves(code)
    ---
    if (depth == 0) state update { case .result -> sizeOf(code) }
    else moves reduce ((move, newState = state) -> do {
        var cacheKey = createCacheKey(depth, move)
        var cached = newState.cache[cacheKey]
        ---
        if (cached != null) newState
        else do {
            var downState = pushButton(dirPad, move[0], move[1]) then (buttons) ->
                    getSequenceCached(buttons, depth - 1, newState)
            ---
            newState update {
                case .cache -> downState.cache
            } update {
                case .cache."$(cacheKey)"! -> downState.result
            }
        }
    }) then (newState) -> newState update {
        case .result -> moves reduce ((move, result = 0) -> result + newState.cache[createCacheKey(depth, move)] as Number)
    }
}

fun getSequence(pad: Pad, code: Array<String>): Array<String> =
    code flatMap ((numKey, index) ->
        pushButton(pad, if (index == 0) "A" else code[index - 1], numKey))
---
{
    part1: codes map ((code) ->
        (getSequence(numPad, code)) then getSequence(dirPad, $) then getSequence(dirPad, $)
            then sizeOf($) * (code joinBy '')[0 to 2] as Number
    ) then sum($),
    part2: codes map ((code) ->
        getSequence(numPad, code) then getSequenceCached($, 25)
            then $.result * (code joinBy '')[0 to 2] as Number
    ) then sum($)
}