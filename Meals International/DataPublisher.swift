//
//  DataPublisher.swift
//  Meals International
//
//  Created by Ignas Sireikis on 11/26/21.
//

import Combine
import Foundation


class DataPublisher {
    
    typealias Response = (data: Data, response: URLResponse)
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func getMealsPublisher(for category: Category) -> AnyPublisher<Response, URLError> {
        let url = TheMealsDBAPI.filterURL(for: category)
        
        let publisher = session
            .dataTaskPublisher(for: url)
            .eraseToAnyPublisher()
        
        return publisher
    }
}
