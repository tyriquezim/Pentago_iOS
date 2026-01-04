//
//  StoryBoardGameBoardViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 2/1/2026.
//

import UIKit

class GameBoardViewController: UIViewController
{
    @IBOutlet var player1ImageView: UIImageView!
    @IBOutlet var player2ImageView: UIImageView!
    @IBOutlet var player1UsernameLabel: UILabel!
    @IBOutlet var player2UsernameLabel: UILabel!
    @IBOutlet var playerTurnLabel: UILabel!
    @IBOutlet var gameStatusLabel: UILabel!
    @IBOutlet var rotationStackView: UIStackView!
    @IBOutlet var clockwiseImageView: UIImageView!
    @IBOutlet var anticlockwiseImageView: UIImageView!
    @IBOutlet var upperLeftSubgrid: UICollectionView!
    @IBOutlet var upperRightSubgrid: UICollectionView!
    @IBOutlet var lowerLeftSubgrid: UICollectionView!
    @IBOutlet var lowerRightSubgrid: UICollectionView!
    
    var gameController: GameBoardController!
    var gamePhase: GamePhase!
    var selectedSubgridCollectionView: UICollectionView? //The grid that is to be rotated
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.upperLeftSubgrid.dataSource = self
        self.upperRightSubgrid.dataSource = self
        self.lowerLeftSubgrid.dataSource = self
        self.lowerRightSubgrid.dataSource = self
        
        self.upperLeftSubgrid.delegate = self
        self.upperRightSubgrid.delegate = self
        self.lowerLeftSubgrid.delegate = self
        self.lowerRightSubgrid.delegate = self
        
        self.upperLeftSubgrid.isScrollEnabled = true
        self.upperRightSubgrid.isScrollEnabled = false
        self.lowerLeftSubgrid.isScrollEnabled = false
        self.lowerRightSubgrid.isScrollEnabled = false
        
        self.selectedSubgridCollectionView = nil
        
        self.gamePhase = .placeMarble
        self.rotationStackView.isHidden = true
        self.gameStatusLabel.text = GameStateInfoStore.placeMarbleInstruction.rawValue
        self.playerTurnLabel.text = self.gameController.gameBoard.currentTurnPlayerProfile.userName + GameStateInfoStore.playerTurnTrailing.rawValue
        
        self.player1ImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: self.gameController.gameBoard.player1Profile.profilePicture)
        self.player2ImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: self.gameController.gameBoard.player2Profile.profilePicture)
        self.player1UsernameLabel.text = self.gameController.gameBoard.player1Profile.userName
        self.player2UsernameLabel.text = self.gameController.gameBoard.player2Profile.userName
        
        anticlockwiseImageView.transform = CGAffineTransform(scaleX: -1, y: 1) //Mirrors the image view so the arrow is pointing in the other direction
        self.anticlockwiseImageView.isUserInteractionEnabled = true
        self.clockwiseImageView.isUserInteractionEnabled = true
    }
}

extension GameBoardViewController: UICollectionViewDelegate
{
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool
    {
        var shouldBeSelected: Bool = true
        
        if(gamePhase == .animationOccuring || gamePhase == .aiTurn) //Stops the user making moves while an animation is occuring or when it is the AI's turn
        {
            shouldBeSelected = false
        }
        
        return shouldBeSelected
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt index: IndexPath)
    {
        var cell = collectionView.cellForItem(at: index) as! GameBoardCollectionViewCell
        
        if(gamePhase == .placeMarble)
        {
            do
            {
                try self.gameController.placeMarble(rowIndex: cell.gameBoardRowIndex, columnIndex: cell.gameBoardColumnIndex)
                cell.cellImageView.image = ImageAssetFactory.getGameBoardCellUIImage(cellType: cell.initialCellType, colour: self.gameController.gameBoard.currentTurnPlayerProfile.marbleColour)
                
                self.gamePhase = .rotateSubgid
                self.gameStatusLabel.text = GameStateInfoStore.subgridSelectInstruction.rawValue
            }
            catch let GeneralException.IllegalArgument(message)
            {
                fatalError(message)
            }
            catch let GameBoardException.CellOccupied(message)
            {
                //Notify the user
            }
            catch let GameBoardException.GameGridFull(message)
            {
                //notify the user
            }
            catch
            {
                fatalError("An unaccounted for error was thrown by the placeMarble function")
            }
        }
        else
        {
            if(gamePhase == .rotateSubgid)
            {
                let subgrids = [self.upperLeftSubgrid!, self.upperRightSubgrid!, self.lowerLeftSubgrid!, self.lowerRightSubgrid!]
                
                for subgrid in subgrids //Unhighlights any highlighted colletion views
                {
                    if(subgrid.clipsToBounds)
                    {
                        subgrid.layer.borderWidth = 0
                        subgrid.layer.borderColor = nil
                        subgrid.layer.cornerRadius = 0
                        subgrid.clipsToBounds = false
                    }
                }
                
                collectionView.layer.borderWidth = 4
                collectionView.layer.borderColor = UIColor.systemYellow.cgColor
                collectionView.layer.cornerRadius = 10
                collectionView.clipsToBounds = true
                
                self.selectedSubgridCollectionView = collectionView
                self.rotationStackView.isHidden = false
            }
        }
    }
}

