//
//  DIContainer.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/16/21.
//

import Foundation


struct DIContainer {
    
    let appState: AppState
    let services: Services
    
    init(appState: AppState, services: DIContainer.Services) {
        self.appState = appState
        self.services = services
    }
}
