-- File     : Proj1.hs
-- Author   : LiehTsorng Then <thenl@student.unimelb.edu.au>
-- StudentId: 900842
-- Purpose  : Play card guessing game againts a human oppenent (answerer)

-- | This code implements a card guessing game. The answerer (input) 
--   selects a combination of non-repeated cards as target to be guessed.
--   The program then outputs same number of cards as guess. If it's a 
--   wrong guess, a feedback is produced and is used  to output the next 
--   guess. This process repeats until the program outputs the correct guess. 

-- | This program works for only 2, 3 and 4-card guess and tries to achieve 
--   guessing the target with minimum number of guesses. It implements Hint 2
--   in the project spec - removing guesses with different feedbacks from the
--   feedback received using previous guess.   

module Proj1 (feedback, initialGuess, nextGuess, GameState) where

-- Card module contains types like Card, Rank, Suit to be used in this file. 
import Card
import Data.List

-- | GameState is a list of guesses (Each guess is a combination of cards).
--   It stores the possible guesses generated and list size will be pruned
--   with subsequent feedbacks by removing guess with inconsistent feedback. 
type GameState = [[Card]]

-- Constants to denote number of cards of the guess selected by the answerer
twoCard   = 2
threeCard = 3
fourCard  = 4 

------------------------------------------------------------------------------
----------------- Major functions to achieve program purpose -----------------
------------------------------------------------------------------------------

-- | This functions takes the target and a guess and output five feedback 
--   numbers as tuple. 

-- | First number  - number of correct cards in the guess. 
--   Second number - number of cards in target having lower rank than 
--                   the lowest rank in guess.
--   Third number  - number of cards in target with the same rank as a
--                   a card in guess.
--   Forth number  - number of cards in target having higher rank than
--                   the highest rank in guess. 
--   Fifth number  - number of cards in target with the same suit as a 
--                   a card in guess. 
feedback :: [Card] -> [Card] -> (Int, Int, Int, Int, Int)
feedback tar guess = (correctCards tar guess, lowerRanks tar guess, 
                      correctRanks tar guess, higherRanks tar guess,
                      correctSuits tar guess)
 
-- | Given the number of cards in target, this function outputs the first 
--   guess and a list of possible guesses generated as GameState with each 
--   guess containing the same number of cards as target. 

-- | This functions assumes the input would only be either two, three or 
--   four as specified by the project-spec. Thus, hard-coded guess is 
--   used so function would be less complex. Each hard-coded guess is
--   carefully chosen to output feedback with as much useful information
--   as possible. The idea uses Hint 4 of project spec - choose cards with 
--   different suits and with ranks about equally distant from each other.

initialGuess :: Int -> ([Card], GameState)
initialGuess num   
    | num == twoCard   = ([Card Club R5, Card Diamond R10], gameState)
    | num == threeCard = ([Card Club R5, Card Diamond R9, Card Heart King], 
                           gameState)
    | num == fourCard  = ([Card Club R4, Card Diamond R7, Card Heart R10, 
                           Card Spade King], gameState)
    where gameState = generateInitGuess num 

-- | Given previous guess, GameState and feedback, this function outputs a 
--   new guess and new GameState. For each execution of nextGuess, 
--   GameState will be smaller through filtering out guess with 
--   inconsistent feedback. 

-- | This function is going to be called repeatedly along with 'feedback'
--   until the target (correct combination) is found.   
nextGuess :: ([Card], GameState) -> (Int, Int, Int, Int, Int) -> 
             ([Card], GameState)
nextGuess (prev, gs) prevFb = (head possibleGuesses, tail possibleGuesses)
    where possibleGuesses = filter (\cur -> (feedback cur prev) == prevFb) gs

------------------------------------------------------------------------------
----------------- Utility functions used to produce feedback -----------------
------------------------------------------------------------------------------

-- Product a rank list or suit list corresponds to a card list.
getRankList :: [Card] -> [Rank]
getRankList []     = []
getRankList (x:xs) = (rank x) : (getRankList xs)

getSuitList :: [Card] -> [Suit]
getSuitList []     = []
getSuitList (x:xs) = (suit x) : (getSuitList xs)

-- Counting the number of correct cards in the guess with respect to 
-- the target. Outputs the first feedback number.
correctCards :: [Card] -> [Card] -> Int
correctCards _ []     = 0
correctCards tar (card:guess)
    | card `elem` tar = 1 + (correctCards tar guess)
    | otherwise       = correctCards tar guess

-- Counting the number of target's cards with lower rank than the lowest rank
-- in guess. Outputs the second feedback number.
lowerRanks :: [Card] -> [Card] -> Int
lowerRanks [] _                                 = 0
lowerRanks (card:tar) guess 
    | (rank card) < minimum (getRankList guess) = 1 + (lowerRanks tar guess)
    | otherwise                                 = lowerRanks tar guess

-- Counting the number of target's cards with correct rank as a card in 
-- guess. Outputs the third feedback number.
correctRanks :: [Card] -> [Card] -> Int
correctRanks tar guess = length (getRankList tar) - 
                         length ((getRankList tar) \\ (getRankList guess))

-- Counting the number of target's cards with higher rank than the 
-- highest rank in guess. Outputs the forth feedback number.
higherRanks :: [Card] -> [Card] -> Int
higherRanks [] _ = 0
higherRanks (card:tar) guess
    | (rank card) > maximum (getRankList guess) = 1 + (higherRanks tar guess)
    | otherwise                                 = higherRanks tar guess

-- Counting the number of target' cards with corret suit as a card in
-- guess. Outputs the fifth feedback number.
correctSuits :: [Card] -> [Card] -> Int
correctSuits tar guess = length (getSuitList tar) - 
                         length ((getSuitList tar) \\ (getSuitList guess))

------------------------------------------------------------------------------
---------------- Utility functions used in generating guesses ----------------
------------------------------------------------------------------------------

-- Helper function for 'initialGuess'. Given the number of cards in target,
-- the function outputs list of guesses with possibilility of being the 
-- correct guess. It uses deck of cards as generators with number of 
-- generators depending on number of cards in target. It also uses 
-- 'uniqueCards' filter to filter out built guess containg duplicate cards.

generateInitGuess :: Int -> [[Card]]
generateInitGuess num 
    | num == twoCard = [[x, y] | x <- cards, y <- cards, uniqueCards [x, y]]
    | num == threeCard = [[x, y, z] | x <- cards, y <- cards, 
                               z <- cards, uniqueCards [x, y, z]]
    | num == fourCard = [[x, y, z, w] | x <- cards, y <- cards, z <- cards, 
                                  w <- cards, uniqueCards [x, y, z, w]]
    where cards = [(Card Club R2)..(Card Spade Ace)] 

-- Check if a list of cards (guess) contains duplicates.
uniqueCards :: [Card] -> Bool
uniqueCards guess = (nub guess) == guess
