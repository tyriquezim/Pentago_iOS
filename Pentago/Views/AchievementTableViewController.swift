//
//  AchievementTableViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 2/1/2026.
//
import UIKit

class AchievementTableViewController: UITableViewController
{
    var sourceProfile: PlayerProfile!
    let dateFormatter: DateFormatter =
    {
        let df = DateFormatter()
        df.dateStyle = .medium
        
        return df
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sourceProfile.achievements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let achievementTVCell = tableView.dequeueReusableCell(withIdentifier: "AchievementTableViewCell", for: indexPath) as! AchievementTableViewCell
        let designatedAchievement = sourceProfile.achievements[indexPath.row]
        
        //Check to see if Achievement is configured as expected
        if(designatedAchievement.hasBeenEarned && designatedAchievement.dateEarned == nil)
        {
            fatalError("Achievement Configuration error. Instance variable hasBeenEarned is true but dateEarned is nil")
        }
        if(!designatedAchievement.hasBeenEarned && designatedAchievement.dateEarned != nil)
        {
            fatalError("Achievement Configuration error. Instance variable hasBeenEarned is false but dateEarned is not nil")
        }
        
        if let earnedDate = designatedAchievement.dateEarned
        {
            achievementTVCell.achievementDateLabel.isHidden = true
            achievementTVCell.achievementDateLabel.text = dateFormatter.string(from: earnedDate)
        }
        else
        {
            achievementTVCell.achievementDateLabel.isHidden = true
        }
        
        achievementTVCell.achievementImageView.image = ImageAssetFactory.getAchievementEarnStatusUIImage(hasBeenEarned: designatedAchievement.hasBeenEarned)
        achievementTVCell.achievementTitleLabel.text = designatedAchievement.achievementTitle
        achievementTVCell.achievementDescriptionLabel.text = designatedAchievement.achievementDescription
    
        return achievementTVCell
    }
}
