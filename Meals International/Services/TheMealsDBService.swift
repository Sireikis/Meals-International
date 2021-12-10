//
//  TheMealsDBService.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Foundation
import Combine

/*
 TODO: Create custom errors enum and handle them.
 Q: Should this service return actual data objects? Or are we handling errors on the view by presenting something?
 */

class TheMealsDBService {
    /// Returns a publisher for the categories endpoint of TheMealsDB
    public func categories() -> AnyPublisher<Data, URLError> {
        URLSession.shared
            .dataTaskPublisher(for: TheMealsDBEndPoint.categories.url)
            .map(\.data)
            .eraseToAnyPublisher()
    }
    
    /// Returns a publisher for the filter endpoint of TheMealsDB
    public func filterMeals(for category: Category) -> AnyPublisher<Data, URLError> {
        URLSession.shared
            .dataTaskPublisher(for: TheMealsDBEndPoint.filter(name: category.name).url)
            .map(\.data)
            .eraseToAnyPublisher()
    }
    
    /// Returns a publisher for the lookUp endpoint of TheMealsDB
    public func lookUp(meal: Meal) -> AnyPublisher<Data, URLError> {
        URLSession.shared
            .dataTaskPublisher(for: TheMealsDBEndPoint.lookUp(id: meal.id).url)
            .map(\.data)
            .eraseToAnyPublisher()
    }
}

extension TheMealsDBService {
    /// Creates URLs for TheMealsDB endpoints
    enum TheMealsDBEndPoint {
        
        private static let baseURL = URL(string: "https://www.themealdb.com/api/json/v1/\(apiKey)/")!
        private static let apiKey = "1"
        
        /// Returns a list of all Categories
        case categories
        /// Returns a list of all meals in the given Category
        case filter(name: String)
        /// Returns details about a specific meal
        case lookUp(id: Int)

        /// Returns URL for a given TheMealsDB endpoint
        var url: URL {
            switch self {
            case .categories:
                return TheMealsDBEndPoint.baseURL.appendingPathComponent("categories.php")
            case .filter(let name):
                return TheMealsDBEndPoint.baseURL.appendingPathComponent("\(name)/filter.php")
            case .lookUp(let id):
                return TheMealsDBEndPoint.baseURL.appendingPathComponent("\(id)/lookup.php")
            }
        }
    }
}
