//
//  TheMealsDBAPI.swift
//  Meals International
//
//  Created by Ignas Sireikis on 11/26/21.
//

import Foundation

/// Creates URLs for TheMealsDB endpoints
struct TheMealsDBAPI {
    
    private enum EndPoint: String {
        
        case categories = "categories.php"
        case filter = "filter.php"
        case lookUp = "lookup.php"
    }

    private static let baseURLString = "https://www.themealdb.com/api/json/v1/1/"
    private static let apiKey = "1"
    
    /// Returns URL to retrieve header, footer, and image data for all Categories
    public static func categoriesURL() -> URL {
        return theMealsDBURL(endPoint: .categories, parameters: nil)
    }
    
    /// Returns URL to retrieve all Meal name and image data for a specific Category
    public static func filterURL(for category: Category) -> URL {
        let parameters = ["c" : category.name]
        return theMealsDBURL(endPoint: .filter, parameters: parameters)
    }
    
    /// Returns URL to retrieve MealDetails data for a specific Meal
    public static func lookUpURL(for meal: Meal) -> URL {
        let parameters = ["i": String(meal.id)]
        return theMealsDBURL(endPoint: .lookUp, parameters: parameters)
    }
    
    /// Assembles URL for various TheMealDB endpoints
    private static func theMealsDBURL(endPoint: EndPoint, parameters: [String:String]?) -> URL {
        var components = URLComponents(string: baseURLString + endPoint.rawValue)!
        var queryItems = [URLQueryItem]()
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
}

/*
 Much more lightweight endpoint than above.
 Unsure if additional parameter functionality is needed.
 */
enum TheMealsDBEndPoint {
    
    private static let baseURL = URL(string: "https://www.themealdb.com/api/json/v1/\(apiKey)/")!
    private static let apiKey = "1"
    
    case categories
    case filter(name: String)
    case lookUp(id: Int)

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
