//
//  ImageService.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/14/21.
//

import Foundation
import Combine
import UIKit


/*
 // TODO: Create persistence to avoid API calls.
 */
protocol ImageServicePublisher {
    func fetchImage(from imageURL: URL) -> AnyPublisher<UIImage, Never>
}

final class ImageService: ImageServicePublisher {
    
    public func fetchImage(from imageURL: URL) -> AnyPublisher<UIImage, Never> {
        let request = URLRequest(url: imageURL)
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap({ (data, _) in
                guard let image = UIImage(data: data) else {
                    return UIImage()
                }
                return image
            })
            .replaceError(with: UIImage())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
