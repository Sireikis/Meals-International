//
//  AppState.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/16/21.
//

import Foundation


class AppState: ObservableObject {
    
    @Published var categories: [Category] = [Category.mockCategory]
}
