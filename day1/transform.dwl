%dw 2.0
import lines from dw::core::Strings

output application/json

fun createList(note: String, index: Number): Array<Number> =
    lines(note) map ($ splitBy '   ') map ($[index] as Number)

var list1 = createList(payload, 0)
var list2 = createList(payload, 1) orderBy $
---
{
	part1: list1 orderBy $ map abs($ - list2[$$]) reduce $$ + $,
	part2: list1 map ((element) ->
		element * sizeOf(list2 filter $ == element)
	) reduce $$ + $
}
