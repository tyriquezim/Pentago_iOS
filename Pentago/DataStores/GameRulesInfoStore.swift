//
//  GameRulesInfoStore.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 1/1/2026.
//

struct GameRulesInfoStore
{
    var gameDescription: String
    var gameRulesArray: Array<(ruleTitle: RuleTitle, ruleDescription: String)>
    
    init()
    {
        self.gameDescription = "Pentago is a board game in which two players place marbles on any one of four 3x3 grids on a board. In order to win, a player must have five of their own marbles aligned vertically, horizontally or diagonally across the four grids. After each marble placement, the player must rotate any one of the four grids either clockwise or anti-clockwise, adding an additional layer of strategy in comparison to similar games like Connect Four."
        
        self.gameRulesArray = Array()
        
        var rule1 = (RuleTitle.orderOfActions, "A player's turn consists of placing a marble on the game board and then rotating a subgrid (exception being in the case described by rule 3).")
        var rule2 = (RuleTitle.howToWin, "The game is won when a player manages to align five of their own marbles vertically, horizontally or diagonally.")
        var rule3 = (RuleTitle.exceptionToRotating, "If a player places a marble and it results in an alignment of five for themselves, they are not required to rotate a grid and thus become the winner of the match.")
        var rule4 = (RuleTitle.fullBoardDraw, "A game results in a draw if the entire board gets filled without any of the players managing to align five of their marbles in a row.")
        var rule5 = (RuleTitle.doubleWinDraw, "A game also results in a draw if, after a rotation, both players obtain an alignment of five of their own marbles simultaneously.")
        
        self.gameRulesArray.append(rule1)
        self.gameRulesArray.append(rule2)
        self.gameRulesArray.append(rule3)
        self.gameRulesArray.append(rule4)
        self.gameRulesArray.append(rule5)
    }
    
    enum RuleTitle: String
    {
        case orderOfActions = "Order of Actions"
        case howToWin = "How to Win"
        case exceptionToRotating = "Exception to Rotating"
        case fullBoardDraw = "Full Board Draw"
        case doubleWinDraw = "Double Win Draw"
    }
}
