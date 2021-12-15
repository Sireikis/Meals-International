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
        
        @Published var meal: Meal

        private static let decoder = JSONDecoder()
        private let mealsDBService: TheMealsDBServiceDataPublisher
        private let imageService: ImageServicePublisher
        
        public init(
            mealsDBService: TheMealsDBServiceDataPublisher = TheMealsDBService(),
            imageService: ImageServicePublisher = ImageService()
        ) {
            self.mealsDBService = mealsDBService
            self.imageService = imageService
            
            meal = Meal.mockMeal
            meal.mealDetails = MealDetails.mockMealDetails
        }
        
        public func fetchMealDetails(for meal: Meal) -> AnyPublisher<MealDetails, Error> {
            mealsDBService.lookUp(meal: meal)
        }
        
        public func fetchImage(from imageURL: URL) -> AnyPublisher<UIImage, Never> {
            imageService.fetchImage(from: imageURL)
        }
    }
}
