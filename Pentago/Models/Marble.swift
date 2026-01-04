//
//  Marble.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 12/12/2025.
//

import Foundation

struct Marble
{
    let marbleOwner: PlayerProfile
    let marbleColour: MarbleColour
    
    init(marbleOwner: PlayerProfile, marbleColour: MarbleColour)
    {
        self.marbleOwner = marbleOwner
        self.marbleColour = marbleColour
    }
    
    enum MarbleColour: CaseIterable
    {
        case black
        case blue
        case green
        case orange
        case pink
        case purple
        case red
        case yellow
        case grey
        
        static func random() -> MarbleColour
        {
            let randomIndex = Int.random(in: 0..<allCases.count)
            
            return allCases[randomIndex]
        }
        
        static func random(caseArray: Array<MarbleColour>) -> MarbleColour
        {
            let randomIndex = Int.random(in: 0..<caseArray.count)
            
            return caseArray[randomIndex]
        }
    }
}
