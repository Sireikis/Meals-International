//
//  Meal.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Foundation


struct Meal: Decodable {
    
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

/*
 
 struct MealsDBMeal: Decodable {
     
     let name: String
     let id: String
     
     let imageID: String // URL? JPEG
     
     enum CodingKeys: String, CodingKey {
         case name = "strMeal"
         case id = "idMeal"
         case imageID = "strMealThumb"
     }
 }
 */
