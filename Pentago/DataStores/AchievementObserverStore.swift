//
//  AchievementObserverStore.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 31/12/2025.
// Class for storing the required achievement set up all player profiles will use

struct AchievementObserverStore
{
    private var achievementsEarnedInfo: Array<(key: Int, achievementTitle: String, achievementDescription: String)>!
    private var drawAchievementsInfo: Array<(key: Int, achievementTitle: String, achievementDescription: String)>!
    private var gamesPlayedAchievementsInfo: Array<(key: Int, achievementTitle: String, achievementDescription: String)>!
    private var loseAchievementsInfo: Array<(key: Int, achievementTitle: String, achievementDescription: String)>!
    private var movesMadeAchievementsInfo: Array<(key: Int, achievementTitle: String, achievementDescription: String)>!
    private var winAchievementsInfo: Array<(key: Int, achievementTitle: String, achievementDescription: String)>!
    
    
    init()
    {
        self.achievementsEarnedInfo = Array()
        self.drawAchievementsInfo = Array()
        self.gamesPlayedAchievementsInfo = Array()
        self.loseAchievementsInfo = Array()
        self.movesMadeAchievementsInfo = Array()
        self.winAchievementsInfo = Array()
        
        initialiseDrawAchievementsInfo()
        initialiseGamesPlayedAchievementInfo()
        initialiseLoseAchievementInfo()
        initialiseMovesMadeAchievementInfo()
        initialiseWinAchievementInfo()
        initialiseAchievementsEarnedInfo() //MUST ALWAYS BE CALLED LAST OF THE INITIALISER FUNCTIONS IN init
    }
    
    func createInitialisedObserverList() -> Array<AchievementObserver>
    {
        //This is so that new achievements (which are reference types) are created everytime a list of observer for a player profile is created since the observers carry references to them
        
        var observerList: Array<AchievementObserver> = [AchievementsEarnedAchievementObserver(), DrawAchievementObserver(), GamesPlayedAchievementObserver(), LoseAchievementObserver(), MovesMadeAchievementObserver(), WinAchievementObserver()]

        //To make sure everything has been ordered correctly
        guard observerList[0] is AchievementsEarnedAchievementObserver else
        {
            fatalError("The first element in the observer list in createInitialisedObserverList is not an instance of AchievementsEarnedAchievementObserver")
        }
        guard observerList[1] is DrawAchievementObserver else
        {
            fatalError("The second element in the observer list in createInitialisedObserverList is not an instance of DrawAchievementObserver")
        }
        guard observerList[2] is GamesPlayedAchievementObserver else
        {
            fatalError("The third element in the observer list in createInitialisedObserverList is not an instance of GamesPlayedAchievementObserver")
        }
        guard observerList[3] is LoseAchievementObserver else
        {
            fatalError("The fourth element in the observer list in createInitialisedObserverList is not an instance of LoseAchievementObserver")
        }
        guard observerList[4] is MovesMadeAchievementObserver else
        {
            fatalError("The fifth element in the observer list in createInitialisedObserverList is not an instance of MovesMadeAchievementObserver")
        }
        guard observerList[5] is WinAchievementObserver else
        {
            fatalError("The sixth element in the observer list in createInitialisedObserverList is not an instance of WinAchievementObserver")
        }
        
        for info in self.achievementsEarnedInfo
        {
            let achievement = Achievement(achievementTitle: info.achievementTitle, achievementDescription: info.achievementDescription)
            observerList[0].addAchievement(key: info.key, achievement: achievement)
        }
        
        for info in self.drawAchievementsInfo
        {
            let achievement = Achievement(achievementTitle: info.achievementTitle, achievementDescription: info.achievementDescription)
            observerList[1].addAchievement(key: info.key, achievement: achievement)
        }
        
        for info in self.gamesPlayedAchievementsInfo
        {
            let achievement = Achievement(achievementTitle: info.achievementTitle, achievementDescription: info.achievementDescription)
            observerList[2].addAchievement(key: info.key, achievement: achievement)
        }
        
        for info in self.loseAchievementsInfo
        {
            let achievement = Achievement(achievementTitle: info.achievementTitle, achievementDescription: info.achievementDescription)
            observerList[3].addAchievement(key: info.key, achievement: achievement)
        }
        
        for info in self.movesMadeAchievementsInfo
        {
            let achievement = Achievement(achievementTitle: info.achievementTitle, achievementDescription: info.achievementDescription)
            observerList[4].addAchievement(key: info.key, achievement: achievement)
        }
        
        for info in self.winAchievementsInfo
        {
            let achievement = Achievement(achievementTitle: info.achievementTitle, achievementDescription: info.achievementDescription)
            observerList[5].addAchievement(key: info.key, achievement: achievement)
        }
        
        return observerList
    }
    
