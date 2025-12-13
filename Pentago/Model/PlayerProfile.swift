//
//  PlayerProfile.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 12/12/2025.
//
import Foundation

class PlayerProfile
{
    var playerID: UUID
    var userName: String
    var profilePicture: ProfilePicture
    var marbleColour: Marble.MarbleColour
    var playerStats: PlayerStatistics
    
    init(playerID: UUID, userName: String, profilePicture: ProfilePicture, marbleColour: Marble.MarbleColour, playerStats: PlayerStatistics)
    {
        self.playerID = playerID
        self.userName = userName
        self.profilePicture = profilePicture
        self.marbleColour = marbleColour
        self.playerStats = playerStats
    }
    
    class PlayerStatistics
    {
        var numGamesPlayed: Int
        var numWins: Int
        var numLosses: Int
        var numDraws: Int
        var totalMovesMade: Int
        var winPercentage: Double
        var numAchievemntsEarned: Int
        var achievementObserverList: Array<AchievementObserver>
        
        init()
        {
            self.numGamesPlayed = 0
            self.numWins = 0
            self.numLosses = 0
            self.numDraws = 0
            self.totalMovesMade = 0
            self.winPercentage = 0.0
            self.numAchievemntsEarned = 0
            self.achievementObserverList = Array<AchievementObserver>()
        }
    }
    
    enum ProfilePicture
    {
        case beach
        case cpuRobot
        case defaultIcon
        case desert
        case giraffe
        case lion
        case mountain
        case ostrich
        case puppy
        case tiger
        case tree
        case zebra
    }
}
