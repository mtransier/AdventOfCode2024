%dw 2.0
import indexWhere, partition from dw::core::Arrays
import lines from dw::core::Strings
import update from dw::util::Values

output application/json

var trackMap = lines(payload)

type Node = { x: Number, y: Number, distance: Number }

fun findNode(marker: String): Node = {
    x: (trackMap filter ($ contains marker))[0] indexOf marker,
    y: trackMap indexWhere ($ contains marker),
    distance: 0
}

var start = findNode("S")
var end = findNode("E")

fun getNeighbors(node: Node): Array<Node> = [
    { x: node.x, y: node.y - 1, distance: node.distance + 1 },
    { x: node.x, y: node.y + 1, distance: node.distance + 1 },
    { x: node.x - 1, y: node.y, distance: node.distance + 1 },
    { x: node.x + 1, y: node.y, distance: node.distance + 1 }
] filter $.x >= 0 and $.y >= 0 and $.y < sizeOf(trackMap) and $.x < sizeOf(trackMap[0])

fun createTrack(track: Array<Node>): Array<Node> = do {
    var nextNode = (getNeighbors(track[-1])
        filter !($.x == track[-2].x and $.y == track[-2].y) and trackMap[$.y][$.x] != "#")[0]
    ---
    if (nextNode.x == end.x and nextNode.y == end.y) track << nextNode
    else createTrack(track << nextNode)
}

fun getNodesInRadius(from: Node, radius: Number): Array<Node> =
    (from.x - radius to from.x + radius) as Array<Number> flatMap ((x) ->
        (from.y - radius to from.y + radius) as Array<Number> map ((y) ->
            { x: x, y: y, distance: from.distance + abs(from.x - x) + abs(from.y - y) }
        )
    ) filter $.distance <= from.distance + radius
        and $.x >= 0 and $.y >= 0 and $.y < sizeOf(trackMap) and $.x < sizeOf(trackMap[0])

fun findCheats(track: Array<Node>, maxDuration: Number): Array<Number> =
    track flatMap ((from) ->
        getNodesInRadius(from, maxDuration)
            filter trackMap[$.y][$.x] != "#" and distance["$($.x)|$($.y)"] > $.distance
    ) map (cheat) -> distance["$(cheat.x)|$(cheat.y)"] as Number - cheat.distance

var track = createTrack([start])
var distance = track groupBy "$($.x)|$($.y)" mapObject { ($$): $.distance[0] }
---
{
    part1: findCheats(track, 2) //filter $ >= 100
        groupBy $ orderBy ($$ as Number) mapObject { ($$): sizeOf($) }
            //then sum(valuesOf($)))
    ,
    part2: findCheats(track, 20) filter $ >= 50
        groupBy $ orderBy ($$ as Number) mapObject { ($$): sizeOf($) }
            //then sum(valuesOf($))
}
