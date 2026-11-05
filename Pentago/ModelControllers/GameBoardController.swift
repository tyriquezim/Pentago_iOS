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
    
    private func updateTurns()
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
        let gridMaximumCapacity = gameBoard.gridSideLength * gameBoard.gridSideLength
        
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
    
    func rotateSubgrid(subgrid: GameBoard.Subgrid, rotationDirection: GameBoard.RotationDirection)
    {
        if(subgrid == .upperLeft)
        {
            rotateUpperLeftSubgrid(rotationDirection: rotationDirection)
        }
        else
        {
            if(subgrid == .upperRight)
            {
                rotateUpperRightSubgrid(rotationDirection: rotationDirection)
            }
            else
            {
                if(subgrid == .lowerLeft)
                {
                    rotateLowerLeftSubgrid(rotationDirection: rotationDirection)
                }
                else
                {
                    if(subgrid == .lowerRight)
                    {
                        rotateLowerRightSubgrid(rotationDirection: rotationDirection)
                    }
                }
            }
        }
        updateTurns()
    }
    
    private func rotateUpperLeftSubgrid(rotationDirection: GameBoard.RotationDirection)
    {
        let subgridSideLength = gameBoard.gridSideLength / 2
        var upperLeftSubgrid: Array<Array<Marble?>> = Array(repeating: Array(repeating: nil, count: subgridSideLength), count: subgridSideLength) //3x3 empty array
        
        //Copy contents of the upper left subgrid to this array
        for i in 0...2
        {
            for j in 0...2
            {
                upperLeftSubgrid[i][j] = gameBoard.gameGrid[i][j]
            }
        }
        
        if(rotationDirection == .clockwise)
        {
            //Top Row
            gameBoard.gameGrid[0][0] = upperLeftSubgrid[2][0]
            gameBoard.gameGrid[0][1] = upperLeftSubgrid[1][0]
            gameBoard.gameGrid[0][2] = upperLeftSubgrid[0][0]
            
            //Middle Row
            gameBoard.gameGrid[1][0] = upperLeftSubgrid[2][1]
            gameBoard.gameGrid[1][1] = upperLeftSubgrid[1][1]
            gameBoard.gameGrid[1][2] = upperLeftSubgrid[0][1]
            
            //Bottom Row
            gameBoard.gameGrid[2][0] = upperLeftSubgrid[2][2]
            gameBoard.gameGrid[2][1] = upperLeftSubgrid[1][2]
            gameBoard.gameGrid[2][2] = upperLeftSubgrid[0][2]
        }
        else
        {
            if(rotationDirection == .anticlockwise)
            {
                //Bottom Row
                gameBoard.gameGrid[2][2] = upperLeftSubgrid[2][0]
                gameBoard.gameGrid[2][1] = upperLeftSubgrid[1][0]
                gameBoard.gameGrid[2][0] = upperLeftSubgrid[0][0]
                
                //Middle Row
                gameBoard.gameGrid[1][2] = upperLeftSubgrid[2][1]
                gameBoard.gameGrid[1][1] = upperLeftSubgrid[1][1]
                gameBoard.gameGrid[1][0] = upperLeftSubgrid[0][1]
                
                //Top Row
                gameBoard.gameGrid[0][2] = upperLeftSubgrid[2][2]
                gameBoard.gameGrid[0][1] = upperLeftSubgrid[1][2]
                gameBoard.gameGrid[0][0] = upperLeftSubgrid[0][2]
            }
        }
    }
    
    private func rotateUpperRightSubgrid(rotationDirection: GameBoard.RotationDirection)
    {
        let subgridSideLength: Int = gameBoard.gridSideLength / 2
        let indexOffset: Int = subgridSideLength
        var upperRightSubgrid: Array<Array<Marble?>> = Array(repeating: Array(repeating: nil, count: subgridSideLength), count: subgridSideLength) //3x3 empty array
        
        //Copy contents of the upper left subgrid to this array
        for i in 0...2
        {
            for j in 0...2
            {
                upperRightSubgrid[i][j] = gameBoard.gameGrid[i][indexOffset + j]
            }
        }
        
        if(rotationDirection == .clockwise)
        {
            //Top Row
            gameBoard.gameGrid[0][3] = upperRightSubgrid[2][0]
            gameBoard.gameGrid[0][4] = upperRightSubgrid[1][0]
            gameBoard.gameGrid[0][5] = upperRightSubgrid[0][0]
            
            //Middle Row
            gameBoard.gameGrid[1][3] = upperRightSubgrid[2][1]
            gameBoard.gameGrid[1][4] = upperRightSubgrid[1][1]
            gameBoard.gameGrid[1][5] = upperRightSubgrid[0][1]
            
            //Bottom Row
            gameBoard.gameGrid[2][3] = upperRightSubgrid[2][2]
            gameBoard.gameGrid[2][4] = upperRightSubgrid[1][2]
            gameBoard.gameGrid[2][5] = upperRightSubgrid[0][2]
        }
        else
        {
            if(rotationDirection == .anticlockwise)
            {
                //Bottom Row
                gameBoard.gameGrid[2][5] = upperRightSubgrid[2][0]
                gameBoard.gameGrid[2][4] = upperRightSubgrid[1][0]
                gameBoard.gameGrid[2][3] = upperRightSubgrid[0][0]
                
                //Middle Row
                gameBoard.gameGrid[1][5] = upperRightSubgrid[2][1]
                gameBoard.gameGrid[1][4] = upperRightSubgrid[1][1]
                gameBoard.gameGrid[1][3] = upperRightSubgrid[0][1]
                
                //Top Row
                gameBoard.gameGrid[0][5] = upperRightSubgrid[2][2]
                gameBoard.gameGrid[0][4] = upperRightSubgrid[1][2]
                gameBoard.gameGrid[0][3] = upperRightSubgrid[0][2]
            }
        }
    }
    
    private func rotateLowerLeftSubgrid(rotationDirection: GameBoard.RotationDirection)
    {
        let subgridSideLength: Int = gameBoard.gridSideLength / 2
        let indexOffset: Int = subgridSideLength
        var lowerLeftSubgrid: Array<Array<Marble?>> = Array(repeating: Array(repeating: nil, count: subgridSideLength), count: subgridSideLength) //3x3 empty array
        
        //Copy contents of the upper left subgrid to this array
        for i in 0...2
        {
            for j in 0...2
            {
                lowerLeftSubgrid[i][j] = gameBoard.gameGrid[indexOffset + i][j]
            }
        }
        
        if(rotationDirection == .clockwise)
        {
            //Top Row
            gameBoard.gameGrid[3][0] = lowerLeftSubgrid[2][0]
            gameBoard.gameGrid[3][1] = lowerLeftSubgrid[1][0]
            gameBoard.gameGrid[3][2] = lowerLeftSubgrid[0][0]
            
            //Middle Row
            gameBoard.gameGrid[4][0] = lowerLeftSubgrid[2][1]
            gameBoard.gameGrid[4][1] = lowerLeftSubgrid[1][1]
            gameBoard.gameGrid[4][2] = lowerLeftSubgrid[0][1]
            
            //Bottom Row
            gameBoard.gameGrid[5][0] = lowerLeftSubgrid[2][2]
            gameBoard.gameGrid[5][1] = lowerLeftSubgrid[1][2]
            gameBoard.gameGrid[5][2] = lowerLeftSubgrid[0][2]
        }
        else
        {
            if(rotationDirection == .anticlockwise)
            {
                //Bottom Row
                gameBoard.gameGrid[5][2] = lowerLeftSubgrid[2][0]
                gameBoard.gameGrid[5][1] = lowerLeftSubgrid[1][0]
                gameBoard.gameGrid[5][0] = lowerLeftSubgrid[0][0]
                
                //Middle Row
                gameBoard.gameGrid[4][2] = lowerLeftSubgrid[2][1]
                gameBoard.gameGrid[4][1] = lowerLeftSubgrid[1][1]
                gameBoard.gameGrid[4][0] = lowerLeftSubgrid[0][1]
                
                //Top Row
                gameBoard.gameGrid[3][2] = lowerLeftSubgrid[2][2]
                gameBoard.gameGrid[3][1] = lowerLeftSubgrid[1][2]
                gameBoard.gameGrid[3][0] = lowerLeftSubgrid[0][2]
            }
        }
    }
    
    private func rotateLowerRightSubgrid(rotationDirection: GameBoard.RotationDirection)
    {
        let subgridSideLength: Int = gameBoard.gridSideLength / 2
        let indexOffset: Int = subgridSideLength
        var lowerRightSubgrid: Array<Array<Marble?>> = Array(repeating: Array(repeating: nil, count: subgridSideLength), count: subgridSideLength) //3x3 empty array
        
        //Copy contents of the upper left subgrid to this array
        for i in 0...2
        {
            for j in 0...2
            {
                lowerRightSubgrid[i][j] = gameBoard.gameGrid[indexOffset + i][indexOffset + j]
            }
        }
        
        if(rotationDirection == .clockwise)
        {
            //Top Row
            gameBoard.gameGrid[3][3] = lowerRightSubgrid[2][0]
            gameBoard.gameGrid[3][4] = lowerRightSubgrid[1][0]
            gameBoard.gameGrid[3][5] = lowerRightSubgrid[0][0]
            
            //Middle Row
            gameBoard.gameGrid[4][3] = lowerRightSubgrid[2][1]
            gameBoard.gameGrid[4][4] = lowerRightSubgrid[1][1]
            gameBoard.gameGrid[4][5] = lowerRightSubgrid[0][1]
            
            //Bottom Row
            gameBoard.gameGrid[5][3] = lowerRightSubgrid[2][2]
            gameBoard.gameGrid[5][4] = lowerRightSubgrid[1][2]
            gameBoard.gameGrid[5][5] = lowerRightSubgrid[0][2]
        }
        else
        {
            if(rotationDirection == .anticlockwise)
            {
                //Bottom Row
                gameBoard.gameGrid[5][5] = lowerRightSubgrid[2][0]
                gameBoard.gameGrid[5][4] = lowerRightSubgrid[1][0]
                gameBoard.gameGrid[5][3] = lowerRightSubgrid[0][0]
                
                //Middle Row
                gameBoard.gameGrid[4][5] = lowerRightSubgrid[2][1]
                gameBoard.gameGrid[4][4] = lowerRightSubgrid[1][1]
                gameBoard.gameGrid[4][3] = lowerRightSubgrid[0][1]
                
                //Top Row
                gameBoard.gameGrid[3][5] = lowerRightSubgrid[2][2]
                gameBoard.gameGrid[3][4] = lowerRightSubgrid[1][2]
                gameBoard.gameGrid[3][3] = lowerRightSubgrid[0][2]
            }
        }
    }
    
    // MARK: - AI: Public interface

    func aiPlaceMarble() throws -> (rowIndex: Int?, columnIndex: Int?)
    {
        if !gameBoard.isAgainstAiOpponent {
            throw GeneralException.IllegalState(message: "Cannot use function aiPlaceMarble. The gameBoard isAgainstAiOpponent property has been set to false.")
        }

        switch gameBoard.aiDifficulty {
        case .easy:
            return try randomAIPlacement()
        case .medium:
            return try minimaxAIPlacement(depth: 1)
        case .hard:
            return try minimaxAIPlacement(depth: 2)
        }
    }

    func aiRotateSubgrid() -> (subgrid: GameBoard.Subgrid, rotationDirection: GameBoard.RotationDirection)
    {
        // Non-easy modes pre-compute the rotation in aiPlaceMarble via findBestMove.
        if let pending = pendingAIRotation {
            pendingAIRotation = nil
            rotateSubgrid(subgrid: pending.subgrid, rotationDirection: pending.rotationDirection)
            return pending
        }

        // Easy / fallback: random rotation.
        let subgrid = GameBoard.Subgrid.random()
        let direction = GameBoard.RotationDirection.random()
        rotateSubgrid(subgrid: subgrid, rotationDirection: direction)
        return (subgrid, direction)
    }

    // MARK: - AI: Private placement helpers

    private var pendingAIRotation: (subgrid: GameBoard.Subgrid, rotationDirection: GameBoard.RotationDirection)?

    private func randomAIPlacement() throws -> (rowIndex: Int?, columnIndex: Int?)
    {
        var row = Int.random(in: 0...5)
        var col = Int.random(in: 0...5)
        var found = false
        var full = false
        var location: (rowIndex: Int?, columnIndex: Int?) = (nil, nil)

        while !found && !full {
            do {
                try placeMarble(rowIndex: row, columnIndex: col)
                location = (row, col)
                found = true
            } catch GameBoardException.GameGridFull {
                full = true
            } catch GameBoardException.CellOccupied {
                row = Int.random(in: 0...5)
                col = Int.random(in: 0...5)
            } catch {
                fatalError("Unaccounted for error thrown by placeMarble function")
            }
        }
        return location
    }

    private func minimaxAIPlacement(depth: Int) throws -> (rowIndex: Int?, columnIndex: Int?)
    {
        let grid = intGrid()
        let move = findBestMove(grid: grid, numMarbles: gameBoard.numMarbles, depth: depth)
        try placeMarble(rowIndex: move.row, columnIndex: move.col)
        pendingAIRotation = (subgrid: move.subgrid, rotationDirection: move.direction)
        return (move.row, move.col)
    }

    // MARK: - AI: Minimax engine

    // Lightweight integer grid: 1 = AI (player2), -1 = human (player1), 0 = empty.
    private typealias Grid = [[Int8]]

    // All 8 rotation choices (4 subgrids × 2 directions).
    private let allRotations: [(subgrid: GameBoard.Subgrid, clockwise: Bool)] = [
        (.upperLeft, true),  (.upperLeft, false),
        (.upperRight, true), (.upperRight, false),
        (.lowerLeft, true),  (.lowerLeft, false),
        (.lowerRight, true), (.lowerRight, false)
    ]

    private func intGrid() -> Grid
    {
        return gameBoard.gameGrid.map { row in
            row.map { marble -> Int8 in
                guard let marble = marble else { return 0 }
                return marble.marbleOwner === gameBoard.player2Profile ? 1 : -1
            }
        }
    }

    // Pure in-place rotation on a copy of grid. Clockwise: new[r][c] = old[2-c][r]. Anticlockwise: new[r][c] = old[c][2-r].
    private func rotateGrid(_ grid: Grid, subgrid: GameBoard.Subgrid, clockwise: Bool) -> Grid
    {
        var g = grid
        let (ro, co): (Int, Int)
        switch subgrid {
        case .upperLeft:  (ro, co) = (0, 0)
        case .upperRight: (ro, co) = (0, 3)
        case .lowerLeft:  (ro, co) = (3, 0)
        case .lowerRight: (ro, co) = (3, 3)
        }
        var sub = [[Int8]](repeating: [0, 0, 0], count: 3)
        for r in 0..<3 { for c in 0..<3 { sub[r][c] = g[ro + r][co + c] } }
        for r in 0..<3 {
            for c in 0..<3 {
                g[ro + r][co + c] = clockwise ? sub[2 - c][r] : sub[c][2 - r]
            }
        }
        return g
    }

    // Returns 1 if AI has 5-in-a-row, -1 if human does, 0 otherwise.
    private func winnerOnGrid(_ grid: Grid) -> Int8
    {
        let dirs: [(Int, Int)] = [(0,1),(1,0),(1,1),(1,-1)]
        for r in 0..<6 {
            for c in 0..<6 {
                for (dr, dc) in dirs {
                    let er = r + dr * 4, ec = c + dc * 4
                    guard er >= 0 && er < 6 && ec >= 0 && ec < 6 else { continue }
                    let first = grid[r][c]
                    guard first != 0 else { continue }
                    var win = true
                    for k in 1..<5 { if grid[r + dr*k][c + dc*k] != first { win = false; break } }
                    if win { return first }
                }
            }
        }
        return 0
    }

    // Score a 5-cell window for the heuristic evaluation.
    private func scoreWindow(_ cells: [Int8]) -> Int
    {
        var ai = 0, human = 0
        for v in cells { if v == 1 { ai += 1 } else if v == -1 { human += 1 } }
        if ai > 0 && human > 0 { return 0 }
        if ai > 0 {
            switch ai {
            case 5: return  10000
            case 4: return    200
            case 3: return     20
            case 2: return      5
            default: return     1
            }
        } else {
            switch human {
            case 5: return -10000
            case 4: return   -300
            case 3: return    -30
            case 2: return     -7
            default: return    -1
            }
        }
    }

    // Board heuristic: sum scores of all 32 windows of 5 on the 6×6 grid.
    private func evaluateGrid(_ grid: Grid) -> Int
    {
        var score = 0
        // Horizontal (6 rows × 2 starting columns)
        for r in 0..<6 {
            for sc in 0..<2 {
                score += scoreWindow((0..<5).map { grid[r][sc + $0] })
            }
        }
        // Vertical (2 starting rows × 6 columns)
        for sr in 0..<2 {
            for c in 0..<6 {
                score += scoreWindow((0..<5).map { grid[sr + $0][c] })
            }
        }
        // Diagonal ↘ (2×2 starting positions)
        for sr in 0..<2 {
            for sc in 0..<2 {
                score += scoreWindow((0..<5).map { grid[sr + $0][sc + $0] })
            }
        }
        // Diagonal ↙ (2×2 starting positions)
        for sr in 0..<2 {
            for sc in 4..<6 {
                score += scoreWindow((0..<5).map { grid[sr + $0][sc - $0] })
            }
        }
        return score
    }

    private func minimax(grid: Grid, numMarbles: Int, depth: Int, isMaximizing: Bool, alpha: Int, beta: Int) -> Int
    {
        var alpha = alpha
        var beta = beta
        let winner = winnerOnGrid(grid)
        if winner ==  1 { return  10000 + depth }
        if winner == -1 { return -10000 - depth }
        if numMarbles == 36 || depth == 0 { return evaluateGrid(grid) }

        let piece: Int8 = isMaximizing ? 1 : -1
        var best = isMaximizing ? Int.min : Int.max

        outerLoop: for r in 0..<6 {
            for c in 0..<6 {
                guard grid[r][c] == 0 else { continue }
                var g = grid
                g[r][c] = piece
                for (subgrid, clockwise) in allRotations {
                    let rotated = rotateGrid(g, subgrid: subgrid, clockwise: clockwise)
                    let score = minimax(grid: rotated, numMarbles: numMarbles + 1, depth: depth - 1, isMaximizing: !isMaximizing, alpha: alpha, beta: beta)
                    if isMaximizing {
                        if score > best { best = score }
                        if score > alpha { alpha = score }
                    } else {
                        if score < best { best = score }
                        if score < beta { beta = score }
                    }
                    if beta <= alpha { break outerLoop }
                }
            }
        }
        return best
    }

    private func findBestMove(grid: Grid, numMarbles: Int, depth: Int) -> (row: Int, col: Int, subgrid: GameBoard.Subgrid, direction: GameBoard.RotationDirection)
    {
        var bestScore = Int.min
        var bestRow = 0, bestCol = 0
        var bestSubgrid: GameBoard.Subgrid = .upperLeft
        var bestClockwise = true

        for r in 0..<6 {
            for c in 0..<6 {
                guard grid[r][c] == 0 else { continue }
                var g = grid
                g[r][c] = 1
                for (subgrid, clockwise) in allRotations {
                    let rotated = rotateGrid(g, subgrid: subgrid, clockwise: clockwise)
                    let score = minimax(grid: rotated, numMarbles: numMarbles + 1, depth: depth - 1, isMaximizing: false, alpha: Int.min, beta: Int.max)
                    if score > bestScore {
                        bestScore = score
                        bestRow = r; bestCol = c
                        bestSubgrid = subgrid; bestClockwise = clockwise
                    }
                }
            }
        }

        return (bestRow, bestCol, bestSubgrid, bestClockwise ? .clockwise : .anticlockwise)
    }
    
    func checkWinCondition(rowIndex: Int, columnIndex: Int) -> PlayerProfile?
    {
        var winner: PlayerProfile? = nil
        
        winner = checkHorizontal(rowIndex: rowIndex, columnIndex: columnIndex)
        
        if(winner == nil)
        {
            winner = checkVertical(rowIndex: rowIndex, columnIndex: columnIndex)
            
            if(winner == nil)
            {
                winner = checkLeadingDiagonal(rowIndex: rowIndex, columnIndex: columnIndex)
                
                if(winner == nil)
                {
                    winner = checkAntiDiagonal(rowIndex: rowIndex, columnIndex: columnIndex)
                }
            }
        }
        
        return winner
    }
    private func checkHorizontal(rowIndex: Int, columnIndex: Int) -> PlayerProfile?
    {
        //Checks for a win horizontally. Performs the check left to right
        let currentMarble = gameBoard.gameGrid[rowIndex][columnIndex] //The most recently placed marble
        var currentHorizontalMarble: Marble? = nil
        var winner: PlayerProfile? = nil
        var count: Int = 1
        var checkRowIndex = rowIndex
        var checkColumnIndex = columnIndex
        var rightDeadEnd = false
        var foundLeftmostMarble = false
        var nextLeftHorizontalMarble: Marble? = nil
        
        while(!foundLeftmostMarble)
        {
            if(checkColumnIndex != 0) //If the current marble's column number is not at the very left already. Prevents checking an index that is out of the grid's bounds
            {
                nextLeftHorizontalMarble = gameBoard.gameGrid[checkRowIndex][checkColumnIndex - 1]
                
                if(nextLeftHorizontalMarble != nil && nextLeftHorizontalMarble?.marbleOwner === currentMarble?.marbleOwner) //If the next cell is not empty and if it belongs to the current player
                {
                    checkColumnIndex -= 1
                }
                else
                {
                    foundLeftmostMarble = true
                }
            }
            else
            {
                foundLeftmostMarble = true
            }
        }
        
        //Counts the marbles from the leftmost marble in the chain belonging to the current player
        while(count < 5 && !rightDeadEnd)
        {
            if(checkColumnIndex != 5) //If it is not at the very right already
            {
                checkColumnIndex += 1
                currentHorizontalMarble = gameBoard.gameGrid[checkRowIndex][checkColumnIndex] //next marble to the right
                
                if(currentHorizontalMarble != nil && currentHorizontalMarble?.marbleOwner === currentMarble?.marbleOwner)
                {
                    count += 1
                }
                else
                {
                    rightDeadEnd = true
                }
            }
            else
            {
                rightDeadEnd = true
            }
        }
        if(count == 5)
        {
            winner = currentMarble?.marbleOwner
        }
        
        return winner
    }
    
    private func checkVertical(rowIndex: Int, columnIndex: Int) -> PlayerProfile?
    {
        //This function checks for a win vertically. It performs the check from Top to bottom
        let currentMarble = gameBoard.gameGrid[rowIndex][columnIndex]
        var currentVerticalMarble: Marble? = nil
        var winner: PlayerProfile? = nil
        var count: Int = 1
        var checkRowIndex = rowIndex
        var checkColumnIndex = columnIndex
        var bottomDeadEnd = false
        var foundTopmostMarble = false
        var nextTopVerticalMarble: Marble? = nil
        
        //Finds the topmost marble belonging to the current player
        while(!foundTopmostMarble)
        {
            if(checkRowIndex != 0) //If the current marbles column number is not at the very top already. Prevents checking an out of bounds index
            {
                nextTopVerticalMarble = gameBoard.gameGrid[checkRowIndex - 1][checkColumnIndex]
                
                if(nextTopVerticalMarble != nil && nextTopVerticalMarble?.marbleOwner === currentMarble?.marbleOwner)
                {
                    checkRowIndex -= 1
                }
                else
                {
                    foundTopmostMarble = true
                }
            }
            else
            {
                foundTopmostMarble = true
            }
        }
        
        //Counts the marbles from the topmost marble in the chain belonging to the current player
        while(count < 5 && !bottomDeadEnd)
        {
            if(checkRowIndex != 5) //If it is not at the very bottom already
            {
                checkRowIndex += 1
                currentVerticalMarble = gameBoard.gameGrid[checkRowIndex][checkColumnIndex] //the next marble one step down
                if(currentVerticalMarble != nil && currentVerticalMarble?.marbleOwner === currentMarble?.marbleOwner)
                {
                    count += 1 //Found a marble belonging to the current player next to it so count is incremented
                }
                else
                {
                    bottomDeadEnd = true
                }
            }
            else
            {
                bottomDeadEnd = true
            }
        }
        if(count == 5)
        {
            winner = currentMarble?.marbleOwner
        }
        
        return winner
    }
    
    private func checkLeadingDiagonal(rowIndex: Int, columnIndex: Int) ->PlayerProfile?
    {
        //This function checks for a win condition diagonally from the top left corner to the bottom right corner.
        let currentMarble = gameBoard.gameGrid[rowIndex][columnIndex]
        var currentDiagonalMarble: Marble? = nil
        var winner: PlayerProfile? = nil
        var count: Int = 1
        var checkRowIndex = rowIndex
        var checkColumnIndex = columnIndex
        var bottomRightDiagonalDeadEnd = false
        var foundTopLeftmostMarble = false
        var nextTopLeftDiagonalMarble: Marble? = nil
        
        //Finds the topleftmost marble belonging to the current player
        while(!foundTopLeftmostMarble)
        {
            if(checkRowIndex != 0 && checkColumnIndex != 0) //If the current marbles column number is not at the top left already (prevent IndexOutOfBounds)
            {
                nextTopLeftDiagonalMarble = gameBoard.gameGrid[checkRowIndex - 1][checkColumnIndex - 1]
                
                if(nextTopLeftDiagonalMarble != nil && nextTopLeftDiagonalMarble?.marbleOwner === currentMarble?.marbleOwner)
                {
                    checkRowIndex -= 1
                    checkColumnIndex -= 1
                }
                else
                {
                    foundTopLeftmostMarble = true
                }
            }
            else
            {
                foundTopLeftmostMarble = true
            }
        }
        
        //Counts the marbles from the topleftmost marble in the chain belonging to the current player
        while(count < 5 && !bottomRightDiagonalDeadEnd)
        {
            if(checkRowIndex != 5 && checkColumnIndex != 5) //If it is not at the top left already
            {
                checkRowIndex += 1
                checkColumnIndex += 1
                currentDiagonalMarble = gameBoard.gameGrid[checkRowIndex][checkColumnIndex] //the next marble to the bottom right
                if(currentDiagonalMarble != nil && currentDiagonalMarble?.marbleOwner === currentMarble?.marbleOwner)
                {
                    count += 1//Found a marble belonging to the current player next to it so count is incremented
                }
                else
                {
                    bottomRightDiagonalDeadEnd = true
                }
            }
            else
            {
                bottomRightDiagonalDeadEnd = true
            }
        }
        if(count == 5)
        {
            winner = currentMarble?.marbleOwner
        }
        
        return winner
    }
    
    private func checkAntiDiagonal(rowIndex: Int, columnIndex: Int) -> PlayerProfile?
    {
        //This function checks for a win condition diagonally from the top right corner to the bottom left corner.
        let currentMarble = gameBoard.gameGrid[rowIndex][columnIndex] //There SHOULD be a marble here because this function requires arguments of the recently placed marble
        var currentDiagonalMarble: Marble? = nil
        var winner: PlayerProfile? = nil
        var count: Int = 1
        var checkRowIndex = rowIndex
        var checkColumnIndex = columnIndex
        var bottomLeftDiagonalDeadEnd = false
        var foundTopRightmostMarble = false
        var nextTopRightDiagonalMarble: Marble? = nil
        
        //Finds the toprightmost marble belonging to the current player
        while(!foundTopRightmostMarble)
        {
            if(checkRowIndex != 0 && checkColumnIndex != 5) //If the current marbles column number is not at the top right already (prevent IndexOutOfBounds)
            {
                nextTopRightDiagonalMarble = gameBoard.gameGrid[checkRowIndex - 1][checkColumnIndex + 1]
                
                if(nextTopRightDiagonalMarble != nil && nextTopRightDiagonalMarble?.marbleOwner === currentMarble?.marbleOwner)
                {
                    checkRowIndex -= 1
                    checkColumnIndex += 1
                }
                else
                {
                    foundTopRightmostMarble = true
                }
            }
            else
            {
                foundTopRightmostMarble = true
            }
        }
        
        //Counts the marbles from the toprightmost marble in the chain belonging to the current player
        while(count < 5 && !bottomLeftDiagonalDeadEnd)
        {
            if(checkRowIndex != 5 && checkColumnIndex != 0) //If it is not at the bottom left already
            {
                checkRowIndex += 1
                checkColumnIndex -= 1
                currentDiagonalMarble = gameBoard.gameGrid[checkRowIndex][checkColumnIndex] //the next marble to the bottom right
                if(currentDiagonalMarble != nil && currentDiagonalMarble?.marbleOwner === currentMarble?.marbleOwner)
                {
                    count += 1 //Found a marble belonging to the current player next to it so count is incremented
                }
                else
                {
                    bottomLeftDiagonalDeadEnd = true
                }
            }
            else
            {
                bottomLeftDiagonalDeadEnd = true
            }
        }
        if(count == 5)
        {
            winner = currentMarble?.marbleOwner
        }
        
        return winner
    }
    
    func checkWinConditionPostRotation() -> PlayerProfile?
    {
        var winner: PlayerProfile? = nil
        var i = 0
        var j = 0
        
        while(i <= 5 && winner == nil)
        {
            while(j <= 5 && winner == nil)
            {
                if(gameBoard.gameGrid[i][j] != nil)
                {
                    winner = checkWinCondition(rowIndex: i, columnIndex: j)
                }
                j += 1
            }
            i += 1
            j = 0
        }
        
        return winner
    }
    
    func didDrawHappen() -> Bool
    {
        var draw = false
        var winner: PlayerProfile? = nil
        var winnerCount = 0
        var i = 0
        var j = 0
        var hasPlayer1Won = false
        var hasPlayer2Won = false
        let maximumCapacity = gameBoard.gridSideLength * gameBoard.gridSideLength
        
        while(i <= 5 && winnerCount < 2)
        {
            while(j <= 5 && winnerCount < 2)
            {
                if(gameBoard.gameGrid[i][j] != nil)
                {
                    winner = checkWinCondition(rowIndex: i, columnIndex: j)
                    
                    if(winner === gameBoard.player1Profile && !hasPlayer1Won)
                    {
                        hasPlayer1Won = true
                        winnerCount += 1
                    }
                    if(winner === gameBoard.player2Profile && !hasPlayer2Won)
                    {
                        hasPlayer2Won = true
                        winnerCount += 1
                    }
                }
                j += 1
            }
            i += 1
            j = 0
        }
        
        if(gameBoard.numMarbles == maximumCapacity && !hasPlayer1Won && !hasPlayer2Won)
        {
            draw = true
        }
        if(winnerCount > 1)
        {
            draw = true
        }
        
        return draw
    }
}
