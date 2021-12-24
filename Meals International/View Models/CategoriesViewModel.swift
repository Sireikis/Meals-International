//
//  CategoriesViewModel.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Combine
import Foundation
import UIKit


extension CategoriesViewController {
    
    final class ViewModel: ObservableObject {
        
        var appState: AppState
        
        let container: DIContainer
        
        private static let decoder = JSONDecoder()
        private let mealsDBService: TheMealsDBServiceDataPublisher
        private let imageService: ImageServicePublisher
        private let coreDataStack: CoreDataStack
        
        init(container: DIContainer) {
            self.container = container
            self.mealsDBService = container.services.mealsDBService
            self.imageService = container.services.imageService
            self.coreDataStack = container.coreDataStack
            
            self.appState = container.appState
        }
        
        #warning("Check if Core Data contains info first!")
        public func fetchCategories() -> AnyPublisher<[Category], Error> {
            mealsDBService.categories()
        }
        
        public func fetchMeals(for category: Category) -> AnyPublisher<[Meal], Error> {
            mealsDBService.filterMeals(for: category)
        }
        
        public func fetchImage(from imageURL: URL) -> AnyPublisher<UIImage, Never> {
            imageService.fetchImage(from: imageURL)
        }
    }
}