    //Must always be called last in the init fucntion because one of its keys depends on the length of the others
    private mutating func initialiseAchievementsEarnedInfo()
    {
        self.achievementsEarnedInfo.append((key: 1, achievementTitle: "Trophy Hunter I", achievementDescription: "Earn your first achievement."))
        self.achievementsEarnedInfo.append((key: 10, achievementTitle: "Trophy Hunter II", achievementDescription: "Earn 10 achievements."))
        self.achievementsEarnedInfo.append((key: 15, achievementTitle: "Trophy Hunter III", achievementDescription: "Earn 15 achievements."))
        self.achievementsEarnedInfo.append((key: 20, achievementTitle: "Trophy Hunter IV", achievementDescription: "Earn 20 achievements."))
        
        let allAchievementsKey = self.achievementsEarnedInfo.count + self.drawAchievementsInfo.count + self.gamesPlayedAchievementsInfo.count + self.loseAchievementsInfo.count + self.movesMadeAchievementsInfo.count + self.winAchievementsInfo.count
        self.achievementsEarnedInfo.append((key: allAchievementsKey, achievementTitle: "Trophy Hunter V", achievementDescription: "Earn all achievements."))
    }
    
    private mutating func initialiseDrawAchievementsInfo()
    {
        self.drawAchievementsInfo.append((key: 1, achievementTitle: "Evenly Matched I", achievementDescription: "Have a match end in a draw between you and your opponent."))
        self.drawAchievementsInfo.append((key: 3, achievementTitle: "Evenly Matched II", achievementDescription: "Have 3 matches end in a draw."))
        self.drawAchievementsInfo.append((key: 6, achievementTitle: "Evenly Matched III", achievementDescription: "Have 6 matches end in a draw."))
        self.drawAchievementsInfo.append((key: 10, achievementTitle: "Evenly Matched IV", achievementDescription: "Have 10 matches end in a draw."))
        self.drawAchievementsInfo.append((key: 15, achievementTitle: "Evenly Matched V", achievementDescription: "Have 15 matches end in a draw."))
    }
    
    private mutating func initialiseGamesPlayedAchievementInfo()
    {
        self.gamesPlayedAchievementsInfo.append((key: 10, achievementTitle: "Game Addict I", achievementDescription: "Play 10 matches against another player or the AI."))
        self.gamesPlayedAchievementsInfo.append((key: 20, achievementTitle: "Game Addict II", achievementDescription: "Play a total of 20 matches."))
        self.gamesPlayedAchievementsInfo.append((key: 30, achievementTitle: "Game Addict III", achievementDescription: "Play a total of 30 matches."))
        self.gamesPlayedAchievementsInfo.append((key: 40, achievementTitle: "Game Addict IV", achievementDescription: "Play a total of 40 matches."))
        self.gamesPlayedAchievementsInfo.append((key: 50, achievementTitle: "Game Addict V", achievementDescription: "Play a total of 50 matches."))
    }
    
    private mutating func initialiseLoseAchievementInfo()
    {
        self.loseAchievementsInfo.append((key: 5, achievementTitle: "Sore Loser I", achievementDescription: "Lose 5 matches against another player or the AI."))
        self.loseAchievementsInfo.append((key: 10, achievementTitle: "Sore Loser II", achievementDescription: "Lose a total of 10 matches."))
        self.loseAchievementsInfo.append((key: 15, achievementTitle: "Sore Loser III", achievementDescription: "Lose a total of 15 matches."))
        self.loseAchievementsInfo.append((key: 20, achievementTitle: "Sore Loser IV", achievementDescription: "Lose a total of 20 matches."))
        self.loseAchievementsInfo.append((key: 25, achievementTitle: "Sore Loser V", achievementDescription: "Lose a total of 25 matches."))
    }
    
    private mutating func initialiseMovesMadeAchievementInfo()
    {
        self.movesMadeAchievementsInfo.append((key: 10, achievementTitle: "Move Maker I", achievementDescription: "Make a total of 10 moves across all matches you've played."))
        self.movesMadeAchievementsInfo.append((key: 50, achievementTitle: "Move Maker II", achievementDescription: "Make a total of 50 moves."))
        self.movesMadeAchievementsInfo.append((key: 100, achievementTitle: "Move Maker III", achievementDescription: "Make a total of 100 moves."))
        self.movesMadeAchievementsInfo.append((key: 150, achievementTitle: "Move Maker IV", achievementDescription: "Make a total of 150 moves."))
        self.movesMadeAchievementsInfo.append((key: 200, achievementTitle: "Move Maker V", achievementDescription: "Make a total of 200 moves."))
    }
    
    private mutating func initialiseWinAchievementInfo()
    {
        self.winAchievementsInfo.append((key: 5, achievementTitle: "Pentago Master I", achievementDescription: "Win 5 matches against another player or the AI."))
        self.winAchievementsInfo.append((key: 10, achievementTitle: "Pentago Master II", achievementDescription: "Win a total of 10 matches."))
        self.winAchievementsInfo.append((key: 15, achievementTitle: "Pentago Master III", achievementDescription: "Win a total of 15 matches."))
        self.winAchievementsInfo.append((key: 20, achievementTitle: "Pentago Master IV", achievementDescription: "Win a total of 20 matches."))
        self.winAchievementsInfo.append((key: 25, achievementTitle: "Pentago Master V", achievementDescription: "Win a total of 25 matches."))
    }
}

