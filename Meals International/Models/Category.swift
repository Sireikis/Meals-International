//
//  Category.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Foundation


struct Category: Decodable {
    
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

/*
 struct MealsDBCategory: Decodable {
     
     let name: String
     let id: String
     
     let imageID: String // URL? PNG
     let description: String
     
     var meals = [Meal]()
     
     enum CodingKeys: String, CodingKey {
         case name = "strCategory"
         case id = "idCategory"
         case imageID = "strCategoryThumb"
         case description = "strCategoryDescription"
     }
 }
 */
