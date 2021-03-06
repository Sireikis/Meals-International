//
//  Category.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Foundation


public struct Category: Decodable {
    
    let name: String
    let id: String
    
    let imageID: URL?
    let description: String
    
    var meals = [Meal]()
}

extension Category {
    
    enum CodingKeys: String, CodingKey {
        case name = "strCategory"
        case id = "idCategory"
        case imageID = "strCategoryThumb"
        case description = "strCategoryDescription"
    }
}

extension Category: Equatable {
    
    public static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Mock

extension Category {
    
    static let mockCategory = Category(
        name: "Mock Chicken",
        id: "-1",
        imageID: nil,
        description: "Tastes like everything.",
        meals: [Meal.mockMeal])
}
