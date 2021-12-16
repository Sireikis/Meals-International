//
//  MealDetails.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Foundation


public struct MealDetails: Decodable {
    
    let name: String
    let id: String
    let category: String
    let area: String
    
    let instructions: String
    let ingredients: [String]
}

extension MealDetails {
    
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case id = "idMeal"
        case category = "strCategory"
        case area = "strArea"
        
        case instructions = "strInstructions"
    }
}

// MARK: - Decoding Strategy

extension MealDetails {
    /// Decoding strategy for MealDetails--parses measurements and ingredients into ingredients array.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(String.self, forKey: .id)
        self.category = try container.decode(String.self, forKey: .category)
        self.area = try container.decode(String.self, forKey: .area)
        
        self.instructions = try container.decode(String.self, forKey: .instructions)
        
        // Composing Ingredients and Measurements (1-20)
        let ingredientsContainer = try decoder.container(keyedBy: AnyCodingKey.self)
        
        var ingredients = [String]()
        
        for i in 1...20 {
            guard let measurementKey = AnyCodingKey(stringValue: "strMeasure\(i)"),
                  let ingredientsKey = AnyCodingKey(stringValue: "strIngredient\(i)")
            else {
                continue
            }
            
            guard let measurement = try ingredientsContainer.decodeIfPresent(String.self, forKey: measurementKey),
                  let ingredient = try ingredientsContainer.decodeIfPresent(String.self, forKey: ingredientsKey)
            else {
                continue
            }
            
            if measurement.rangeOfCharacter(from: .alphanumerics) == nil || ingredient.rangeOfCharacter(from: .alphanumerics) == nil {
                continue
            }
            
            ingredients.append(measurement + " " + ingredient)
        }
        
        self.ingredients = ingredients
    }
}

// MARK: - Mock

extension MealDetails {
    
    static let mockMealDetails = MealDetails(
        name: "Loading",
        id: "",
        category: "",
        area: "",
        instructions: "",
        ingredients: [""])
}
