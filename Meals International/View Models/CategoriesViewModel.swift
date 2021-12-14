//
//  CategoriesViewModel.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Foundation
import Combine
import UIKit


/*
 // TODO: Standardize order of import statements alphabetically
 */
extension CategoriesViewController {
    
    final class ViewModel: ObservableObject {
        
        @Published var categories: [Category] = [Category.mockCategory]
        
        private static let decoder = JSONDecoder()
        private let mealsDBService: TheMealsDBServiceDataPublisher
        private let imageService: ImageServicePublisher
        
        public init(
            mealsDBService: TheMealsDBServiceDataPublisher = TheMealsDBService(),
            imageService: ImageServicePublisher = ImageService()
        ) {
            self.mealsDBService = mealsDBService
            self.imageService = imageService
        }
        
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
