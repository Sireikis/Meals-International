//
//  MealDetailsMO+CoreDataClass.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/24/21.
//
//

import Foundation
import CoreData

@objc(MealDetailsMO)
public class MealDetailsMO: NSManagedObject {
    /// Save a MealDetail in a Meal in the given Core Data view context.
    static func save(mealDetails: MealDetails, in meal: Meal, intoViewContext viewContext: NSManagedObjectContext) {
        // Check that MealDetail is not Mock, so we don't overwrite valid data with mock data.
        guard mealDetails != MealDetails.mockMealDetails else { return }
        // Check that Meal is not Mock, so we don't overwrite valid data with mock data.
        guard meal != Meal.mockMeal else { return }
        
        let mealDetailsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MealDetails")
        // Set the fetch request’s predicate to filter the fetch to a Meal with the same ID as the passed-in Meal.
        mealDetailsFetchRequest.predicate = NSPredicate(format: "id = %@", mealDetails.id)
        
        let mealFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Meal")
        // Set the fetch request’s predicate to filter the fetch to a Meal with the same ID as the passed-in Meal.
        mealFetchRequest.predicate = NSPredicate(format: "id = %@", meal.id)
        
        /*
         Use the viewContext to try to execute the fetch request. If it succeeds, that
         means the MealDetails already exists, so update it with the values from the passed-in MealDetails.
         */
        if let results = try? viewContext.fetch(mealDetailsFetchRequest),
           let existing = results.first as? MealDetailsMO {
            print("MealDetailsMO - save: Saving To Existing Meal")
            existing.area = mealDetails.area
            existing.category = mealDetails.category
            existing.id = mealDetails.id
            existing.ingredients = mealDetails.ingredients
            existing.instructions = mealDetails.instructions
            existing.name = mealDetails.name
            
        } else {
            /*
             Otherwise, if the MealDetails does not exist yet, create a new MealDetails with
             the values from the passed-in MealDetails.
             
             Meals are saved and linked to a MealDetail here.
             */
            if let results = try? viewContext.fetch(mealFetchRequest),
               let existing = results.first as? MealMO {
                let newMealDetails = self.init(context: viewContext)
                
                newMealDetails.area = mealDetails.area
                newMealDetails.category = mealDetails.category
                newMealDetails.id = mealDetails.id
                newMealDetails.ingredients = mealDetails.ingredients
                newMealDetails.instructions = mealDetails.instructions
                newMealDetails.name = mealDetails.name
                
                newMealDetails.meal = existing
            }
        }
        
        // Attempt to save the viewContext.
        do {
            if viewContext.hasChanges {
                print("MealDetailsMO - Context had changes")
                try viewContext.save()
            }
        } catch {
            print(error)
        }
    }
}

extension MealDetailsMO {

    func transformToMealDetails() -> MealDetails {
        let mealDetailsMO = self
        
        let mealDetails = MealDetails(
            name: mealDetailsMO.name,
            id: mealDetailsMO.id,
            category: mealDetailsMO.category,
            area: mealDetailsMO.area,
            instructions: mealDetailsMO.instructions,
            ingredients: mealDetailsMO.ingredients)

        return mealDetails
    }
}
