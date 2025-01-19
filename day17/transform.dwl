%dw 2.0
import fromBinary, toBinary from dw::core::Numbers
import leftPad, lines, mapString from dw::core::Strings

output application/json

type State = { program: Array<Number>, A: Number, B: Number, C: Number, out: Array<Number>, ip: Number }

var in = lines(payload)
var initialState: State = {
    program: ((in filter ($ contains "Program"))[0] match /.*: (.+)/)[1] splitBy ',' map $ as Number,
    A: ((in filter ($ contains "Register A"))[0] match /.* A: (\d+)/)[1] as Number,
    B: ((in filter ($ contains "Register B"))[0] match /.* B: (\d+)/)[1] as Number,
    C: ((in filter ($ contains "Register C"))[0] match /.* C: (\d+)/)[1] as Number,
    out: [],
    ip: 0
}

fun xor(a: Number, b: Number): Number = do {
    var aBinary: String = toBinary(a)
    var bBinary: String = toBinary(b)
    var length: Number = max([sizeOf(aBinary), sizeOf(bBinary)]) as Number
    ---
    fromBinary(
        leftPad(aBinary, length, "0") mapString
            if ($ == leftPad(bBinary, length, "0")[$$]) "0" else "1"
    )
}

fun combo(state: State): Number =
    state.program[state.ip + 1] match {
        case literal if ((0 to 3) as Array contains literal) -> literal
        case 4 -> state.A
        case 5 -> state.B
        case 6 -> state.C
        else -> dw::Runtime::fail("Illegal combo operand")
    }

fun ilog<T>(prefix: String = "", state: State, value: T): T =
    //log("$(state.ip) $(prefix)", value)
    value

@TailRec()
fun execute(state: State): State =
    if (state.ip >= sizeOf(state.program)) state
    else execute(
        state.program[state.ip] match {
            case 0 /* adv */ -> state update { case .A -> floor($ / pow(2, ilog("adv", state, combo(state)))) }
            case 1 /* bxl */ -> state update { case .B -> $ xor ilog("bxl", state, state.program[state.ip + 1]) }
            case 2 /* bst */ -> state update { case .B -> ilog("bst", state, combo(state)) mod 8 }
            case 3 /* jnz */ -> state update {
                case .ip -> ilog("jnz", state, if (state.A == 0) $ else state.program[state.ip + 1])
            }
            case 4 /* bxc */ -> state update { case .B -> ilog("bxc", state, state.B) xor state.C }
            case 5 /* out */ -> state update { case .out -> $ << (ilog("out", state, combo(state)) mod 8) }
            case 6 /* bdv */ -> state update { case .B -> floor(state.A / pow(2, ilog("bdv", state, combo(state)))) }
            case 7 /* cdv */ -> state update { case .C -> floor(state.A / pow(2, ilog("cdv", state, combo(state)))) }
            else -> dw::Runtime::fail("Illegal opcode")
        } then $ update {
            case .ip if (state.program[state.ip] != 3 or state.A == 0) -> $ + 2
        }
   )

fun toOctal(decimal: Number): String =
    if (decimal < 8) decimal as String
    else toOctal(floor(decimal / 8)) ++ (decimal mod 8) as String

fun toDecimal(octal: String): Number =
    octal reduce $$ * 8 + $ as Number

@TailRec()
fun findSolution(a: Number, initialState: State): Number = do {
    var out = execute(initialState update { case .A -> a }).out joinBy ''
    var program = initialState.program joinBy ""
    ---
    if (program == out) a
    else findSolution(
        if (program endsWith out) toDecimal(toOctal(a) ++ "0") else a + 1,
        initialState
    )
}
---
{
    part1: execute(initialState).out joinBy ',',
    part2: findSolution(0, initialState)
}