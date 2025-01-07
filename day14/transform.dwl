%dw 2.0
import countBy from dw::core::Arrays
import lines from dw::core::Strings
import logn from dw::util::Math

output application/json

type Robot = { px: Number, py: Number, vx: Number, vy: Number }

var robots: Array<Robot> = (lines(payload) map ($ match /p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/))
    map { px: $[1] as Number, py: $[2] as Number, vx: $[3] as Number, vy: $[4] as Number }
var sizeX = 11
var sizeY = 7

fun progress(robot: Robot, iterations: Number): Robot =
    robot update {
        case .px -> ((($ + iterations * robot.vx) mod sizeX) + sizeX) mod sizeX
        case .py -> ((($ + iterations * robot.vy) mod sizeY) + sizeY) mod sizeY
    }

fun printMap(robots: Array<Robot>): Array<String> =
    (0 to sizeY) as Array map ((y) ->
        (0 to sizeX) as Array map ((x) ->
            sizeOf(robots filter ($.px == x and $.py == y))
                match {
                    case 0 -> " "
                    else -> $ as String
                }
        ) joinBy ''
    )

fun entropy(robots: Array<Robot>): Number =
    (0 to sizeY) as Array map ((y) -> do {
        var p = (robots countBy $.py == y) / sizeOf(robots)
        ---
        if (p > 0) - p * logn(p) / logn(2)
        else 0
    }) then avg($)
---
{
    part1: (robots reduce (robot, newRobots = []) ->
        newRobots << progress(robot, 100))
            map ((robot) ->
                robot match {
                    case q1 if (q1.px < (sizeX - 1) / 2 and q1.py < (sizeY - 1) / 2) -> 1
                    case q2 if (q2.px > (sizeX - 1) / 2 and q2.py < (sizeY - 1) / 2) -> 2
                    case q3 if (q3.px < (sizeX - 1) / 2 and q3.py > (sizeY - 1) / 2) -> 3
                    case q4 if (q4.px > (sizeX - 1) / 2 and q4.py > (sizeY - 1) / 2) -> 4
                    else -> 0
                }
            ) filter $ != 0
                groupBy $
                    pluck sizeOf($)
                        reduce $$ * $,
    part2: (0 to 99) as Array
        map ((i) -> i * 101 + 14)
            map ((iteration) -> do {
                var newRobots = (robots reduce (robot, newRobots = []) ->
                        newRobots << progress(robot, iteration)) as Array<Robot>
                ---
                {
                    iteration: iteration,
                    robots: newRobots,
                    entropy: entropy(newRobots)
                }
            }) filter ($.entropy < 0.06)
                then $[0] update { case .robots -> printMap($) }
}