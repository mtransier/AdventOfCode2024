%dw 2.0
import slice from dw::core::Arrays
import lines from dw::core::Strings

output application/json

var spec = lines(payload)
var equations = (0 to sizeOf(spec) / 4) as Array map
    slice(spec, $ * 4, $ * 4 + 3) map
        {
            a1: ($[0] match /.* X\+(\d+),.*/)[1],
            b1: ($[1] match /.* X\+(\d+),.*/)[1],
            c1: ($[2] match /.* X=(\d+),.*/)[1],
            a2: ($[0] match /.* Y\+(\d+)/)[1],
            b2: ($[1] match /.* Y\+(\d+)/)[1],
            c2: ($[2] match /.* Y=(\d+)/)[1]
        }

fun solveEquations(a1, b1, c1, a2, b2, c2): Object = do {
    var determinant = a1 * b2 - a2 * b1
    ---
    {
        A: (c1 * b2 - c2 * b1) / determinant,
        B: (a1 * c2 - a2 * c1) / determinant
    }
}
---
{
    part1: equations map solveEquations($.a1, $.b1, $.c1, $.a2, $.b2, $.c2)
        filter isInteger($.A) and isInteger($.B)
            map (3 * $.A + $.B)
                then sum($),
    part2: equations map solveEquations($.a1, $.b1, $.c1 + 10000000000000, $.a2, $.b2, $.c2 + 10000000000000)
        filter isInteger($.A) and isInteger($.B)
            map (3 * $.A + $.B)
                then sum($)
}                