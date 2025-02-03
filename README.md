# Advent of Code 2024

My solutions for [Advent of Code 2024](https://adventofcode.com/2024/) written in DataWeave.

## Day 1

Puzzle: [Historian Hysteria](https://adventofcode.com/2024/day/1)

The first thing I learned was that using the function `dw::core::Strings::lines` to read files, the script will be platform-independent - working on Windows, MacOS and Linux - as it takes into account the platform-specific line endings. Also, I didn't know [`then`](https://docs.mulesoft.com/dataweave/latest/dw-core-functions-then) yet, so I used `reduce $$ + $` to sum the lists (instead of `then sum($)`).

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day01/transform.dwl#L1-L17
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day01"><img width="300" src="images/dwplayground-button.png"></a>

## Day 2

Puzzle: [Red-Nosed Reports](https://adventofcode.com/2024/day/2)

Working on day 2 I started to notice that the type system in DataWeave sometimes requires a little nudge by casting. E.g., mapping a range like `(1 to 2) map $` gives you a warning, casting it to an array (`(1 to 2) as Array map $`) removes the warning.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day02/transform.dwl#L1-L28
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day02"><img width="300" src="images/dwplayground-button.png"></a>

## Day 3

Puzzle: [Mull It Over](https://adventofcode.com/2024/day/3)

For this pattern matching exercise I decided to use `find` to return all occurences of any of the relevant patterns. Looking at it from hightsight, it might have been easier to look at larger patterns that already take into account the context (do and don't). And, there might be an easier solution with `scan`.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day03/transform.dwl#L1-L43
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day03"><img width="300" src="images/dwplayground-button.png"></a>

## Day 4

Puzzle: [Ceres Search](https://adventofcode.com/2024/day/4)

Another pattern matching exercise, this time in 2D. While part one still uses `find`(the tool that proved helpful for day 3) after laying out all rows, columns and diogonals, part two involves some manual pattern matching, starting from all A's and checking for M's and S's around.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day04/transform.dwl#L1-L37
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day04"><img width="300" src="images/dwplayground-button.png"></a>

## Day 5

Puzzle: [Print Queue](https://adventofcode.com/2024/day/5)

Here you can see some more mollifying casting/defaulting in action - the compiler doesn't note that there cannot be any null value after an `filter isEmpty($)` and complains. And part 2 brings the first recursive solution, fixing the order of the printed pages one by one.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day05/transform.dwl#L1-L41
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day05"><img width="300" src="images/dwplayground-button.png"></a>

## Day 6

Puzzle: [Guard Gallivant](https://adventofcode.com/2024/day/6)

Day 6 brought the first 2D puzzle, many more to come. The most important thing I learned on that day was about recursion. If you just create a recursive function, it will most likely fail with a stack overflow after 256 recursions. However, the DataWeave compiler will be able to optimize the recursion if you create the function as tail-recursive, i.e., the recursive call has to be the last operation in the function. In order to check if the function fullfils this condition, you can use the `@TailRec()` annotation, which will create an error if the function is not tail-recursive.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day06/transform.dwl#L1-L116
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day06"><img width="300" src="images/dwplayground-button.png"></a>

## Day 7

Puzzle: [Bridge Repair](https://adventofcode.com/2024/day/7)

In order to enumerate all the possible solutions for the given equations, I use binary numbers (or ternary numbers for part 2), where each digit represents an operation (0 &rarr; "+", 1 &rarr; "*", 2 &rarr; "||"). While binary is natively supported by DataWeave, I had to add my own implementation for a conversion from decimal to ternary.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day07/transform.dwl#L1-L38
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day07"><img width="300" src="images/dwplayground-button.png"></a>

## Day 8

Puzzle: [Resonant Collinearity](https://adventofcode.com/2024/day/8)

Again some kind of 2D puzzle, where it is extremely helpful to have a function for printing the map for debugging purposes. `printMap(antinodes: Array<Position>): Array<String>` does exactly this. It's not required to caculate the solution, still I decided to keep it in the sources.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day08/transform.dwl#L1-L57
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day08"><img width="300" src="images/dwplayground-button.png"></a>

## Day 9

Puzzle: [Disk Fragmenter](https://adventofcode.com/2024/day/9)

For recursive solutions that use a large amount of state, DataWeave seems not to be the best suited. In part 2, the `reduce` (which is in fact a recursive function), modifies a 10 kB payload (the disk map) again and again, which takes quite some time to finish (~10 min on my machine, to be precise). Let me know if you found a more performant way to solve this in DataWeave.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day09/transform.dwl#L1-L67
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day09"><img width="300" src="images/dwplayground-button.png"></a>

## Day 10

Puzzle: [Hoof It](https://adventofcode.com/2024/day/10)

This time, I have two solutions for part 1: the initial one designed to solve exactly this part and the solution for part 2, which is also usable for part 1. That happens if you don't know what comes next ... I still decided to keep them both in the sources. Part 1 focuses on finding the reachable points, while part 2 keeps track of the different paths. Given that only the second solution is required, this is one of the four shortest solutions of all 25 days, with just 31 lines (including blank lines).

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day10/transform.dwl#L1-L46
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day10"><img width="300" src="images/dwplayground-button.png"></a>

## Day 11

Puzzle: [Plutonian Pebbles](https://adventofcode.com/2024/day/11)

While the straight-forward solution for part 1 was quite easy, the same solution would have taken ~74 years to finish for part 2, according to my forecast. That gave me enough time to work out an improved solution that was fast enough for part 2. And it turned out that a very small tweak improved the runtime to ~2 min. The idea is to not look at each stone separately, but count them and multiply the result (as the order of the stones is not important).

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day11/transform.dwl#L1-L50
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day11"><img width="300" src="images/dwplayground-button.png"></a>

## Day 12

Puzzle: [Garden Groups](https://adventofcode.com/2024/day/12)

The next 2D puzzle. The difficulty was how to identify the regions. My solutions goes through all plants and recursively adds them to regions (using `reduce`). As I am moving from top right in reading order, only left and upper neighbors have to be checked (if they have the same plant type and thus belong to the same region). Parts 1 and 2 then only differ in how the fences/sides are counted for the different regions.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day12/transform.dwl#L1-L84
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day12"><img width="300" src="images/dwplayground-button.png"></a>

## Day 13

Puzzle: [Claw Contraption](https://adventofcode.com/2024/day/13)

This puzzle was probably created to mislead into simulating the claws. In fact, you just have to solve a simple equation system with two variables. So the portion of the script responsible for parsing the input is almost the biggest part of the whole solution.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day13/transform.dwl#L1-L37
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day13"><img width="300" src="images/dwplayground-button.png"></a>

## Day 14

Puzzle: [Restroom Redoubt](https://adventofcode.com/2024/day/14)

The simulation of these robots does not require a step-wise round-based approach, it is possible to directly calculate their final position. So part 1 is quite easy. Part 2 is a bit more difficult if you want to automatically find the easter egg in the display. It is indeed possible to do this without visual identification by calculating the entropy of the resulting picture (I actually calculated the average entropy of the lines). When it drops, i.e., when there is less chaos, we have found the picture. An additional performance improvement was to not search each and every iteration, but restrict the search to the frames that looked promising: every 101st frame shows some suspicious arrangement of robots.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day14/transform.dwl#L1-L68
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day14"><img width="300" src="images/dwplayground-button.png"></a>

## Day 15

Puzzle: [Warehouse Woes](https://adventofcode.com/2024/day/15)

This 2D puzzle is almost a small game in DataWeave. If you load it into the playground, you can use the "<", ">", "^", "v" keys to add instructions to the input for the robot to move around in the warehouse and see the result on the right side in the output - if you change the body of the script to `moves reduce ((direction, warehouse = warehouse) -> move(warehouse, direction))`. This will parse the moves from the input and recursivly appy them to the warehouse map.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day15/transform.dwl#L1-L77
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day15"><img width="300" src="images/dwplayground-button.png"></a>

## Day 16

Puzzle: [Reindeer Maze](https://adventofcode.com/2024/day/16)

Day 16 was the most challenging puzzle for me. After trying a depth-first search first, I decided to switch to [A*](https://en.wikipedia.org/wiki/A*_search_algorithm) for finding the shortes path through the maze. The difficult part is the specific metric, which adds a penalty for changing direction. The heuristic function of A* needs to take this into account, otherwise, the algorithm won't find the shortest path. Part 2 adds another challenge, as equivalent paths can only be identified tracing back the path from the end node (on the way from start to end, you won't know which direction will be taken in the next step, so you cannot identify equal paths yet). I've read some nice ideas that this could be overcome by modelling the maze as a 3D graph, using the directions as third dimension. If you like to play around with my solution, you can use the Logger module I created for printing the maze. It produces output like the following (`O` denoting the nodes on one of the shortes paths, `x` showing the visited nodes and `o` showing nodes on the open list):
```
      "###############",
      "#xxxxxxx#....E#",
      "#x#x###o#.###O#",
      "#xxxxx#.#.ox#O#",
      "#x###o#####x#O#",
      "#x#x#xxxxxxx#O#",
      "#x#x#####x###O#",
      "#xxOOOOOOOOO#O#",
      "###O#O#####O#O#",
      "#OOO#Oxxxx#O#O#",
      "#O#O#O###x#O#O#",
      "#OOOOO#xxx#O#O#",
      "#O###x#x#x#O#O#",
      "#Sxx#xxxxx#OOO#",
      "###############"
```

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day16/transform.dwl#L1-L140
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day16"><img width="300" src="images/dwplayground-button.png"></a>

## Day 17

Puzzle: [Chronospatial Computer](https://adventofcode.com/2024/day/17)

The simulation of the computer consists of a state (program, registers, output, instruction pointer) and an execute function that modifies this state recursively while running through the program. Part 1 lays the foundation by implementing the simulation, while part 2 represents the real puzzle. For this, I realized that the search can be done more efficiently, just looking at the suffix of the output and trying to grow if from right to left. Also, as we are working with octal numbers, it seems that the target value of a can be grown from left to right using octal numbers. In other words, the first digit of the input A determines the last part of the output, the second digit the part before and so on. Using this observation, the solution can be found in reasonable time. For the logging, I introduced an instruction logger that can easily be switch on and off by adjusting the function `ilog()` to either call the DataWeave `log()` or just return the value without logging.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day17/transform.dwl#L1-L86
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day17"><img width="300" src="images/dwplayground-button.png"></a>

## Day 18

Puzzle: [RAM Run](https://adventofcode.com/2024/day/18)

For this 2D puzzle, I was able to reuse my A* implementation of day 16 and use it successfully before I even managed to solve day 16. That gave me some confidence that my implementation is basically correct and I just needed some more fine-tuning to solve day 16. For part 2, I used a binary search to find the constellation where no path can be found anymore and to identify the block that eventually cuts off the path.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day18/transform.dwl#L1-L95
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day18"><img width="300" src="images/dwplayground-button.png"></a>

## Day 19

Puzzle: [Linen Layout](https://adventofcode.com/2024/day/19)

Similar to the puzzle of day 11, it is only possible to solve this by aggregating the results while recursing over them. Otherwise, you will end up with incredibly long execution times.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day19/transform.dwl#L1-L50
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day19"><img width="300" src="images/dwplayground-button.png"></a>

## Day 20

Puzzle: [Race Condition](https://adventofcode.com/2024/day/20)

In this 2D puzzle, there is only one path from source to destination. In order to find the cheats, I prepare the track as an array of nodes and a map with the remaining distances. Then I walk along the track, at each node looking at all other nodes in range to check if there is another track node with a smaller remaining distance (including the distance to that node, of course). My linked solution prints the map of cheats, in order to get the requested result for the puzzle, you will have to comment in the sum and suitable filter values.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day20/transform.dwl#L1-L61
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day20"><img width="300" src="images/dwplayground-button.png"></a>

## Day 21

Puzzle: [Keypad Conundrum](https://adventofcode.com/2024/day/21)

There are two aspects that are worth mentioning for the solution of this puzzle: First, the order of the executed moves is important. See lines 41 to 48, which decide whether to start with horizontal or vertical moves - depending on the previous and next button -, in order to avoid moving over the blank space. And second, the solution for part 2, which is basically the same as for part 1 - just with added caching. Caching is inevitable here, and it is not that straightforward to implement in functional programming. As variables are immutable, we have to hand over the complete cache along with the current result from one function call to the next. Note that this recursive implementation is not tail recursive, which is ok as we only need 25 recursions.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day21/transform.dwl#L1-L96
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day21"><img width="300" src="images/dwplayground-button.png"></a>

## Day 22

Puzzle: [Monkey Market](https://adventofcode.com/2024/day/22)

For day 22, I gave up to find a performant solution in DataWeave. Part 1 can be improved a lot by implementing `mix()` and `prune()` (which is basically a simple random number generator) in Java. You would have to run it in Mule then as the DataWeave CLI does not support importing custom Java libraries. That's why I kept the calculation in DataWeave. For part 2, I could not find an optimization that would speed up the soltution, and it runs for ~21 hours on my machine. I assume, it is the memory handling of the recursive reduce, which becomes extremly slow after some recursions. If you have any idea how to decrease the execution time, please let me know!

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day22/transform.dwl#L1-L59
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day22"><img width="300" src="images/dwplayground-button.png"></a>

## Day 23

Puzzle: [LAN Party](https://adventofcode.com/2024/day/23)

While part 1 can be solved straight-forward with some plucking and mapping, part 2 is the NP-complete [maximum clique problem](https://en.wikipedia.org/wiki/Clique_(graph_theory)). So I looked for an algorithm that solves it and ended up in using this [recursive solution](https://www.geeksforgeeks.org/maximal-clique-problem-recursive-solution/) as a blueprint. I "just" had to translate it to a functional implementation.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day23/transform.dwl#L1-L74
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day23"><img width="300" src="images/dwplayground-button.png"></a>

## Day 24

Puzzle: [Crossed Wires](https://adventofcode.com/2024/day/24)

Again a puzzle with a really easy part 1 and a part 2 that requires some thinking about the best approach. At first, I thought, I would need a complete enumeration of all wires, cross them systematically and check where the result fits - but there are too many. Then, I tried to systematically add numbers (2^0 + 2^0, 2^1 + 2^1, ...) to see where it fails. This gives a hint on where some wires are crossed, but not the exact wire. Finally, I realized that it is in fact a [ripple-carry adder](https://en.wikipedia.org/wiki/Adder_(electronics)#Ripple-carry_adder), so my solution is to follow the wires from the result bits towards the source and check where I find a wrong operation.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day24/transform.dwl#L1-L68
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day24"><img width="300" src="images/dwplayground-button.png"></a>

## Day 25

Puzzle: [Code Chronicle](https://adventofcode.com/2024/day/25)

And finally, an easy one for day 25. There is only one part, the second star is automatically awarded if you have solved all previous puzzles.

<details>
  <summary>Solution</summary>
  https://github.com/mtransier/AdventOfCode2024/blob/d18b0ac7c47aace27a43ce7aedaaaf77fb759dda/day25/transform.dwl#L1-L25
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=mtransier%2FAdventOfCode2024&path=day25"><img width="300" src="images/dwplayground-button.png"></a>

## Credits

- to [Alexandra Martinez](https://github.com/alexandramartinez/adventofcode-2024) for the structure of this README.
- to [Ryan Hoegg](https://github.com/rhoegg/adventofcode2024) for creating a [private leaderboard](https://adventofcode.com/2024/leaderboard/private/view/1739830) that inspired me to solve the puzzles completely in DataWeave.
- to all the others who helped me (knowingly or unknowlingly) when I was stuck (on [Reddit](https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://www.reddit.com/r/adventofcode/) and [Slack](https://dataweavelanguage.slack.com)).
