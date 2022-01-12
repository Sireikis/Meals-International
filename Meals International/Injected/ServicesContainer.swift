//
//  ServicesContainer.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/16/21.
//


extension DIContainer {
    
    struct Services {
        
        let mealsDBService: APIServiceDataPublisher
        let imageService: ImageServicePublisher
        
        init(mealsDBService: APIServiceDataPublisher, imageService: ImageServicePublisher) {
            self.mealsDBService = mealsDBService
            self.imageService = imageService
        }
    }
}
