//
//  AnyCodingKey.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Foundation


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
