//
//  CategoryMO+CoreDataProperties.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/24/21.
//
//

import Foundation
import CoreData


extension CategoryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryMO> {
        return NSFetchRequest<CategoryMO>(entityName: "Category")
    }

    @NSManaged public var footerDescription: String
    @NSManaged public var id: String
    @NSManaged public var imageID: URL?
    @NSManaged public var name: String
    @NSManaged public var meals: NSOrderedSet?

}

// MARK: Generated accessors for meals
extension CategoryMO {

    @objc(insertObject:inMealsAtIndex:)
    @NSManaged public func insertIntoMeals(_ value: MealMO, at idx: Int)

    @objc(removeObjectFromMealsAtIndex:)
    @NSManaged public func removeFromMeals(at idx: Int)

    @objc(insertMeals:atIndexes:)
    @NSManaged public func insertIntoMeals(_ values: [MealMO], at indexes: NSIndexSet)

    @objc(removeMealsAtIndexes:)
    @NSManaged public func removeFromMeals(at indexes: NSIndexSet)

    @objc(replaceObjectInMealsAtIndex:withObject:)
    @NSManaged public func replaceMeals(at idx: Int, with value: MealMO)

    @objc(replaceMealsAtIndexes:withMeals:)
    @NSManaged public func replaceMeals(at indexes: NSIndexSet, with values: [MealMO])

    @objc(addMealsObject:)
    @NSManaged public func addToMeals(_ value: MealMO)

    @objc(removeMealsObject:)
    @NSManaged public func removeFromMeals(_ value: MealMO)

    @objc(addMeals:)
    @NSManaged public func addToMeals(_ values: NSOrderedSet)

    @objc(removeMeals:)
    @NSManaged public func removeFromMeals(_ values: NSOrderedSet)

}

extension CategoryMO : Identifiable {

}
