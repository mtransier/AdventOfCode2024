%dw 2.0
import divideBy, partition from dw::core::Arrays
import lines from dw::core::Strings
import toArray from dw::util::Coercions

output application/json

var schematics = (lines(payload) divideBy 8) map $ map ($ filter !isEmpty($)) partition ($[0] matches /#{5}/)

fun schematicsToHeights(schematics: Array<Array<String>>): Array<Array<Number>> =
    schematics map ((schematic) ->
        schematic reduce ((line, heights = [0, 0, 0, 0, 0, 0]) ->
            zip(heights, toArray(line) map if ($ == "#") 1 else 0) map sum($)
        ) map $ - 1
    )

var locks = schematicsToHeights(schematics.success)
var keys = schematicsToHeights(schematics.failure)
---
{
    part1: (
        locks flatMap (lock) -> keys map (key) -> zip(lock, key) map sum($)
    ) filter max($) < 6
        then sizeOf($)
}
