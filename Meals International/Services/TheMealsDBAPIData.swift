//
//  TheMealsDBAPIData.swift
//  Meals International
//
//  Created by Ignas Sireikis on 11/26/21.
//

import Foundation


//protocol APIData {
//    func getData(fromJSON data: Data) -> Result<Any, Error>
//}

// MARK: - Category Data

class TheMealsDBCategoryData {
    
    static func categories(fromJSON data: Data) -> Result<[Category], Error> {
        do {
            let decoder = JSONDecoder()
        
            let categoriesResponse = try decoder.decode(CategoriesResponse.self, from: data)
            let categories = categoriesResponse.categories
                .sorted(by: { $0.name < $1.name })
//                .map { APICategory in
//                    Category(
//                        name: APICategory.name,
//                        id: APICategory.id,
//                        imageID: URL(string: APICategory.imageID),
//                        description: APICategory.description)
//                }
            return .success(categories)
        } catch {
            return .failure(error)
        }
    }
}

extension TheMealsDBCategoryData {
    
    struct CategoriesResponse: Decodable {

        let categories: [Category]
    }
}

// MARK: - Filter Data

class TheMealsDBFilterData {
    
    static func filter(fromJSON data: Data) -> Result<[Meal], Error> {
        do {
            let decoder = JSONDecoder()
            
            let filterResponse = try decoder.decode(FilterResponse.self, from: data)
            let meals = filterResponse.meals
                .sorted(by: { $0.name < $1.name })
//                .map { APIMeal in
//                    Meal(
//                        name: APIMeal.name,
//                        id: Int(APIMeal.id) ?? 0,
//                        imageID: URL(string: APIMeal.imageID),
//                        mealDetails: nil)
//                }
            
            return .success(meals)
        } catch {
            return .failure(error)
        }
    }
}

extension TheMealsDBFilterData {
    
    struct FilterResponse: Decodable {
        
        let meals: [Meal]
    }
}

// MARK: - Filter Data

class TheMealsDBLookUpData {
    // Decode Data and return MealDetails
    static func lookUp(fromJSON data: Data) -> Result<MealDetails, Error> {
        do {
            let decoder = JSONDecoder()
            
            let filterResponse = try decoder.decode(LookUpResponse.self, from: data)
            let mealDetails = filterResponse.mealDetails[0]

            return .success(mealDetails)
        } catch {
            print("API lookup error: \(error)")
            return .failure(error)
        }
    }
}

extension TheMealsDBLookUpData {
    
    struct LookUpResponse: Decodable {
        
        let mealDetails: [MealDetails]
        
        enum CodingKeys: String, CodingKey {
            case mealDetails = "meals"
        }
    }
}
