//
//  PlayerEntity+CoreDataProperties.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 10/1/2026.
//
//

import Foundation
import CoreData


extension PlayerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerEntity> {
        return NSFetchRequest<PlayerEntity>(entityName: "PlayerEntity")
    }

    @NSManaged public var isLocalPlayer1: Bool
    @NSManaged public var isLocalPlayer2: Bool
    @NSManaged public var marbleColour: String
    @NSManaged public var numDraws: Int64
    @NSManaged public var numLosses: Int64
    @NSManaged public var numWins: Int64
    @NSManaged public var playerID: UUID
    @NSManaged public var profilePicture: String
    @NSManaged public var totalMovesMade: Int64
    @NSManaged public var userName: String
    @NSManaged public var owns: NSSet?

}

// MARK: Generated accessors for owns
extension PlayerEntity {

    @objc(addOwnsObject:)
    @NSManaged public func addToOwns(_ value: AchievementEntity)

    @objc(removeOwnsObject:)
    @NSManaged public func removeFromOwns(_ value: AchievementEntity)

    @objc(addOwns:)
    @NSManaged public func addToOwns(_ values: NSSet)

    @objc(removeOwns:)
    @NSManaged public func removeFromOwns(_ values: NSSet)

}

extension PlayerEntity : Identifiable {

}
