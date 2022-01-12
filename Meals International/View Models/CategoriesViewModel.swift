//
//  CategoriesViewModel.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Combine
import CoreData
import Foundation
import UIKit


extension CategoriesViewController {
    
    final class ViewModel: ObservableObject {
        
        var appState: AppState
        
        let container: DIContainer
        
        private static let decoder = JSONDecoder()
        private let mealsDBService: APIServiceDataPublisher
        private let imageService: ImageServicePublisher
        public let coreDataStack: CoreDataStack
        
        init(container: DIContainer) {
            self.container = container
            self.mealsDBService = container.services.mealsDBService
            self.imageService = container.services.imageService
            self.coreDataStack = container.coreDataStack
            
            self.appState = container.appState
        }
        
        // MARK: - Model Manipulation
        
        public func updateModel(meals: [Meal], at index: Int) {
            appState.categories[index].meals = meals
        }
        
        // MARK: - API Calls
        
        /// Calls TheMealsDB API to retrieve a list of Categories.
        public func fetchCategories() -> AnyPublisher<[Category], Error> {
            mealsDBService.categories()
        }
        
        /// Calls TheMealsDB API to retrieve a list of Meals for a given Category.
        public func fetchMeals(for category: Category) -> AnyPublisher<[Meal], Error> {
            mealsDBService.filterMeals(for: category)
        }
      
        /// Calls an ImageService to retrieve an Image for a given URL and content type -- Category or Meal.
        public func fetchImage(imageType: ImageService.ImageType) -> AnyPublisher<UIImage, Never> {
            imageService.fetchImage(for: imageType)
        }
        
        // MARK: - Core Data Methods
        
        /// Checks if Core Data has any CategoryMO's stored.
        public func coreDataHasData() -> Bool {
            let fetchRequest: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
            let count = try? coreDataStack.managedContext.count(for: fetchRequest)

            guard let categoryCount = count else { return false }
            
            return categoryCount > 0
        }
        
        /// Updates the appState using all CategoryMO's in Core Data.
        public func updateAppState() {
            let fetchRequest: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
 
            let sectionNameSort = NSSortDescriptor(key: #keyPath(CategoryMO.name), ascending: true)
            fetchRequest.sortDescriptors = [sectionNameSort]
            
            if let categories = try? coreDataStack.managedContext.fetch(fetchRequest) {
                appState.categories = categories.transformToCategories()
            }
        }
        
        /// Save a Category from the given index into the current view context.
        public func saveCategoryMO(at index: Int) {
            CategoryMO.save(
                category: appState.categories[index],
                intoViewContext: coreDataStack.managedContext)
        }
        
        /// Save all Meals from the given Category index into the current view context.
        public func saveMealMO(meals: [Meal], at index: Int) {
            for meal in meals {
                MealMO.save(
                    meal: meal,
                    in: appState.categories[index],
                    intoViewContext: coreDataStack.managedContext)
            }
        }
    }
}
