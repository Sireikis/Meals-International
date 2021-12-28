//
//  DetailViewModel.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/14/21.
//

import Combine
import Foundation
import UIKit

#warning("Do I need CoreData here? Will I pass it to ImageService as a Parameter or compose them?")
extension DetailViewController {
    
    final class ViewModel: ObservableObject {
        
        var appState: AppState

        let container: DIContainer
        
        private static let decoder = JSONDecoder()
        private let mealsDBService: TheMealsDBServiceDataPublisher
        private let imageService: ImageServicePublisher
       // private let coreDataStack: CoreDataStack
        
        init(container: DIContainer) {
            self.container = container
            self.mealsDBService = container.services.mealsDBService
            self.imageService = container.services.imageService
            //self.coreDataStack = container.coreDataStack
            
            self.appState = container.appState
        }
        
        // MARK: - Model Manipulation
        
        public func update(mealDetails: MealDetails, at indexPath: IndexPath) {
            appState.categories[indexPath.section].meals[indexPath.row].mealDetails = mealDetails
        }
        
        // MARK: - API Calls
        
        public func fetchMealDetails(for meal: Meal) -> AnyPublisher<MealDetails, Error> {
            mealsDBService.lookUp(meal: meal)
        }
        
        public func fetchImage(from imageURL: URL) -> AnyPublisher<UIImage, Never> {
            imageService.fetchImage(from: imageURL)
        }
        
        
    }
}
