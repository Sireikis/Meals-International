//
//  MealMO+CoreDataProperties.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/28/21.
//
//

import Foundation
import CoreData


extension MealMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealMO> {
        return NSFetchRequest<MealMO>(entityName: "Meal")
    }

    @NSManaged public var id: String
    @NSManaged public var imageID: URL?
    @NSManaged public var name: String
    @NSManaged public var photoData: Data?
    @NSManaged public var category: CategoryMO?
    @NSManaged public var mealDetails: MealDetailsMO?

}

extension MealMO : Identifiable {

}
