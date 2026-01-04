//
//  OpponentSelectViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 1/1/2026.
//

import UIKit

class OpponentSelectViewController: UIViewController
{
    @IBOutlet var humanVsHumanImageView: UIImageView!
    @IBOutlet var humanVsAIImageView: UIImageView!
    
    var profileManager: PlayerProfileManager!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let humanVsHumanTapRecog = UITapGestureRecognizer(target: self, action: #selector(onHumanVsHumanTouchUp))
        let humanVsAITapRecog = UITapGestureRecognizer(target: self, action: #selector(onHumanVsAITouchUp))
        
        humanVsHumanImageView.isUserInteractionEnabled = true
        humanVsAIImageView.isUserInteractionEnabled = true
        
        humanVsHumanImageView.addGestureRecognizer(humanVsHumanTapRecog)
        humanVsAIImageView.addGestureRecognizer(humanVsAITapRecog)
    }
    
    @objc func onHumanVsHumanTouchUp()
    {
        if let player1 = self.profileManager.activePlayer1, let player2 = self.profileManager.activePlayer2
        {
            let gameBoard = GameBoard(player1Profile: player1, player2Profile: player2, isAgainstAiOpponent: false)
            let gameController = GameBoardController(gameBoard: gameBoard)
            let gameboardVC = storyboard!.instantiateViewController(withIdentifier: "StoryBoardGameBoardViewController") as! GameBoardViewController
            gameboardVC.gameController = gameController
            
            self.navigationController!.pushViewController(gameboardVC, animated: true)
        }
        else
        {
            //notify the user
        }
    }
    
    @objc func onHumanVsAITouchUp()
    {
        if let player1 = self.profileManager.activePlayer1
        {
            let gameBoard = GameBoard(player1Profile: player1, player2Profile: profileManager.getAIProfile(index: 0), isAgainstAiOpponent: true)
            let gameController = GameBoardController(gameBoard: gameBoard)
            let gameboardVC = storyboard!.instantiateViewController(withIdentifier: "StoryBoardGameBoardViewController") as! GameBoardViewController
            gameboardVC.gameController = gameController
            
            self.navigationController!.pushViewController(gameboardVC, animated: true)
        }
        else
        {
            //notify the user
        }
    }
}
