//
//  AchievementTableViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 2/1/2026.
//
import UIKit
import EasyConfetti

class AchievementTableViewController: UITableViewController
{
    var sourceProfile: PlayerProfile!
    var confettiView: ConfettiView!
    var confettiDuration: Double!
    let dateFormatter: DateFormatter =
    {
        let df = DateFormatter()
        df.dateStyle = .medium
        
        return df
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        confettiView = ConfettiView(frame: CGRect(x: self.view.frame.width / 2, y: 0, width: 0, height: 0))
        self.view.addSubview(confettiView)
    
        confettiView.config.particle = .confetti(allowedShapes: Particle.ConfettiShape.all)
        confettiDuration = 5
    }
    
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
            achievementTVCell.achievementDateLabel.isHidden = false
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let designatedAchievement = sourceProfile.achievements[indexPath.row]
        
        if(designatedAchievement.hasBeenEarned)
        {
            confettiView.start()
            DispatchQueue.main.asyncAfter(deadline: .now() + confettiDuration)
            {
                self.confettiView.stop()
            }
        }
    }
}
