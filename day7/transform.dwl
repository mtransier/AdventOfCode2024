%dw 2.0
import firstWith from dw::core::Arrays
import toArray from dw::util::Coercions
import leftPad, lines from dw::core::Strings
import toBinary from dw::core::Numbers

output application/json

var equations = lines(payload) map ($ splitBy ": ")
    map { result: $[0] as Number, operands: $[1] splitBy " " map $ as Number }

fun toTernary(number: Number): String =
    if (number < 3)
        number as String
    else
        toTernary(floor(number / 3)) ++ (number mod 3) as String

fun calculate(operands: Array<Number>, operators: Array<String>): Number =
    (("0" >> operators) zip operands) reduce ((operation, accumulator = 0) -> 
        operation[0] match {
            case "0" -> accumulator + operation[1] as Number
            case "1" -> accumulator * operation[1] as Number
            case "2" -> (accumulator as String ++ operation[1] as String) as Number
        }
    )

fun findSolutions(equations: Array<Object>, base: Number, toBase: (Number) -> String) =
    equations map (equation) -> (
        ((0 to pow(base, sizeOf(equation.operands) - 1) - 1) as Array map 
            leftPad(toBase($), sizeOf(equation.operands) - 1, "0") firstWith (operators) ->
                calculate(equation.operands, toArray(operators)) == equation.result
        ) then equation.result
    )
---
{
    part1: findSolutions(equations, 2, toBinary) filter !isEmpty($) then sum($ as Array<Number>),
    part2: findSolutions(equations, 3, toTernary) filter !isEmpty($) then sum($ as Array<Number>)
}
