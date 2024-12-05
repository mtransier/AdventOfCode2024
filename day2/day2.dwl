%dw 2.0
output application/json
fun isSafe(report: Array<Number>): Boolean = do {
    var diff = 1 to sizeOf(report) - 1
            map (report[$] - report[$ - 1])
    ---
    isEmpty(diff filter $ < 1 or $ > 3)
        or isEmpty(diff filter $ > -1 or $ < -3)
}
fun damper(report: Array<Number>) =
    (report[1 to sizeOf(report) - 1] >>
        ((1 to sizeOf(report) - 1)
            map (report[0 to $ - 1] ++ (report[($ + 1) to sizeOf(report) - 1] default []))
        )
    ) map isSafe($)
        reduce $$ or $

var reports = payload splitBy '\r\n'
---
{
	part1: sizeOf(reports map isSafe($ splitBy ' ') filter $),
	part2: sizeOf(reports map damper($ splitBy ' ') filter $)
}