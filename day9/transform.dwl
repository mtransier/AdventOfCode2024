%dw 2.0
import indexWhere, slice, take from dw::core::Arrays
import toArray from dw::util::Coercions
import update from dw::util::Values

output application/json

type Block = Number | "."
type File = { fileId: Number | Null, size: Number }

var diskMap = toArray(trim(payload))

// Part 1
fun checkSum1(blockMap: Array<Block>): Number =
    blockMap map ((if ($ == ".") 0 else $) * $$)
        then sum($)

var blocks: Array<Block> = diskMap flatMap (length, index) ->
    if (length == "0") []
    else (1 to length) map
        (if (isOdd(index)) "." else index / 2)
var freeBlocks = blocks find "."
var blocksToMove = blocks[-1 to 0] filter $ != "." take sizeOf(freeBlocks)

// Part 2
fun checkSum2(fileMap: Array<File>)=//: Number =
    (
        fileMap map ((file, fileIndex) -> do {
            var position = if (fileIndex == 0) 0 else sum(fileMap[0 to fileIndex - 1] map $.size)
            ---
            if (file.fileId == null) 0
            else
                (0 to file.size - 1) map ((position + $) * file.fileId) then sum($)
        })
    ) as Array<Number> then sum($)

var fileMap: Array<File> = (0 to (sizeOf(diskMap) - 1)) as Array map (diskIndex) -> {
    fileId: if (isEven(diskIndex)) diskIndex / 2 else null,
    size: diskMap[diskIndex] as Number
}
---
{
    part1: (
        blocks[0 to (sizeOf(blocks) - sizeOf(freeBlocks) - 1)] map (block, index) ->
            if (block != ".") block
            else blocksToMove[freeBlocks indexOf index]
    ) then checkSum1($),
    part2: (
        (fileMap[-1 to 0] filter !isEmpty($.fileId))
            reduce (file, fileMap = fileMap) -> do {
                var firstFit = fileMap indexWhere ($.fileId == null and $.size >= file.size)
                var fileIndex = fileMap indexOf file
                ---
                if (firstFit != -1 and firstFit < fileIndex)
                    (fileMap update firstFit with (
                        fileMap[firstFit] update {
                            case .size -> $ - file.size
                        }
                    )) update fileIndex with (
                        fileMap[fileIndex] update {
                            case .fileId -> null
                        }
                    ) then (slice($, 0, firstFit) << file ++ slice($, firstFit, sizeOf($)))
                else fileMap
            }
    ) as Array<File> then checkSum2($)
}
