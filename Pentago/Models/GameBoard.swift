//
//  GameBoard.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 13/12/2025.
//

class GameBoard
{
    var gameGrid: Array<Array<Marble?>>
    let player1Profile: PlayerProfile
    let player2Profile: PlayerProfile
    let isAgainstAiOpponent: Bool
    var currentTurnPlayerProfile: PlayerProfile
    var numMarbles: Int
    
    init(player1Profile: PlayerProfile, player2Profile: PlayerProfile, isAgainstAiOpponent: Bool)
    {
        self.player1Profile = player1Profile
        self.player2Profile = player2Profile
        self.isAgainstAiOpponent = isAgainstAiOpponent
        self.currentTurnPlayerProfile = self.player1Profile
        self.numMarbles = 0
        
        self.gameGrid = Array<Array<Marble?>>()
        
        //Creating a 6x6 array initialised to nil
        for i in 0...5
        {
            let newBoardColumn: Array<Marble?> = Array(repeating: nil, count: 6)
            
            self.gameGrid.append(newBoardColumn)
        }
    }
    
    enum Subgrid: CaseIterable
    {
        case upperLeft
        case upperRight
        case lowerLeft
        case lowerRight
        
        //For generating a random value from all available cases
        static func random() -> Subgrid
        {
            var randomIndex = Int.random(in: 0..<allCases.count)
            
            return allCases[randomIndex]
        }
        
        //For generating a random value from a list of cases
        static func random(caseArray: Array<Subgrid>) -> Subgrid
        {
            var randomIndex = Int.random(in: 0..<caseArray.count)
            
            return caseArray[randomIndex]
        }
    }
    
    enum RotationDirection: CaseIterable
    {
        case clockwise
        case anticlockwise
        
        static func random() -> RotationDirection
        {
            var randomIndex = Int.random(in: 0..<allCases.count)
            
            return allCases[randomIndex]
        }
        
        static func random(caseArray: Array<RotationDirection>) -> RotationDirection
        {
            var randomIndex = Int.random(in: 0..<caseArray.count)
            
            return caseArray[randomIndex]
        }
    }
}
