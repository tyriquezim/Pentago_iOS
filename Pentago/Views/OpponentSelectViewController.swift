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
            if(player1.marbleColour == player2.marbleColour)
            {
                let alert = UIAlertController(title: "Change Colour", message: "Both players cannot have the same marble colour. They are currently both set to \(player1.marbleColour.rawValue)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                let gameBoard = GameBoard(player1Profile: player1, player2Profile: player2, isAgainstAiOpponent: false)
                let gameController = GameBoardController(gameBoard: gameBoard)
                let gameboardVC = storyboard!.instantiateViewController(withIdentifier: "StoryBoardGameBoardViewController") as! GameBoardViewController
                gameboardVC.gameController = gameController
                
                self.navigationController!.pushViewController(gameboardVC, animated: true)
            }
        }
        else
        {
            if(self.profileManager.activePlayer1 == nil && self.profileManager.activePlayer2 == nil)
            {
                let alert = UIAlertController(title: "Set Players", message: "There are currently no profiles set as Player 1 and Player 2. Head back to the main menu and change this in Profile Settings.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                if(self.profileManager.activePlayer1 == nil)
                {
                    let alert = UIAlertController(title: "Set Player 1", message: "There are currently no profiles set as Player 1. Head back to the main menu and change this in Profile Settings.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    if(self.profileManager.activePlayer2 == nil)
                    {
                        let alert = UIAlertController(title: "Set Player 2", message: "There are currently no profiles set as Player 2. Head back to the main menu and change this in Profile Settings.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
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
            let alert = UIAlertController(title: "Set Player 1", message: "There are currently no profiles set as Player 1 (Required to go against the AI). Head back to the main menu and change this in Profile Settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
