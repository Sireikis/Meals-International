//
//  Meal.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Foundation


public struct Meal: Decodable {
    
    let name: String
    let id: String
    
    let imageID: URL?

    var mealDetails: MealDetails?
}

extension Meal {
    
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case id = "idMeal"
        case imageID = "strMealThumb"
    }
}

extension Meal: Equatable {
    
    public static func == (lhs: Meal, rhs: Meal) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Decoding Strategy

extension Meal {
    /// Decoding strategy for Meal.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(String.self, forKey: .id)
        
        self.imageID = try container.decode(URL.self, forKey: .imageID)
        self.mealDetails = nil
    }
}


// MARK: - Mock

extension Meal {
    
    static let mockMeal = Meal(
        name: "Loading",
        id: "-1",
        imageID: nil,
        mealDetails: MealDetails.mockMealDetails)
}

