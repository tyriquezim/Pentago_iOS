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
