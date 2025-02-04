%dw 2.0
import indexWhere from dw::core::Arrays
import indexOf, substring, substringBefore from dw::core::Strings

output application/json

fun extractMatch(text: String, index: Number): Array<Number> = do {
    var matched = substring(text, index, sizeOf(text))
    ---
    (substring(substringBefore(matched, ")"), 4, indexOf(matched, ")"))
        splitBy ",")
            then $ as Array<Number>
}

fun doOrDont(index: Number, dos: Array<Number>, donts: Array<Number>): Boolean = do {
    var doIndex = dos indexWhere $ > index
    var dontIndex = donts indexWhere $ > index
    ---
    (if (doIndex == 0) 0 else if (doIndex == -1) dos[-1] else dos[doIndex - 1]) >=
        (if (dontIndex == 0) 0 else if (dontIndex == -1) donts[-1] else donts[dontIndex - 1])
}

fun execute(factors: Array<Number>|String, index: Number, dos: Array<Number>, donts: Array<Number>): Number =
    if (factors is Array and doOrDont(index, dos, donts))
        factors[0] * factors[1]
    else 0
---
{
    part1: payload find(/mul\(\d+,\d+\)/)
        map extractMatch(payload, $[0])
            map $[0] * $[1]
                then sum($),
    part2: do {
        var instructions = (payload2 find(/mul\(\d+,\d+\)|(do\(\))|(don't\(\))/)
                                map if ($[2] != -1) "don't"
                                    else if ($[1] != -1) "do"
                                    else extractMatch(payload2, $[0]))
        var dos = instructions find "do"
        var donts = instructions find "don't"
        ---
        instructions map execute($, $$, dos, donts) then sum($)
    }
}