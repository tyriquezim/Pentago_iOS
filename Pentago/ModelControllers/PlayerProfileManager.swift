//
//  PlayerProfileManager.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 13/12/2025.
//
//This class is responsible for handling the business logic of all the PlayerProfiles that will be used in the game

import Foundation

class PlayerProfileManager
{
    var activePlayer1: PlayerProfile?
    {
        var player1: PlayerProfile? = nil
        
        for profile in self.playerProfilesArray
        {
            if(profile.isLocalPlayer1)
            {
                player1 = profile
                break
            }
        }
        
        return player1
    }
    var activePlayer2: PlayerProfile?
    {
        var player2: PlayerProfile? = nil
        
        for profile in self.playerProfilesArray
        {
            if(profile.isLocalPlayer2)
            {
                player2 = profile
                break
            }
        }
        
        return player2
    }
    private var playerProfilesArray: Array<PlayerProfile>
    private var aiProfilesArray: Array<PlayerProfile>
    
    init()
    {
        self.playerProfilesArray = Array()
        self.aiProfilesArray = Array()
    }
    
    func addPlayerProfile(newProfile: PlayerProfile) throws
    {
        updateProfileArrays()
        
        var allProfiles: Array<PlayerProfile> = Array()
        allProfiles.append(contentsOf: self.playerProfilesArray)
        allProfiles.append(contentsOf: self.aiProfilesArray)
        
        for profile in allProfiles
        {
            if(profile.playerID == newProfile.playerID)
            {
                throw GeneralException.IllegalArgument(message: "Could not add PlayerProfile to PlayerProfileManager. A PlayerProfile with the playerID, \(newProfile.playerID) already exists.")
            }
            else
            {
                if(profile.userName == newProfile.userName)
                {
                    throw GeneralException.IllegalArgument(message: "Could not add PlayerProfile to PlayerProfileManager. A PlayerProfile with the userName, \(newProfile.userName) already exists.")
                }
            }
            
        }
        self.playerProfilesArray.append(newProfile)
        newProfile.manager = self
    }
    
    func removePlayerProfile(index: Int)
    {
        updateProfileArrays()
        let removedProfile = self.playerProfilesArray.remove(at: index)
        removedProfile.manager = nil
    }
    
    func addAIProfile(newProfile: PlayerProfile) throws
    {
        updateProfileArrays()
        
        var allProfiles: Array<PlayerProfile> = Array()
        allProfiles.append(contentsOf: self.playerProfilesArray)
        allProfiles.append(contentsOf: self.aiProfilesArray)
        
        for profile in allProfiles
        {
            if(profile.playerID == newProfile.playerID)
            {
                throw GeneralException.IllegalArgument(message: "Could not add PlayerProfile to PlayerProfileManager. A PlayerProfile with the playerID, \(newProfile.playerID) already exists.")
            }
            else
            {
                if(profile.userName == newProfile.userName)
                {
                    throw GeneralException.IllegalArgument(message: "Could not add PlayerProfile to PlayerProfileManager. A PlayerProfile with the userName, \(newProfile.userName) already exists.")
                }
            }
            
        }
        self.aiProfilesArray.append(newProfile)
        newProfile.manager = self
        
    }
    
    func removeAIProfile(index: Int)
    {
        updateProfileArrays()
        let removedProfile = self.aiProfilesArray.remove(at: index)
        removedProfile.manager = nil
    }
    
    func getPlayerProfile(index: Int) -> PlayerProfile
    {
        updateProfileArrays()
        return self.playerProfilesArray[index]
    }
    
    func getPlayerProfile(playerID: UUID) -> PlayerProfile?
    {
        updateProfileArrays()
        var desiredProfile: PlayerProfile? = nil
        
        for profile in self.playerProfilesArray
        {
            if(profile.playerID == playerID)
            {
                desiredProfile = profile
                break //Stop iterating once the profile has been found
            }
        }
        
        return desiredProfile
    }
    
    func getPlayerProfile(userName: String) -> PlayerProfile?
    {
        updateProfileArrays()
        var desiredProfile: PlayerProfile? = nil
        
        for profile in self.playerProfilesArray
        {
            if(profile.userName == userName)
            {
                desiredProfile = profile
                break //Stop iterating once the profile has been found
            }
        }
        
        return desiredProfile
    }
    
    func getPlayerProfileArray() -> Array<PlayerProfile>
    {
        updateProfileArrays()
        return self.playerProfilesArray //As a reminder, arrays are returned by value in swift so modifications to the array returned from here dont affect the property (except for the objects referenced).
    }
    
    func getAIProfile(index: Int) -> PlayerProfile
    {
        updateProfileArrays()
        return self.aiProfilesArray[index]
    }
    
    func getAIProfile(playerID: UUID) -> PlayerProfile?
    {
        updateProfileArrays()
        var desiredProfile: PlayerProfile? = nil
        
        for profile in self.aiProfilesArray
        {
            if(profile.playerID == playerID)
            {
                desiredProfile = profile
                break //Stop iterating once the profile has been found
            }
        }
        
        return desiredProfile
    }
    
    func getAIProfile(userName: String) -> PlayerProfile?
    {
        updateProfileArrays()
        var desiredProfile: PlayerProfile? = nil
        
        for profile in self.aiProfilesArray
        {
            if(profile.userName == userName)
            {
                desiredProfile = profile
                break //Stop iterating once the profile has been found
            }
        }
        
        return desiredProfile
    }
    
    func getAIProfileArray() -> Array<PlayerProfile>
    {
        updateProfileArrays()
        return self.aiProfilesArray //As a reminder, arrays are returned by value in swift so modifications to the array returned from here dont affect the property (except for the objects referenced).
    }
    
    //This function ensures that the PlayerProfileManager's array is always up to date with PlayerProfiles that have it as a manager.
    private func updateProfileArrays()
    {
        var allProfiles: Array<PlayerProfile> = Array()
        allProfiles.append(contentsOf: self.playerProfilesArray)
        allProfiles.append(contentsOf: self.aiProfilesArray)
        
        for profile in allProfiles
        {
            if(profile.manager !== self)
            {
                self.playerProfilesArray.removeAll(where: {$0 === profile})//Removes profiles that no longer have their manager set to this manager
            }
        }
    }
}
