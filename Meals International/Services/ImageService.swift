//
//  ImageService.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/14/21.
//

import Combine
import Foundation
import UIKit


/*
 // TODO: There is a mismatch between the cell's images and the actual image shown. probably has to do with reused cells.
 -This weird popping in and out happens. Doesnt happen on device though.
 */
protocol ImageServicePublisher {
    func fetchImage(from imageURL: URL) -> AnyPublisher<UIImage, Never>
}

final class ImageService: ImageServicePublisher {
    
    var cache: [URL: UIImage] = [:]
    
    public func fetchImage(from imageURL: URL) -> AnyPublisher<UIImage, Never> {
        // Check cache for image
        //print("FetchImage cache state: \(String(describing: cache[imageURL])), for URL: \(imageURL)")
        if let image = cache[imageURL] {
            return Future<UIImage, Never> { promise in
                print("Used Cache for: \(imageURL)")
                return promise(.success(image))
            }
            .eraseToAnyPublisher()
        }
       
        // Fetch image if not in cache
        let request = URLRequest(url: imageURL)
        
        let publisher = URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap({ [unowned self] (data, _) in
                guard let image = UIImage(data: data) else {
                    return UIImage()
                }
                // Store in cache
                print("Stored in Cache: \(imageURL)")
                cache[imageURL] = compressImage(image)
                
                return image
            })
            .replaceError(with: UIImage())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    // Reduces image quality to save space.
    func compressImage(_ image: UIImage) -> UIImage {
        let compressedImage = image.jpegData(compressionQuality: 0.01)
        
        if let data = compressedImage, let lowResImage = UIImage(data: data) {
            return lowResImage
        } else {
            // Failed to compress
            return image
        }
    }
}
