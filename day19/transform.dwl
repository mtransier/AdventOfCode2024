%dw 2.0
import lines, substring from dw::core::Strings
import countBy, some from dw::core::Arrays

output application/json

var towels = lines(payload)[0] splitBy ", "
var patterns = lines(payload)[2 to -1]

@TailRec()
fun fitTowels(patterns: Array<String>): Boolean = do {
    var matchingTowels = towels filter (patterns[0] startsWith $)
    ---
    if (patterns contains null) true
    else if (isEmpty(matchingTowels) and isEmpty(patterns[1 to -1])) false
    else fitTowels((
        patterns[1 to -1] default []
            ++ (matchingTowels map ((towel) -> patterns[0][sizeOf(towel) to -1]))
        ) distinctBy $
    )
}

type Pattern = { pattern: String, count: Number }

@TailRec()
fun fitTowels2(patterns: Array<Pattern>, total: Number = 0): Number = do {
    var matchingTowels = towels filter (patterns[0].pattern startsWith $)
    ---
    if (isEmpty(patterns)) total
    else do {
        var reducedPatterns = matchingTowels map ((towel) ->
            patterns[0] update {
                case .pattern -> patterns[0].pattern[sizeOf(towel) to -1]
            })
        ---
        fitTowels2(
            (patterns[1 to -1] default [] ++ (reducedPatterns filter !isEmpty($.pattern)))
                groupBy ($.pattern default "") pluck { pattern: $$, count: sum($ map $.count) },
            total + (((reducedPatterns filter isEmpty($.pattern)) map $.count) then sum($))
        )
    }
}

var possiblePatterns = patterns filter ((pattern) -> fitTowels([pattern]))
---
{
    part1: sizeOf(possiblePatterns),
    part2: possiblePatterns map ((pattern) ->
        fitTowels2([{ pattern: pattern, count: 1 }])) then sum($)
}