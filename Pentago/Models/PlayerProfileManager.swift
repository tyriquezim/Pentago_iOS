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
    private var playerProfilesArray: Array<PlayerProfile>
    
    init()
    {
        self.playerProfilesArray = Array<PlayerProfile>()
    }
    
    func addPlayerProfile(newProfile: PlayerProfile) throws
    {
        updatePlayerProfileArray()
        for profile in self.playerProfilesArray
        {
            if(profile.playerID == newProfile.playerID)
            {
                throw Exception.IllegalArgument(message: "Could not add PlayerProfile to PlayerProfileManager. A PlayerProfile with the playerID, \(newProfile.playerID) already exists.")
            }
            else
            {
                if(profile.userName == newProfile.userName)
                {
                    throw Exception.IllegalArgument(message: "Could not add PlayerProfile to PlayerProfileManager. A PlayerProfile with the userName, \(newProfile.userName) already exists.")
                }
            }
            
        }
        self.playerProfilesArray.append(newProfile)
        newProfile.manager = self
    }
    
    func removePlayerProfile(index: Int)
    {
        updatePlayerProfileArray()
        let removedProfile = self.playerProfilesArray.remove(at: index)
        removedProfile.manager = nil
    }
    
    func getPlayerProfile(index: Int) -> PlayerProfile
    {
        updatePlayerProfileArray()
        return self.playerProfilesArray[index]
    }
    
    func getPlayerProfile(playerID: UUID) -> PlayerProfile?
    {
        updatePlayerProfileArray()
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
        updatePlayerProfileArray()
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
        updatePlayerProfileArray()
        return self.playerProfilesArray //As a reminder, arrays are returned by value in swift so modifications to the array returned from here dont affect the property (except for the objects referenced).
    }
    
    //This function ensures that the PlayerProfileManager's array is always up to date with PlayerProfiles that have it as a manager.
    private func updatePlayerProfileArray()
    {
        var arrayCopy = self.playerProfilesArray
        for profile in arrayCopy
        {
            if(profile.manager !== self)
            {
                self.playerProfilesArray.removeAll(where: {$0 === profile})//Removes profiles that no longer have their manager set to this manager
            }
        }
    }
}
