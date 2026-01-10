//
//  PlayerEntity+CoreDataClass.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 10/1/2026.
//
//

import Foundation
import UIKit
import CoreData

public class PlayerEntity: NSManagedObject
{
    func savePlayerProfileData(playerProfile: PlayerProfile)
    {
        self.playerID = playerProfile.playerID
        self.userName = playerProfile.userName
        self.profilePicture = playerProfile.profilePicture.rawValue
        self.marbleColour = playerProfile.marbleColour.rawValue
        self.isLocalPlayer1 = playerProfile.isLocalPlayer1
        self.isLocalPlayer2 = playerProfile.isLocalPlayer2
        self.numWins = Int64(playerProfile.numWins)
        self.numLosses = Int64(playerProfile.numLosses)
        self.numDraws = Int64(playerProfile.numDraws)
        self.totalMovesMade = Int64(playerProfile.totalMovesMade)
        
        let context = self.managedObjectContext!
        
        let achievementsRequest: NSFetchRequest<AchievementEntity> = AchievementEntity.fetchRequest()
        achievementsRequest.predicate = NSPredicate(format: "belongsTo == %@", self)
        
        do
        {
            let achievementEntities = try context.fetch(achievementsRequest)
            
            if(achievementEntities.isEmpty)
            {
                for achievement in playerProfile.achievements
                {
                    let achievementEntity = AchievementEntity(context: context)
                    
                    achievementEntity.achievementTitle = achievement.achievementTitle
                    achievementEntity.achievementDescription = achievement.achievementDescription
                    achievementEntity.dateEarned = achievement.dateEarned
                    achievementEntity.hasBeenEarned = achievement.hasBeenEarned
                    achievementEntity.hasBeenDisplayed = achievement.hasBeenDisplayed
                    achievementEntity.belongsTo = self
                    self.addToOwns(achievementEntity)
                }
            }
            else
            {
                for achievementEntity in achievementEntities
                {
                    for achievement in playerProfile.achievements
                    {
                        if(achievementEntity.achievementTitle == achievement.achievementTitle)
                        {
                            achievementEntity.achievementTitle = achievement.achievementTitle
                            achievementEntity.achievementDescription = achievement.achievementDescription
                            achievementEntity.dateEarned = achievement.dateEarned
                            achievementEntity.hasBeenEarned = achievement.hasBeenEarned
                            achievementEntity.hasBeenDisplayed = achievement.hasBeenDisplayed
                        }
                    }
                }
            }
        }
        catch
        {
            fatalError("Something went wrong retrieving achieventEntities")
        }
        
        do
        {
            try context.save()
        }
        catch let error as NSError
        {
            fatalError("Failed to save context: \(error)")
        }
        catch
        {
            fatalError("Failed to save context")
        }
    }
}