extension GameBoardViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 9 //HAS TO BE 9 with the way storyboard is configured to make it look
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameBoardCollectionViewCell", for: indexPath) as! GameBoardCollectionViewCell
        var rowIndex: Int? = nil
        var columnIndex: Int? = nil
        var rowIndexOffset: Int? = nil
        var columnIndexOffset: Int? = nil
        
        switch indexPath.item
        {
            case 0:
                cell.initialCellType = .topLeftCell
                cell.currentCellType = .topLeftCell
                rowIndex = 0
                columnIndex = 0
            case 1:
                cell.initialCellType = .topMiddleCell
                cell.currentCellType = .topMiddleCell
                rowIndex = 0
                columnIndex = 1
            case 2:
                cell.initialCellType = .topRightCell
                cell.currentCellType = .topRightCell
                rowIndex = 0
                columnIndex = 2
            case 3:
                cell.initialCellType = .middleLeftCell
                cell.currentCellType = .middleLeftCell
                rowIndex = 1
                columnIndex = 0
            case 4:
                cell.initialCellType = .middleMiddleCell
                cell.currentCellType = .middleMiddleCell
                rowIndex = 1
                columnIndex = 1
            case 5:
                cell.initialCellType = .middleRightCell
                cell.currentCellType = .middleRightCell
                rowIndex = 1
                columnIndex = 2
            case 6:
                cell.initialCellType = .bottomLeftCell
                cell.currentCellType = .bottomLeftCell
                rowIndex = 2
                columnIndex = 0
            case 7:
                cell.initialCellType = .bottomMiddleCell
                cell.currentCellType = .bottomMiddleCell
                rowIndex = 2
                columnIndex = 1
            case 8:
                cell.initialCellType = .bottomRightCell
                cell.currentCellType = .bottomRightCell
                rowIndex = 2
                columnIndex = 2
            default:
                fatalError("There should only be 9 items in the collection view")
        }
        
        if(collectionView === upperLeftSubgrid)
        {
            rowIndexOffset = 0
            columnIndexOffset = 0
        }
        else
        {
            if(collectionView === upperRightSubgrid)
            {
                rowIndexOffset = 0
                columnIndexOffset = 3
            }
            else
            {
                if(collectionView === lowerLeftSubgrid)
                {
                    rowIndexOffset = 3
                    columnIndexOffset = 0
                }
                else
                {
                    if(collectionView === lowerRightSubgrid)
                    {
                        rowIndexOffset = 3
                        columnIndexOffset = 3
                    }
                }
            }
        }
        
        cell.gameBoardRowIndex = rowIndex! + rowIndexOffset! //Should be non-nil at this point
        cell.gameBoardColumnIndex = columnIndex! + columnIndexOffset!
        
        cell.cellImageView.image = ImageAssetFactory.getGameBoardCellUIImage(cellType: cell.initialCellType, colour: nil)
        
        guard cell.cellImageView.image != nil else
        {
            fatalError("Could not get a cell image for cell with rowIndex: \(String(cell.gameBoardRowIndex)) and columnIndex: \(String(cell.gameBoardColumnIndex))")
        }
        
        return cell
    }
    
    enum GamePhase
    {
        case placeMarble
        case rotateSubgid
        case animationOccuring
        case aiTurn
    }
    
    enum AnimationDuration: Int
    {
        case gridResizeDuration = 500 //Milliseconds
        case gridRotationDuation = 1500
    }
    
    enum AIWaitDuration: Int
    {
        case placeMarbleWait = 750 //Milliseconds
        case rotateSubgridWait = 1000
    }
}
