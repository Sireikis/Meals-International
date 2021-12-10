//
//  MealDetails.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Foundation


struct MealDetails: Decodable {
    
    let name: String
    let id: String
    let category: String
    let area: String
    
    let instructions: String
    //let youTubeLink: URL?
    
    let ingredients: [String]
    
    //let source: URL?
}

extension MealDetails {
    
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case id = "idMeal"
        case category = "strCategory"
        case area = "strArea"
        
        case instructions = "strInstructions"
        //case youTubeLink = "strYoutube"
        
        //case source = "strSource"
    }
}

extension MealDetails {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(String.self, forKey: .id)
        self.category = try container.decode(String.self, forKey: .category)
        self.area = try container.decode(String.self, forKey: .area)
        
        self.instructions = try container.decode(String.self, forKey: .instructions)
   
        /*
         do {
             // Sets default value if nil
             if let youTubeLink = try container.decodeIfPresent(URL.self, forKey: .youTubeLink) {
                 self.youTubeLink = youTubeLink
             } else {
                 self.youTubeLink = nil
             }
         } catch {
             // Sets default value if error
             self.youTubeLink = nil
         }
         
         do {
             // Sets default value if nil
             if let source = try container.decodeIfPresent(URL.self, forKey: .source) {
                 self.source = source
             } else {
                 self.source = nil
             }
         } catch {
             // Sets default value if error
             self.source = nil
         }
         */
        
        // Composing Ingredients and Measurements (1-20)
        let ingredientsContainer = try decoder.container(keyedBy: AnyCodingKey.self)
        
        var ingredients = [String]()
        for i in 1...20 {
            guard let measurementKey = AnyCodingKey(stringValue: "strMeasure\(i)"),
                  let ingredientsKey = AnyCodingKey(stringValue: "strIngredient\(i)")
            else {
                ingredients.append("")
                continue
            }
            
            guard let measurement = try ingredientsContainer.decodeIfPresent(String.self, forKey: measurementKey),
                  let ingredient = try ingredientsContainer.decodeIfPresent(String.self, forKey: ingredientsKey)
            else {
                ingredients.append("")
                continue
            }
            
            if measurement.rangeOfCharacter(from: .alphanumerics) == nil {
                //measurement.append("")
                ingredients.append("") // Why is this here again?
                continue
            }
            
            if ingredient.rangeOfCharacter(from: .alphanumerics) == nil {
                ingredients.append("")
                continue
            }
            
            ingredients.append(measurement + " " + ingredient)
        }
        
        self.ingredients = ingredients
    }
}

struct AnyCodingKey: CodingKey {
    let stringValue: String
    let intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }
}

/*
 struct MealDetails: Codable {
     
     let name: String
     let id: String
     let category: String
     let area: String
     
     let instructions: String
     let youTubeLink: URL?
     
     let ingredients: [String]
     
     let source: URL?
     
     enum CodingKeys: String, CodingKey {
         
         case name = "strMeal"
         case id = "idMeal"
         case category = "strCategory"
         case area = "strArea"
         
         case instructions = "strInstructions"
         case youTubeLink = "strYoutube"
         
         case source = "strSource"
     }
     
 }
 */
