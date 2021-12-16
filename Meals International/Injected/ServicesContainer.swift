//
//  ServicesContainer.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/16/21.
//


extension DIContainer {
    
    struct Services {
        
        let mealsDBService: TheMealsDBServiceDataPublisher
        let imageService: ImageServicePublisher
        
        init(mealsDBService: TheMealsDBServiceDataPublisher, imageService: ImageServicePublisher) {
            self.mealsDBService = mealsDBService
            self.imageService = imageService
        }
        
        // TODO: Create stubs for each service, for testing purposes?
//        static var stub: Self {
//            .init(
//                mealsDBService: TheMealsDBServiceDataPublisher(),
//                imageService: ImageServicePublisher())
//        }
    }
}
