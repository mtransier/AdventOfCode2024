# Advent of Code 2024

My solutions for [Advent of Code 2024](https://adventofcode.com/2024/) written in DataWeave.

## Day 1

Puzzle: [Historian Hysteria](https://adventofcode.com/2024/day/1)

The first thing I learned was that using the function `dw::core::Strings::lines` to read files, the script will be platform-independent - working on Windows, MacOS and Linux - as it takes into account the platform-specific line endings. Also, I didn't know [`then`](https://docs.mulesoft.com/dataweave/latest/dw-core-functions-then) yet, so I used `reduce $$ + $` to sum the lists (instead of `then sum($)`).

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day01/transform.dwl#L1-L17
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day01"><img width="300" src="images/dwplayground-button.png"></a>

## Day 2

Puzzle: [Red-Nosed Reports](https://adventofcode.com/2024/day/2)

Working on day 2 I started to notice that the type system in DataWeave sometimes requires a little nudge by casting. E.g., mapping a range like `(1 to 2) map $` gives you a warning, casting it to an array (`(1 to 2) as Array map $`) removes the warning.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day02/transform.dwl#L1-L28
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day02"><img width="300" src="images/dwplayground-button.png"></a>

## Day 3

Puzzle: [Mull It Over](https://adventofcode.com/2024/day/3)

For this pattern matching exercise I decided to use `find` to return all occurences of any of the relevant patterns. Looking at it from hightsight, it might have been easier to look at larger patterns that already take into account the context (do and don't). And, there might be an easier solution with `scan`.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day03/transform.dwl#L1-L43
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day03"><img width="300" src="images/dwplayground-button.png"></a>

## Day 4

Puzzle: [Ceres Search](https://adventofcode.com/2024/day/4)

Another pattern matching exercise, this time in 2D. While part one still uses `find`(the tool that proved helpful for day 3) after laying out all rows, columns and diogonals, part two involves some manual pattern matching, starting from all A's and checking for M's and S's around.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day04/transform.dwl#L1-L37
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day04"><img width="300" src="images/dwplayground-button.png"></a>

## Day 5

Puzzle: [Print Queue](https://adventofcode.com/2024/day/5)

Here you can see some more mollifying casting/defaulting in action - the compiler doesn't note that there cannot be any null value after an `filter isEmpty($)` and complains. And part 2 brings the first recursive solution, fixing the order of the printed pages one by one.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day05/transform.dwl#L1-L41
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day05"><img width="300" src="images/dwplayground-button.png"></a>

## Day 6

Puzzle: [Guard Gallivant](https://adventofcode.com/2024/day/6)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day06/transform.dwl#L1-L116
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day06"><img width="300" src="images/dwplayground-button.png"></a>

## Day 7

Puzzle: [Bridge Repair](https://adventofcode.com/2024/day/7)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day07/transform.dwl#L1-L38
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day07"><img width="300" src="images/dwplayground-button.png"></a>

## Day 8

Puzzle: [Resonant Collinearity](https://adventofcode.com/2024/day/8)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day08/transform.dwl#L1-L57
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day08"><img width="300" src="images/dwplayground-button.png"></a>

## Day 9

Puzzle: [Disk Fragmenter](https://adventofcode.com/2024/day/9)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day09/transform.dwl#L1-L67
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day09"><img width="300" src="images/dwplayground-button.png"></a>

## Day 10

Puzzle: [Hoof It](https://adventofcode.com/2024/day/10)

This time, I have two solutions for part 1: the initial one designed to solve exactly this part and the solution for part 2, which is also usable for part 1. That happens if you don't know what comes next ... I still decided to keep them both in the sources. Part 1 focuses on finding the reachable points, while part 2 keeps track of the different paths.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day10/transform.dwl#L1-L46
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day10"><img width="300" src="images/dwplayground-button.png"></a>

## Day 11

Puzzle: [Plutonian Pebbles](https://adventofcode.com/2024/day/11)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day11/transform.dwl#L1-L50
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day11"><img width="300" src="images/dwplayground-button.png"></a>

## Day 12

Puzzle: [Garden Groups](https://adventofcode.com/2024/day/12)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day12/transform.dwl#L1-L84
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day12"><img width="300" src="images/dwplayground-button.png"></a>

## Day 13

Puzzle: [Claw Contraption](https://adventofcode.com/2024/day/13)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day13/transform.dwl#L1-L37
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day13"><img width="300" src="images/dwplayground-button.png"></a>

## Day 14

Puzzle: [Restroom Redoubt](https://adventofcode.com/2024/day/14)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day14/transform.dwl#L1-L53
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day14"><img width="300" src="images/dwplayground-button.png"></a>

## Day 15

Puzzle: [Warehouse Woes](https://adventofcode.com/2024/day/15)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day15/transform.dwl#L1-L77
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day15"><img width="300" src="images/dwplayground-button.png"></a>

## Day 16

Puzzle: [Reindeer Maze](https://adventofcode.com/2024/day/16)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day16/transform.dwl#L1-L140
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day16"><img width="300" src="images/dwplayground-button.png"></a>

## Day 17

Puzzle: [Chronospatial Computer](https://adventofcode.com/2024/day/17)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day17/transform.dwl#L1-L84
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day17"><img width="300" src="images/dwplayground-button.png"></a>

## Day 18

Puzzle: [RAM Run](https://adventofcode.com/2024/day/18)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day18/transform.dwl#L1-L95
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day18"><img width="300" src="images/dwplayground-button.png"></a>

## Day 19

Puzzle: [Linen Layout](https://adventofcode.com/2024/day/19)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day19/transform.dwl#L1-L50
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day19"><img width="300" src="images/dwplayground-button.png"></a>

## Day 20

Puzzle: [Race Condition](https://adventofcode.com/2024/day/20)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day20/transform.dwl#L1-L61
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day20"><img width="300" src="images/dwplayground-button.png"></a>

## Day 21

Puzzle: [Keypad Conundrum](https://adventofcode.com/2024/day/21)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day21/transform.dwl#L1-L61
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day21"><img width="300" src="images/dwplayground-button.png"></a>

## Day 22

Puzzle: [Monkey Market](https://adventofcode.com/2024/day/22)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day22/transform.dwl#L1-L59
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day22"><img width="300" src="images/dwplayground-button.png"></a>

## Day 23

Puzzle: [LAN Party](https://adventofcode.com/2024/day/23)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day23/transform.dwl#L1-L75
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day23"><img width="300" src="images/dwplayground-button.png"></a>

## Day 24

Puzzle: [Crossed Wires](https://adventofcode.com/2024/day/24)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day24/transform.dwl#L1-L68
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day24"><img width="300" src="images/dwplayground-button.png"></a>

## Day 25

Puzzle: [Code Chronicle](https://adventofcode.com/2024/day/25)

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/0d7cb6429b0a8e497b406218368bda4d32143987/day25/transform.dwl#L1-L25
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day25"><img width="300" src="images/dwplayground-button.png"></a>

## Credits

- to [Alexandra Martinez](https://github.com/alexandramartinez/adventofcode-2024) for the structure of this README.
- to [Ryan Hoegg](https://github.com/rhoegg/adventofcode2024) for creating a [private leaderboard](https://adventofcode.com/2024/leaderboard/private/view/1739830) that inspired me to solve the puzzles completely in DataWeave.
- to all the others who helped me (knowingly or unknowlingly) when I was stuck (on [Reddit](https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://www.reddit.com/r/adventofcode/) and [Slack](https://dataweavelanguage.slack.com)).