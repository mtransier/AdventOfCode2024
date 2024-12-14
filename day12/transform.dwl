%dw 2.0
import indexWhere, some from dw::core::Arrays
import lines from dw::core::Strings
import update from dw::util::Values

output application/json

type Plant = { x: Number, y: Number }
type Region = Array<Plant>

var gardenMap = lines(payload)
var plants: Dictionary<Array<Plant>> = ((0 to sizeOf(gardenMap) - 1) as Array flatMap (y) ->
    (0 to sizeOf(gardenMap[y]) - 1) as Array map (x) ->
        { x: x, y: y, plantType: gardenMap[y][x] }
) groupBy $.plantType
    mapObject (plants, plantType) ->
        { (plantType): plants map ((plant) -> (plant - "plantType") as Plant) }

fun createRegions(plants: Array<Plant>): Array<Region> =
    plants reduce (plant, mergedRegions = []) -> do {
        var leftNeighbor = mergedRegions indexWhere ($ contains { x: plant.x - 1, y: plant.y })
        var upperNeighbor = mergedRegions indexWhere ($ contains { x: plant.x, y: plant.y - 1 })
        ---
        if (leftNeighbor != -1 and upperNeighbor != -1 and leftNeighbor != upperNeighbor)
            mergedRegions update {
                case [upperNeighbor] -> mergedRegions[leftNeighbor] ++ $ << plant
            } filter $$ != leftNeighbor
        else if (leftNeighbor != -1)
            mergedRegions update {
                case [leftNeighbor] -> $ << plant
            }
        else if (upperNeighbor != -1)
            mergedRegions update {
                case [upperNeighbor] -> $ << plant
            }
        else
            mergedRegions << [plant]
    } as Array<Region>

fun hasLeftFence(plant: Plant): Boolean =
    plant.x == 0 or gardenMap[plant.y][plant.x - 1] != gardenMap[plant.y][plant.x]

fun hasRightFence(plant: Plant): Boolean =
    plant.x == sizeOf(gardenMap[plant.y]) or gardenMap[plant.y][plant.x + 1] != gardenMap[plant.y][plant.x]

fun hasUpFence(plant: Plant): Boolean =
    plant.y == 0 or gardenMap[plant.y - 1][plant.x] != gardenMap[plant.y][plant.x]

fun hasDownFence(plant: Plant): Boolean =
    plant.y == sizeOf(gardenMap) or gardenMap[plant.y + 1][plant.x] != gardenMap[plant.y][plant.x]

fun fences(region: Region): Number =
    region map ((plant) ->
        [ hasLeftFence(plant), hasRightFence(plant), hasUpFence(plant), hasDownFence(plant) ] filter $ then sizeOf($)
    ) then sum($)

fun sides(region: Region): Number =
    region map ((plant) ->
        [
            hasLeftFence(plant) and (plant.y == 0
                or !(region contains { x: plant.x, y: plant.y - 1 })
                or !hasLeftFence({ x: plant.x, y: plant.y - 1 })),
            hasRightFence(plant) and (plant.y == 0
                or !(region contains { x: plant.x, y: plant.y - 1 })
                or !hasRightFence({ x: plant.x, y: plant.y - 1 })),
            hasUpFence(plant) and (plant.x == 0
                or !(region contains { x: plant.x - 1, y: plant.y })
                or !hasUpFence({ x: plant.x - 1, y: plant.y })),
            hasDownFence(plant) and (plant.x == 0
                or !(region contains { x: plant.x - 1, y: plant.y })
                or !hasDownFence({ x: plant.x - 1, y: plant.y }))
        ] filter $ then sizeOf($)
    ) then sum($)

var regions = plants pluck createRegions($) then flatten($)
---
{
    part1: regions map ((region) ->
        sizeOf(region) * fences(region)
    ) then sum($),
    part2: regions map ((region) ->
        sizeOf(region) * sides(region)
    ) then sum($)
}