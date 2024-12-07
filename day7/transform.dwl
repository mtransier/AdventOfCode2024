%dw 2.0
import some from dw::core::Arrays
import toArray from dw::util::Coercions
import leftPad, lines from dw::core::Strings
import toBinary from dw::core::Numbers

output application/json

var equations = lines(payload) map ($ splitBy ": ")
    map { result: $[0] as Number, operands: $[1] splitBy " " map $ as Number }

fun calculate(operands: Array<Number>, operators: Array<String>): Number =
    (("0" >> operators) zip operands) reduce ((operation, accumulator = 0) -> 
        operation[0] match {
            case "0" -> accumulator + operation[1] as Number
            case "1" -> accumulator * operation[1] as Number
            case "2" -> (accumulator as String ++ operation[1] as String) as Number
        }
    )

fun toTernary(number: Number): Number =
    if (number < 3)
        number
    else
        toTernary(floor(number / 3)) * 10 + (number mod 3)
---
{
    part1: (
        equations map (equation) -> (
            (((0 to pow(2, sizeOf(equation.operands) - 1) - 1) as Array map 
                leftPad(toBinary($), sizeOf(equation.operands) - 1, "0") map (operators) ->
                    calculate(equation.operands, toArray(operators)))
                        filter ($ == equation.result))[0]
        )
    ) filter !isEmpty($)
        then sum($),
    part2: (
        equations map (equation) -> (
            (((0 to pow(3, sizeOf(equation.operands) - 1) - 1) as Array map 
                leftPad(toTernary($), sizeOf(equation.operands) - 1, "0") map (operators) ->
                    calculate(equation.operands, toArray(operators)))
                        filter ($ == equation.result))[0]
        )
    ) filter !isEmpty($)
        then sum($)
}
