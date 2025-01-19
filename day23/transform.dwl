%dw 2.0
import some from dw::core::Arrays
import lines from dw::core::Strings

output application/json

var connections: Array<String> = lines(payload)
var connectionTable: Dictionary<Array<String>> =
    connections map $ reduce (connection, connectionTable = {}) -> do {
        var peers = connection splitBy "-"
        ---
        connectionTable update {
            case ."$(peers[0])"! -> ($ default []) << peers[1]
            case ."$(peers[1])"! -> ($ default []) << peers[0]
        }
    }

var hosts: Array<String> = connections flatMap ($ splitBy "-") distinctBy $
var graph: Array<Array<Boolean>> = (0 to sizeOf(hosts) - 1) as Array map (i) ->
    (0 to sizeOf(hosts) - 1) as Array map (j) ->
        (connections contains "$(hosts[i])-$(hosts[j])")
            or (connections contains "$(hosts[j])-$(hosts[i])")

fun combinations(hosts: Array<String>): Array<Array<String>> =
    hosts flatMap ((peer1, index) ->
        hosts[index + 1 to -1] map (peer2) ->
            [peer1, peer2]
    ) filter !isEmpty($)

fun isConnected(peers: Array<String>): Boolean =
    connectionTable[peers[0]] contains peers[1]

fun isClique(size: Number, store: Array<Number>): Boolean = !(do {
    var vertices = store[0 to size - 1]
    ---
    if (size == 1) false
    else (
        (0 to (size - 2)) as Array flatMap (i) -> (
            ((i + 1) to (size - 1)) as Array map (j) ->
                graph[vertices[i]][vertices[j]]
        )
    ) some !$
})

fun maxClique(startVertex: Number, currentSize: Number, store: Array<Number> = []): Array<Number> = (
    (startVertex + 1 to (sizeOf(hosts) - 1)) as Array<Number> map (nextVertex) -> do {
        var newStore = store << nextVertex
        ---
        if (!isClique(currentSize + 1, newStore)) store
        else do {
            var largerClique = maxClique(nextVertex, currentSize + 1, newStore)
            ---
            if (sizeOf(largerClique) > currentSize + 1)
                largerClique
            else
                newStore
        }
    }
) then $ maxBy(sizeOf($)) default store
---
{
    part1: (
        connectionTable pluck ((neighbors, host) -> {
                (host): combinations(neighbors)
                    filter isConnected($)
            } pluck ((value, key) ->
                value map (($ << key) orderBy $)
            ) then flatten($)
        ) then flatten($) map ($ joinBy ",")
    ) distinctBy $
        filter ($ matches /(^|.*,)t.+/)
            orderBy $ then sizeOf($),
    part2: maxClique(0, 0) map hosts[$] orderBy $ joinBy ","
}