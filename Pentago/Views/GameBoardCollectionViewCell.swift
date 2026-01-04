//
//  GameBoardCollectionViewCell.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 3/1/2026.
//

import UIKit

class GameBoardCollectionViewCell: UICollectionViewCell
{
    @IBOutlet var cellImageView: UIImageView!
    
    var initialCellType: CellType!
    var currentCellType: CellType!
    var gameBoardRowIndex: Int!
    var gameBoardColumnIndex: Int!
    
    //Must be called after every rotation
    func updateGameBoardIndices(rotationDirection: GameBoard.RotationDirection)
    {
        switch rotationDirection
        {
            case .clockwise:
                switch self.currentCellType
                {
                    case .topLeftCell:
                        self.gameBoardRowIndex += 0
                        self.gameBoardColumnIndex += 2
                        self.currentCellType = .topRightCell
                    case .topMiddleCell:
                        self.gameBoardRowIndex += 1
                        self.gameBoardColumnIndex += 1
                        self.currentCellType = .middleRightCell
                    case .topRightCell:
                        self.gameBoardRowIndex += 2
                        self.gameBoardColumnIndex += 0
                        self.currentCellType = .bottomRightCell
                    case .middleLeftCell:
                        self.gameBoardRowIndex -= 1
                        self.gameBoardColumnIndex += 1
                        self.currentCellType = .topMiddleCell
                    case .middleMiddleCell:
                        self.gameBoardRowIndex += 0
                        self.gameBoardColumnIndex += 0
                        self.currentCellType = .middleMiddleCell
                    case .middleRightCell:
                        self.gameBoardRowIndex += 1
                        self.gameBoardColumnIndex -= 1
                        self.currentCellType = .bottomMiddleCell
                    case .bottomLeftCell:
                        self.gameBoardRowIndex -= 2
                        self.gameBoardColumnIndex += 0
                        self.currentCellType = .topLeftCell
                    case .bottomMiddleCell:
                        self.gameBoardRowIndex -= 1
                        self.gameBoardColumnIndex -= 1
                        self.currentCellType = .middleLeftCell
                    case .bottomRightCell:
                        self.gameBoardRowIndex += 0
                        self.gameBoardColumnIndex -= 2
                        self.currentCellType = .bottomLeftCell
                    default:
                        fatalError("Unnaccounted for CellType")
                }
            case .anticlockwise:
                switch self.currentCellType
                {
                    case .topLeftCell:
                    self.gameBoardRowIndex += 2
                    self.gameBoardColumnIndex += 0
                    self.currentCellType = .bottomLeftCell
                case .topMiddleCell:
                    self.gameBoardRowIndex += 1
                    self.gameBoardColumnIndex -= 1
                    self.currentCellType = .middleLeftCell
                case .topRightCell:
                    self.gameBoardRowIndex += 0
                    self.gameBoardColumnIndex -= 2
                    self.currentCellType = .topLeftCell
                case .middleLeftCell:
                    self.gameBoardRowIndex += 1
                    self.gameBoardColumnIndex += 1
                    self.currentCellType = .bottomMiddleCell
                case .middleMiddleCell:
                    self.gameBoardRowIndex += 0
                    self.gameBoardColumnIndex += 0
                    self.currentCellType = .middleMiddleCell
                case .middleRightCell:
                    self.gameBoardRowIndex -= 1
                    self.gameBoardColumnIndex -= 1
                    self.currentCellType = .topMiddleCell
                case .bottomLeftCell:
                    self.gameBoardRowIndex += 0
                    self.gameBoardColumnIndex += 2
                    self.currentCellType = .bottomRightCell
                case .bottomMiddleCell:
                    self.gameBoardRowIndex -= 1
                    self.gameBoardColumnIndex += 1
                    self.currentCellType = .middleRightCell
                case .bottomRightCell:
                    self.gameBoardRowIndex -= 2
                    self.gameBoardColumnIndex += 0
                    self.currentCellType = .topRightCell
                default:
                    fatalError("Unnaccounted for CellType")
            }
        }
    }
    
    enum CellType
    {
        //first word is row location second word is column location. EG topMiddleCell is the fist row and second column of a subgrid
        case topLeftCell
        case topMiddleCell
        case topRightCell
        case middleLeftCell
        case middleMiddleCell
        case middleRightCell
        case bottomLeftCell
        case bottomMiddleCell
        case bottomRightCell
    }
}
