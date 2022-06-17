# 8-Puzzle AI Solution

## Aim

The aim is to understand how the search strategies work, in particular the A*-search strategy.

## The 8-Puzzle

The 8-puzzle will be solved using two simple heuristics h1 and h2 defined below.

* h1 = the number of misplaced tiles; the number of squares that are not in the right place. The space is not a tile, so it cannot be out of place
* h2 = the Manhattan distance

### ***Task A***

Implement the A*-search algorithm for the 8-puzzle that uses the heuristic h1. Explain the data structure
that you used when you present your solution to the lab assistant. It is important that you choose a good data
structure for an efficient solution. Your program has to find a solution within **60 seconds**.

### ***Task A***

Extend your program by implementing the heuristic h2
