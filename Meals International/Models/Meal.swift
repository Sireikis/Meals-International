//
//  Meal.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Foundation


public struct Meal: Decodable {
    
    let name: String
    let id: Int
    
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

// MARK: - Decoding Strategy

extension Meal {
    /// Decoding strategy for Meal.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        let idString = try container.decode(String.self, forKey: .id)
        self.id = Int(idString) ?? 0
        
        self.imageID = try container.decode(URL.self, forKey: .imageID)
        self.mealDetails = nil
    }
}


// MARK: - Mock

extension Meal {
    
    static let mockMeal = Meal(
        name: "Loading",
        id: 0,
        imageID: nil,
        mealDetails: nil)
}