%dw 2.0
import every, firstWith, some, takeWhile from dw::core::Arrays
import update from dw::util::Values

output application/json

var rules = payload splitBy '\r\n' takeWhile !isBlank($) map (($ splitBy '|') map $ as Number) as Array<Number>
var pageUpdates = payload splitBy '\r\n' filter ($ contains ',') map (($ splitBy ',') map $ as Number) as Array<Number>

fun checkRules(pages: Array<Number>): Boolean =
    (pages[1 to -1] map (page, index) ->
        rules filter $[0] == page
            map (pages[0 to index] contains $[1]) some $
    ) every !$

fun fixRules(pages: Array<Number>): Array<Number> = do {
    var firstBrokenRule = (
        (
            pages[1 to -1] map (page, index) ->
                rules filter $[0] == page
                    firstWith (pages[0 to index] contains $[1])
        ) filter !isEmpty($)
    )[0]
    ---
    if (!isEmpty(firstBrokenRule))
        fixRules(swapElements(pages, firstBrokenRule[0] default 0, firstBrokenRule[1] default 0))
    else pages
}

fun swapElements(array: Array<Number>, a: Number, b: Number): Array<Number> = do {
    var indexA = array indexOf a
    var indexB = array indexOf b
    ---
    (array update indexA with b update indexB with a) as Array<Number>
}

---
{
    part1: pageUpdates filter checkRules($) map $[sizeOf($) / 2] then sum($),
    part2: pageUpdates filter !checkRules($) map fixRules($) map $[sizeOf($) / 2] then sum($)
}