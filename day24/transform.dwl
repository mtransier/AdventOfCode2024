%dw 2.0
import drop, dropWhile, firstWith, some, takeWhile from dw::core::Arrays
import toBinary from dw::core::Numbers
import leftPad, lines from dw::core::Strings
import toArray from dw::util::Coercions

output application/json

type Operation = { operands: Array<String>, operator: String, target: String }

var inputWires: Dictionary<Boolean> = lines(payload) takeWhile !isEmpty($)
    map ((line) -> line splitBy ": ")
       reduce ((variable, wires = {}) -> wires ++ { (variable[0]): variable[1] == "1" })
var logicArray: Array<Operation> = lines(payload) dropWhile !isEmpty($) drop 1
    map ((operation) -> operation match /(.+) (.+) (.+) -> (.+)/)
        map { operands: [$[1], $[3]], operator: $[2], target: $[4] } 

fun lookUp(wire: String): Operation =
    logicArray firstWith $.target == wire default dw::Runtime::fail("Wire $(wire) not found")

fun solve(inputWires, operation: Operation): Boolean = do {
    var op1 = inputWires[operation.operands[0]]
        default solve(inputWires, lookUp(operation.operands[0]))
    var op2 = inputWires[operation.operands[1]]
        default solve(inputWires,lookUp(operation.operands[1]))
    ---
    operation.operator match {
        case "AND" -> op1 and op2
        case "OR" -> op1 or op2
        case "XOR" -> op1 != op2
    }
}

fun decode(values: Array<Boolean>): Number =
    values reduce ((target, result = 0) -> 2 * result + if (target default false) 1 else 0)

fun add(inputWires): Number =
    (logicArray filter ($.target startsWith "z") orderBy $.target)[-1 to 0]
        map solve(inputWires, lookUp($.target)) then decode($)

fun follow(wire: String): Operation | String =
    if ((wire startsWith "x") or (wire startsWith "y")) wire
    else logicArray firstWith ($.target == wire) default "-"
---
{
    part1: add(inputWires),
    part2: (2 to 44) map follow("z" ++ leftPad($, 2, "0")) map ((zOperation) ->
        if (zOperation.operator != "XOR")
            zOperation.target
        else do {
            var xorOperations = (zOperation.operands map follow($)) orderBy $.operands[0]
            ---
            if (xorOperations[0].operator != "OR" or (xorOperations[0].operands[0] matches /.\d\d/))
                xorOperations[0].target
            else if (xorOperations[1].operator != "XOR" or !(xorOperations[1].operands[0] matches /.\d\d/))
                xorOperations[1].target
            else do {
                var orOperations = xorOperations[0].operands map follow($)
                ---
                if (orOperations[0].operator != "AND")
                    orOperations[0].target
                else if (orOperations[1].operator != "AND")
                    orOperations[1].target
                else ""
            }
        }
    ) filter !isEmpty($) orderBy $ joinBy ","
}