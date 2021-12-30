//
//  MealMO+CoreDataClass.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/24/21.
//
//

import Foundation
import CoreData

@objc(MealMO)
public class MealMO: NSManagedObject {
    /// Save a Meal into a Category in the given Core Data view context.
    static func save(meal: Meal, in category: Category, intoViewContext viewContext: NSManagedObjectContext) {
        // Check that Category is not Mock, so we don't overwrite valid data with mock data.
        guard category != Category.mockCategory else { return }
        // Check that Meal is not Mock, so we don't overwrite valid data with mock data.
        guard meal != Meal.mockMeal else { return }
        
        let mealFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Meal")
        // Set the fetch request’s predicate to filter the fetch to a Meal with the same ID as the passed-in Meal.
        mealFetchRequest.predicate = NSPredicate(format: "id = %@", meal.id)
        
        let categoryFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        // Set the fetch request’s predicate to filter the fetch to Categories with the same ID as the passed-in Category.
        categoryFetchRequest.predicate = NSPredicate(format: "id = %@", category.id)
        
        /*
         Use the viewContext to try to execute the fetch request. If it succeeds, that
         means the Meal already exists, so update it with the values from the passed-in Meal.
         
         This implementation does not account for a meal being moved to a different Category.
         */
        if let results = try? viewContext.fetch(mealFetchRequest),
           let existing = results.first as? MealMO {
            print("MealMO - save: Saving To Existing Category")
            existing.id = meal.id
            existing.imageID = meal.imageID
            existing.name = meal.name
            
        } else {
            /*
             Otherwise, if the Meal does not exist yet, create a new Meal with
             the values from the passed-in Meal.
             
             Meals are saved and linked to a CategoryMO here.
             */
            if let results = try? viewContext.fetch(categoryFetchRequest),
               let existing = results.first as? CategoryMO {
                let newMeal = self.init(context: viewContext)
                newMeal.id = meal.id
                newMeal.imageID = meal.imageID
                newMeal.name = meal.name
                
                newMeal.category = existing
            }
        }
        
        // Attempt to save the viewContext.
        do {
            if viewContext.hasChanges {
                print("MealMO - Context had changes")
                try viewContext.save()
            }
        } catch {
            print(error)
        }
    }
}

extension Collection where Element == MealMO {
    
    func transformToMeals() -> [Meal] {
        let meals = self.map { mealMO -> Meal in
            #warning("Transform MealDetailsMO into MealDetail")
            let meal = Meal(
                name: mealMO.name,
                id: mealMO.id,
                imageID: mealMO.imageID,
                mealDetails: mealMO.mealDetails?.transformToMealDetails())
            
            return meal
        }
        
        return meals
    }
}
