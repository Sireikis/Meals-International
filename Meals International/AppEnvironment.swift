//
//  AppEnvironment.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/16/21.
//

import Foundation


struct AppEnvironment {
    
    let container: DIContainer
}

extension AppEnvironment {
    
    static func bootstrap() -> AppEnvironment {
        let appState = AppState()
        
        let coreDataStack = CoreDataStack(modelName: "db_model_v1")
        let services = configureServices()
        let diContainer = DIContainer(appState: appState, services: services, coreDataStack: coreDataStack)
        
        return AppEnvironment(container: diContainer)
    }
    
    private static func configureServices() -> DIContainer.Services {
        let mealsDBService = TheMealsDBService()
        let imageService = ImageService()
        
        return .init(mealsDBService: mealsDBService, imageService: imageService)
    }
}
