# Haskell Card Guessing Project

Haskell Card Guessing Project simulates a logical deduction game that allows user to select a combination of non-repeated cards from a standard 52-card deck as a target to be guessed by the program. If it's a wrong guess, a feedback is produced and is used to output the next guess. This process repeats until the program outputs the correct guess. 

The program works for up to 4-card guess and tries to achieve guessing the target with minimum number of guesses where the program becomes increasingly slow with guesses more than 4 cards. It implements an approach of removing guesses that outputs different feedbacks from the feedback received using previous guess.  

## Prerequisite

To run the Haskell program, you need to download the GHC compiler, Cabal and Stack tools from the official Haskell website. 

## Installation

Download the source code of the project and compile it with the command:
```
ghc -O2 --make Proj1test
```

## Usage
![](hcgp.gif)
