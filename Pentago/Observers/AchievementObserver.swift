//
//  AchievementObserver.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 13/12/2025.
//

protocol AchievementObserver
{
    var achievementsDict: Dictionary<String, Achievement> {get set}
    
    func updateAchievements(playerProfile: PlayerProfile) -> Achievement?
    
    mutating func addAchievement(key: Int, achievement: Achievement)
    
    mutating func removeAchievement(key: Int)
    
    func getAchievement(key: Int) -> Achievement?
    
    func getAchievementArray() -> Array<Achievement>
}
