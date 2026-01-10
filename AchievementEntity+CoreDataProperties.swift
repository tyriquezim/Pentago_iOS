//
//  AchievementEntity+CoreDataProperties.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 10/1/2026.
//
//

import Foundation
import CoreData


extension AchievementEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AchievementEntity> {
        return NSFetchRequest<AchievementEntity>(entityName: "AchievementEntity")
    }

    @NSManaged public var achievementDescription: String?
    @NSManaged public var achievementTitle: String?
    @NSManaged public var dateEarned: Date?
    @NSManaged public var hasBeenDisplayed: Bool
    @NSManaged public var hasBeenEarned: Bool
    @NSManaged public var belongsTo: PlayerEntity?

}
