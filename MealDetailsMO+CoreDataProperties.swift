//
//  MealDetailsMO+CoreDataProperties.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/24/21.
//
//

import Foundation
import CoreData


extension MealDetailsMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealDetailsMO> {
        return NSFetchRequest<MealDetailsMO>(entityName: "MealDetails")
    }

    @NSManaged public var area: String?
    @NSManaged public var category: String?
    @NSManaged public var id: String?
    @NSManaged public var ingredients: [String]?
    @NSManaged public var instructions: String?
    @NSManaged public var name: String?
    @NSManaged public var meal: MealMO?

}

extension MealDetailsMO : Identifiable {

}
