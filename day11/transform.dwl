%dw 2.0
import countBy from dw::core::Arrays
import first, last from dw::core::Strings
import update from dw::util::Values

output application/json

var stones = payload splitBy " "
var stoneDict = stones groupBy $ mapObject { ($$): sizeOf($) }

@TailRec
fun blink(stones: Array, maxIterations: Number, iteration: Number = 0): Array =
    if (iteration == maxIterations) stones
    else blink(
        stones flatMap ((stone, index) ->
            if (stone == "0") [1]
            else if (isEven(sizeOf(stone)))
                [stone first (sizeOf(stone) / 2),
                 (stone last (sizeOf(stone) / 2)) as Number as String]
            else [stone * 2024]
        ), maxIterations, iteration + 1
    )

fun blinkStone(stone: String): Array<String> = do {
    var length = sizeOf(stone)
    ---
    if (stone == "0")
        ["1"]
    else if (isEven(length))
        [stone first length / 2, (stone last length / 2) as Number as String]
    else [(stone as Number * 2024) as String]
}

fun blinkStones(stones: Dictionary<Number>, iterations: Number): Dictionary<Number> =
    if (iterations == 0) stones
    else blinkStones(
            keysOf(stones) flatMap ((stone) ->
                blinkStone(stone as String) map { id: $, count: stones[stone as String] }
            ) reduce ((newStone, newStones: Dictionary<Number> = {}) ->
                newStones update {
                    case ."$(newStone.id)"! -> ($ default 0) + newStone.count
                }
            )
        , iterations - 1
    )
---
{
    part1: sizeOf(stones blink 25),
    part2: blinkStones(stoneDict, 75) pluck $ then sum($)
}
