//
//  ViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 6/12/2025.
//
import UIKit

class MainMenuViewController: UIViewController
{
    @IBOutlet var playButton: UIButton!
    @IBOutlet var profileSettingsButton: UIButton!
    @IBOutlet var gameplayStatisticsButton: UIButton!
    @IBOutlet var achievementsButton: UIButton!
    
    var profileManager: PlayerProfileManager! //Stores and manages user profiles
    var achievementObserverStore: AchievementObserverStore!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.profileManager = PlayerProfileManager()
        self.achievementObserverStore = AchievementObserverStore()
        
        //Initial Player Objects
        var playerProfile1 = PlayerProfile(userName: "Tyrique", profilePicture: PlayerProfile.ProfilePicture.tiger, marbleColour: Marble.MarbleColour.red)
        var playerProfile2 = PlayerProfile(userName: "Naruto", profilePicture: PlayerProfile.ProfilePicture.giraffe, marbleColour: Marble.MarbleColour.orange)
        var playerProfile3 = PlayerProfile(userName: "Sasuke", profilePicture: PlayerProfile.ProfilePicture.lion, marbleColour: Marble.MarbleColour.blue)
        var playerProfile4 = PlayerProfile(userName: "Sakura", profilePicture: PlayerProfile.ProfilePicture.ostrich, marbleColour: Marble.MarbleColour.pink)
        var aiProfile = PlayerProfile(userName: "AI", profilePicture: PlayerProfile.ProfilePicture.cpuRobot, marbleColour: Marble.MarbleColour.grey)
        
        do
        {
            try self.profileManager.addPlayerProfile(newProfile: playerProfile1)
            try self.profileManager.addPlayerProfile(newProfile: playerProfile2)
            try self.profileManager.addPlayerProfile(newProfile: playerProfile3)
            try self.profileManager.addPlayerProfile(newProfile: playerProfile4)
            try self.profileManager.addAIProfile(newProfile: aiProfile)
        }
        catch(GeneralException.IllegalArgument)
        {
            //Will replace with a notification
            fatalError("Could not add profile.")
        }
        catch
        {
            fatalError("Unexpected error: \(error)")
        }
        
        playerProfile1.isLocalPlayer1 = true
        playerProfile2.isLocalPlayer2 = true
        
        var allProfiles: Array<PlayerProfile> = Array()
        allProfiles.append(contentsOf: self.profileManager.getPlayerProfileArray())
        allProfiles.append(contentsOf: self.profileManager.getAIProfileArray())
        
        for profile in allProfiles
        {
            profile.addAchievementObservers(achievementObservers: achievementObserverStore.createInitialisedObserverList())
        }
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        
        //Fixing bug where the button fonts set in Interface Builder weren't applying to the running program
        let interfaceBuilderFont = UIFont(name: "Futura Bold", size: 19)
        
        playButton.configuration?.attributedTitle?[AttributeScopes.UIKitAttributes.FontAttribute.self] = interfaceBuilderFont
        profileSettingsButton.configuration?.attributedTitle?[AttributeScopes.UIKitAttributes.FontAttribute.self] = interfaceBuilderFont
        gameplayStatisticsButton.configuration?.attributedTitle?[AttributeScopes.UIKitAttributes.FontAttribute.self] = interfaceBuilderFont
        achievementsButton.configuration?.attributedTitle?[AttributeScopes.UIKitAttributes.FontAttribute.self] = interfaceBuilderFont
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier
        {
            case "opponentSelectSegue":
                let opponentSelectViewController = segue.destination as! OpponentSelectViewController
                opponentSelectViewController.profileManager = self.profileManager
                
            case "profileSettingsSelectSegue":
                let profileSelectViewController = segue.destination as! ProfileSelectViewController
                profileSelectViewController.profileManager = self.profileManager
                profileSelectViewController.nextScreen = .editProfileScreen
            
            case "gameStatsSelectSegue":
                let profileSelectViewController = segue.destination as! ProfileSelectViewController
                profileSelectViewController.profileManager = self.profileManager
                profileSelectViewController.nextScreen = .gameplayStatsScreen
            
            
            case "achievementsSelectSegue":
                let profileSelectViewController = segue.destination as! ProfileSelectViewController
                profileSelectViewController.profileManager = self.profileManager
                profileSelectViewController.nextScreen = .achievementScreen
            
            default:
                preconditionFailure("Unexpected segue identifier")
        }
    }
    
    enum ProfileSelectScreenDestination
    {
        case editProfileScreen
        case gameplayStatsScreen
        case achievementScreen
    }
}

