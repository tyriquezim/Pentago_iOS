//
//  DrawAchievementObserver.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 14/12/2025.
//

struct DrawAchievementObserver: AchievementObserver
{
    var achievementsDict: Dictionary<String, Achievement>
    
    init()
    {
        self.achievementsDict = Dictionary<String, Achievement>()
    }
    
    func updateAchievements(playerProfile: PlayerProfile) -> Achievement?
    {
        let stringDrawKey = String(playerProfile.numDraws)
        let desiredAchievement =  self.achievementsDict[stringDrawKey]
        
        if(desiredAchievement != nil)
        {
            desiredAchievement?.earnAchivement()
        }
        
        return desiredAchievement
    }
    
    mutating func addAchievement(key: Int, achievement: Achievement)
    {
        let stringKey = String(key)
        self.achievementsDict[stringKey] = achievement
    }
    
    mutating func removeAchievement(key: Int)
    {
        let stringKey = String(key)
        self.achievementsDict.removeValue(forKey: stringKey)
    }
    
    func getAchievement(key: Int) -> Achievement?
    {
        let stringKey = String(key)
        let desiredAchievement = achievementsDict[stringKey]
        
        return desiredAchievement
    }
    
    func getAchievementArray() -> Array<Achievement>
    {
        return Array<Achievement>(achievementsDict.values)
    }
}
