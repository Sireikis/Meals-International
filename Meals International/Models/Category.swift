//
//  Category.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Foundation

/*
 TODO: How can I have a model and a model object have the same name?
 */
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

extension Category {
    
    init?(categoryMO: CategoryMO) {
        
        guard let name = categoryMO.name else { return nil }
        guard let id = categoryMO.id else { return nil }
        guard let meals = categoryMO.meals?.array as? [Meal] else { return nil }
        
        self.init(
            name: name,
            id: id,
            imageID: categoryMO.imageID,
            description: categoryMO.description,
            meals: meals)
    }
}

// MARK: - Mock

extension Category {
    
    static let mockCategory = Category(
        name: "Chicken",
        id: "1",
        imageID: nil,
        description: "Tastes like everything.",
        meals: [Meal.mockMeal])
}
