//
//  DetailViewModel.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/14/21.
//

import Combine
import Foundation
import UIKit


extension DetailViewController {
    
    final class ViewModel: ObservableObject {
        
        var appState: AppState

        let container: DIContainer
        
        private static let decoder = JSONDecoder()
        private let mealsDBService: TheMealsDBServiceDataPublisher
        private let imageService: ImageServicePublisher
 
        
        init(container: DIContainer) {
            self.container = container
            self.mealsDBService = container.services.mealsDBService
            self.imageService = container.services.imageService
            
            self.appState = container.appState
        }
        
        public func fetchMealDetails(for meal: Meal) -> AnyPublisher<MealDetails, Error> {
            mealsDBService.lookUp(meal: meal)
        }
        
        public func fetchImage(from imageURL: URL) -> AnyPublisher<UIImage, Never> {
            imageService.fetchImage(from: imageURL)
        }
    }
}
