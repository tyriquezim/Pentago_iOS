//
//  GameBoard.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 13/12/2025.
//

class GameBoard
{
    var gameGrid: Array<Array<Marble?>>
    let gridSideLength: Int
    let player1Profile: PlayerProfile
    let player2Profile: PlayerProfile
    let isAgainstAiOpponent: Bool
    var currentTurnPlayerProfile: PlayerProfile
    var numMarbles: Int
    
    init(player1Profile: PlayerProfile, player2Profile: PlayerProfile, isAgainstAiOpponent: Bool)
    {
        self.gridSideLength = 6
        self.player1Profile = player1Profile
        self.player2Profile = player2Profile
        self.isAgainstAiOpponent = isAgainstAiOpponent
        self.currentTurnPlayerProfile = self.player1Profile
        self.numMarbles = 0
        
        self.gameGrid = Array(repeating: Array(repeating: nil, count: gridSideLength), count: gridSideLength)
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
            let randomIndex = Int.random(in: 0..<allCases.count)
            
            return allCases[randomIndex]
        }
        
        //For generating a random value from a list of cases
        static func random(caseArray: Array<Subgrid>) -> Subgrid
        {
            let randomIndex = Int.random(in: 0..<caseArray.count)
            
            return caseArray[randomIndex]
        }
    }
    
    enum RotationDirection: CaseIterable
    {
        case clockwise
        case anticlockwise
        
        static func random() -> RotationDirection
        {
            let randomIndex = Int.random(in: 0..<allCases.count)
            
            return allCases[randomIndex]
        }
        
        static func random(caseArray: Array<RotationDirection>) -> RotationDirection
        {
            let randomIndex = Int.random(in: 0..<caseArray.count)
            
            return caseArray[randomIndex]
        }
    }
}
