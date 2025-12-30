//
//  GameBoardController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 13/12/2025.
//

class GameBoardController
{
    var gameBoard: GameBoard
    
    init(gameBoard: GameBoard)
    {
        self.gameBoard = gameBoard
    }
    
    func updateTurns()
    {
        if(self.gameBoard.currentTurnPlayerProfile === self.gameBoard.player1Profile)
        {
            self.gameBoard.currentTurnPlayerProfile = self.gameBoard.player2Profile
        }
        else
        {
            if(self.gameBoard.currentTurnPlayerProfile === self.gameBoard.player2Profile)
            {
                self.gameBoard.currentTurnPlayerProfile = self.gameBoard.player1Profile
            }
        }
    }
    
    func placeMarble(rowIndex: Int, columnIndex: Int) throws
    {
        let newMarble =  Marble(marbleOwner: self.gameBoard.currentTurnPlayerProfile, marbleColour: self.gameBoard.currentTurnPlayerProfile.marbleColour)
        let gridMaximumCapacity = gameBoard.gameGrid.count * gameBoard.gameGrid[0].count
        
        if(rowIndex < 0 || rowIndex > 5)
        {
            throw GeneralException.IllegalArgument(message: "Illegal move! A marble can only be placed in a row with an index between 0 and 5 inclusive. Passed position -> Row Index: \(rowIndex), Column Index: \(columnIndex)")
        }
        if(columnIndex < 0 || columnIndex > 5)
        {
            throw GeneralException.IllegalArgument(message: "Illegal move! A marble can only be placed in a column with an index between 0 and 5 inclusive. Passed position -> Row Index: \(rowIndex), Column Index: \(columnIndex)")
        }
        
        if(gameBoard.numMarbles == gridMaximumCapacity)
        {
            throw GameBoardException.GameGridFull(message: "Cannot place marble. The grid is full.")
        }
        
        if(gameBoard.gameGrid[rowIndex][columnIndex] != nil)
        {
            throw GameBoardException.CellOccupied(message: "Cannot place marble in position \(rowIndex), \(columnIndex). There is already a marble in that position.")
        }
        else
        {
            gameBoard.gameGrid[rowIndex][columnIndex] = newMarble
        }
        gameBoard.numMarbles += 1
    }
    
    func aiPlaceMarble() throws -> (Int?, Int?)
    {
        var rowIndex: Int = Int.random(in: 0...5)
        var columnIndex: Int = Int.random(in: 0...5)
        var hasCellBeenFound: Bool = false
        var isBoardFull: Bool = false
        var marbleLocation: (rowIndex: Int?, columnIndex: Int?) = (nil, nil)
        
        if(!gameBoard.isAgainstAiOpponent)
        {
            throw GeneralException.IllegalState(message: "Cannot use function aiPlaceMarble. The gameBoard isAgainstAiOpponent property has been set to false.")
        }
        
        while(!hasCellBeenFound && !isBoardFull)
        {
            do
            {
                try placeMarble(rowIndex: rowIndex, columnIndex: columnIndex)
                marbleLocation.rowIndex = rowIndex
                marbleLocation.columnIndex = columnIndex
                hasCellBeenFound = true
            }
            catch GameBoardException.GameGridFull
            {
                isBoardFull = true
            }
            catch GameBoardException.CellOccupied
            {
                rowIndex = Int.random(in: 0...5)
                columnIndex = Int.random(in: 0...5)
            }
            catch
            {
                fatalError("Unaccounted for error thrown by placeMarble function")
            }
        }
        return marbleLocation
    }
    
    func aiRotateSubgrid() -> (GameBoard.Subgrid, GameBoard.RotationDirection)
    {
        var subgrid: GameBoard.Subgrid = .random()
        var rotationDirection: GameBoard.RotationDirection = .random()
        var subgridRotationInfo: (selectedSubgrid: GameBoard.Subgrid, selectedRotationDirection: GameBoard.RotationDirection) = (subgrid, rotationDirection)
        
        if(rotationDirection == .clockwise)
        {
            if(subgrid == .upperLeft)
            {
                
            }
            else
            {
                
            }
        }
        
        
    }
}
