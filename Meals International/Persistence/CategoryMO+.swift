//
//  CategoryMO+.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/17/21.
//

import CoreData
import Foundation


/*
 extension CategoryMO {
     
     static func save(category: Category, inViewContext viewContext: NSManagedObjectContext) {
         #warning("Check to make sure that Category is not Mock, so we don't overwrite valid data with mock.")
         // Create a fetch request for the CategoryMO entity name.
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
         // Set the fetch request’s predicate to filter the fetch to Categories with the same ID as the passed-in Category.
         fetchRequest.predicate = NSPredicate(format: "id = %@", category.id)
         
         /*
          Use the viewContext to try to execute the fetch request. If it succeeds, that
          means the Category already exists, so update it with the values from the passed-in Category.
          */
         #warning("Do I even need to perform updates? I guess if new recipes come in?")
         if let results = try? viewContext.fetch(fetchRequest),
            let existing = results.first as? CategoryMO {
             existing.footerDescription = category.description
             existing.id = category.id
             existing.imageID = category.imageID
             existing.name = category.name
             
             existing.meals = NSOrderedSet(array: category.meals)
         } else {
             /*
              Otherwise, if the Category does not exist yet, create a new Category with
              the values from the passed-in Category.
              */
             let newCategory = self.init(context: viewContext)
             newCategory.footerDescription = category.description
             newCategory.id = category.id
             newCategory.imageID = category.imageID
             newCategory.name = category.name
             
             newCategory.meals = NSOrderedSet(array: category.meals)
             print("Saving Meals: \(category.meals)")
             //print(newCategory.meals)
         }
         #warning("Do I need this save here if I already will be trying in enter background?")
         // Attempt to save the viewContext.
         do {
             try viewContext.save()
         } catch {
             fatalError("\(#file), \(#function), \(error.localizedDescription)")
         }
     }
     
     static func loadSavedData() -> [Category] {
         let request = CategoryMO.fetchRequest()
         //let sort = NSSortDescriptor(key)
         var fetchedResult: [CategoryMO] = []
         var result: [Category] = []
         
         do {
             fetchedResult = try CoreDataStack.viewContext.fetch(request)
             print("Loaded CoreData, count: \(result.count)")
         } catch {
             // Handle error
             print("Fetch Failed")
         }
         
         for categoryMO in fetchedResult {
             // What happens if this fails?
             if let category = Category(categoryMO: categoryMO) {
                 result.append(category)
             }
         }
         //print(result)
         return result
     }
 }
 */
