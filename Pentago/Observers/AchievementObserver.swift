//
//  AchievementObserver.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 13/12/2025.
//

protocol AchievementObserver
{
    func updateAchievements(playerStats: PlayerProfile.PlayerStatistics) -> Array<Achievement>
    
    func getAchievementList() -> Array<Achievement>
}
