//
//  CategoryMO+CoreDataClass.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/24/21.
//
//

import Foundation
import CoreData

@objc(CategoryMO)
public class CategoryMO: NSManagedObject {

}

extension CategoryMO {
    /// Save a Category into the given Core Data view context.
    static func save(category: Category, intoViewContext viewContext: NSManagedObjectContext) {
        // Check that Category is not Mock, so we don't overwrite valid data with mock data.
        guard category != Category.mockCategory else { return }
        
        // Create a fetch request using the CategoryMO entity name.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        
        // Set the fetch request’s predicate to filter the fetch to Categories with the same ID as the passed-in Category.
        fetchRequest.predicate = NSPredicate(format: "id = %@", category.id)
        
        /*
         Use the viewContext to try to execute the fetch request. If it succeeds, that
         means the Category already exists, so update it with the values from the passed-in Category.
         
         Note that this is useful when the API gets updated--it is uncertain if this one does.
         Furthermore, the current code does not perform another fetch request unless Core Data is empty.
         */
        if let results = try? viewContext.fetch(fetchRequest),
           let existing = results.first as? CategoryMO {
            print("CategoryMO - save: Saving To Existing Category")
            existing.footerDescription = category.description
            existing.id = category.id
            existing.imageID = category.imageID
            existing.name = category.name
        } else {
            /*
             Otherwise, if the Category does not exist yet, create a new Category with
             the values from the passed-in Category.
             
             Meals are saved and linked to a CategoryMO through MealMO's save method.
             */
            let newCategory = self.init(context: viewContext)
            newCategory.footerDescription = category.description
            newCategory.id = category.id
            newCategory.imageID = category.imageID
            newCategory.name = category.name
        }
        
        // Attempt to save the viewContext.
        do {
            if viewContext.hasChanges {
                print("CategoryMO - Context had changes")
                try viewContext.save()
            }
        } catch {
            print(error)
        }
    }
}

extension Collection where Element == CategoryMO {
    
    func transformToCategories() -> [Category] {
        let categories = self.map { categoryMO -> Category in
            guard let meals = categoryMO.meals?.array as? [MealMO] else {
                print("Meals Unavailable")
                return Category.mockCategory
            }

            let category = Category(
                name: categoryMO.name,
                id: categoryMO.id,
                imageID: categoryMO.imageID,
                description: categoryMO.footerDescription,
                meals: meals.transformToMeals())
            
            return category
        }
        
        return categories
    }
}
