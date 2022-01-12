//
//  DetailViewModel.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/14/21.
//

import Combine
import CoreData
import Foundation
import UIKit


extension DetailViewController {
    
    final class ViewModel: ObservableObject {
        
        var appState: AppState

        let container: DIContainer
        
        private static let decoder = JSONDecoder()
        private let mealsDBService: APIServiceDataPublisher
        private let imageService: ImageServicePublisher
        private let coreDataStack: CoreDataStack
        
        init(container: DIContainer) {
            self.container = container
            self.mealsDBService = container.services.mealsDBService
            self.imageService = container.services.imageService
            self.coreDataStack = container.coreDataStack
            
            self.appState = container.appState
        }
        
        // MARK: - Model Manipulation
        
        /// Updates the appState's MealDetails at a specific index.
        public func updateModel(mealDetails: MealDetails, at indexPath: IndexPath) {
            appState.categories[indexPath.section].meals[indexPath.row].mealDetails = mealDetails
        }
        
        /// Retrieves a Meal from a specific index.
        public func getMeal(at indexPath: IndexPath) -> Meal {
            appState.categories[indexPath.section].meals[indexPath.row]
        }
        
        /// Retrieves MealDetails from a specific index.
        public func getMealDetails(at indexPath: IndexPath) -> MealDetails? {
            appState.categories[indexPath.section].meals[indexPath.row].mealDetails
        }
        
        // MARK: - API Calls
        
        /// Calls TheMealsDB API to retrieve MealDetails for a given Meal.
        public func fetchMealDetails(for meal: Meal) -> AnyPublisher<MealDetails, Error> {
            mealsDBService.lookUp(meal: meal)
        }
        
        /// Calls an ImageService to retrieve an Image for a given URL and content type -- Category or Meal.
        public func fetchImage(imageType: ImageService.ImageType) -> AnyPublisher<UIImage, Never> {
            imageService.fetchImage(for: imageType)
        }
        
        // MARK: - Core Data Methods
        
        /// Checks if Core Data has any CategoryMO's stored.
        public func coreDataHasData(for meal: Meal) -> Bool {
            let fetchRequest: NSFetchRequest<MealMO> = MealMO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id = %@", meal.id)
            
            if let results = try? coreDataStack.managedContext.fetch(fetchRequest),
               let existingMeal = results.first,
               let mealDetails = existingMeal.mealDetails?.transformToMealDetails() {
                return mealDetails != MealDetails.mockMealDetails
            }
            
            return false
        }
        
        /// Updates the appState using the MealDetailsMO in Core Data.
        /// Assumes data is already in Core Data
        public func updateAppState(for indexPath: IndexPath) {
            let fetchRequest = fetchMealRequest(at: indexPath)

            if let meal = try? coreDataStack.managedContext.fetch(fetchRequest),
               let existing = meal.first,
               let mealDetailsMO = existing.mealDetails {
                appState.categories[indexPath.section].meals[indexPath.row].mealDetails = mealDetailsMO.transformToMealDetails()
            }
        }
        
        /// Generates a MealMO NSFetchRequest from Core Data.
        private func fetchMealRequest(at indexPath: IndexPath) -> NSFetchRequest<MealMO> {
            let meal = getMeal(at: indexPath)
            
            let fetchRequest: NSFetchRequest<MealMO> = MealMO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id = %@", meal.id)
            
            return fetchRequest
        }
        
        /// Saves MealDetails at the given Meal index into the current view context.
        public func saveMealDetailsMO(at indexPath: IndexPath) {
            guard let mealDetails = getMealDetails(at: indexPath) else { return }
            let meal = getMeal(at: indexPath)
            
            MealDetailsMO.save(
                mealDetails: mealDetails,
                in: meal,
                intoViewContext: coreDataStack.managedContext)
        }
    }
}
