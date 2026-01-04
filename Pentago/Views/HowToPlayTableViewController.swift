//
//  HowToPlayTableViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 1/1/2026.
//
import UIKit

class HowToPlayTableViewController: UITableViewController
{
    var gameRuleInfoStore: GameRulesInfoStore!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.gameRuleInfoStore = GameRulesInfoStore()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return gameRuleInfoStore.gameRulesArray.count + 1 //Game Description and rules
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell
        
        if(indexPath.row == 0)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "GameDescriptionTableViewCell", for: indexPath)
            var gameDescCell = cell as! GameDescriptionTableViewCell
            
            gameDescCell.mainImageView.image = ImageAssetFactory.getAppLogoUIImage()
            gameDescCell.gameDescriptionLabel.text = gameRuleInfoStore.gameDescription
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "RuleTableViewCell", for: indexPath)
            var ruleCell = cell as! RuleTableViewCell
            
            let ruleCellIndex: Int = indexPath.row - 1
            
            ruleCell.ruleImageView.image = ImageAssetFactory.getRuleUIImage(ruleTitle: gameRuleInfoStore.gameRulesArray[ruleCellIndex].ruleTitle)
            ruleCell.ruleTitle.text = gameRuleInfoStore.gameRulesArray[ruleCellIndex].ruleTitle.rawValue
            ruleCell.ruleDescriptionLabel.text = gameRuleInfoStore.gameRulesArray[ruleCellIndex].ruleDescription
        }
        
        return cell
    }
}
