%dw 2.0
import fromBinary, toBinary from dw::core::Numbers
import leftPad, lines, mapString from dw::core::Strings

output application/json

var prices = lines(payload) map $ as Number
var prices2 = lines(payload2) map $ as Number

fun mix(a: Number, b: Number): Number = do {
    var aBinary: String = toBinary(a)
    var bBinary: String = toBinary(b)
    var length: Number = max([sizeOf(aBinary), sizeOf(bBinary)]) as Number
    var bBinaryPadded = leftPad(bBinary, length, "0")
    ---
    fromBinary(
        leftPad(aBinary, length, "0") mapString
            if ($ == bBinaryPadded[$$]) "0" else "1"
    )
}

fun prune(a: Number): Number =
    a mod 16777216

fun nextPrice(price: Number): Number =
    prune(price * 64) mix price
        then (floor($ / 32) mix $)
        then (prune($ * 2048) mix $)

fun updateSequences(price: Number, sequences: Dictionary<Number>): Dictionary<Number> = (
    (1 to 2000) as Array reduce ((n, priceSequence = [ { price: price, sequence: [null, null, null, null] } ]) ->
        priceSequence << do {
            var price = nextPrice(priceSequence[-1].price)
            ---
            {
                price: price,
                sequence: (priceSequence[-1].sequence[-3 to -1] default [])
                    << ((price mod 10) - (priceSequence[-1].price mod 10))
            }
        }
    ) filter !($.sequence contains null)
        distinctBy $.sequence
) reduce ((priceEntry, newSequences = sequences) -> do {
        var p = priceEntry.price mod 10
        ---
        newSequences update {
            case ."$(priceEntry.sequence joinBy '')"! -> ($ default 0) + p
        }
    }
)
---
{
    part1: prices map ((price) -> do { var logger = log ($$) ---
        (1 to 2000) reduce ((n, price = price as Number) -> nextPrice(price))
    }) then sum($),
    part2: prices2 reduce ((price, sequences = {}) ->
        updateSequences(price, sequences)
    ) pluck $ then max($ as Array<Number>)
}
