# OOPRuby
# http://www.theodinproject.com/ruby-programming/oop?ref=lnav

# TicTacToe -- 
####Played with two players, both use command line input to get moves.

# Mastermind -- 
####You can play either as the codebreaker or codemaker. As a codebreaker, you have 12 guesses to correctly guess a random combination of four colors.
#### As a codemaker, you create a code and have the computer try to guess it. AI uses a dumbed-down version of Knuth's five guess algorithm. 
#### My implementation takes the initial set of 1296 possible moves, and reduces the set by comparing all remaining possible moves against the current guess, eliminating all moves that don't do as well as that guess.
#### Then makes a guess with the remaining set.
