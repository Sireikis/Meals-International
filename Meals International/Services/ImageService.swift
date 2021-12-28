//
//  ImageService.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/14/21.
//

import Combine
import Foundation
import UIKit
import CoreData


/*
 // TODO: There is a mismatch between the cell's images and the actual image shown. probably has to do with reused cells.
 -This weird popping in and out happens. Does seem to happen on device as well, rarely. Might be dependent on available
 -resources at the point in time when the request is made.
 
 // TODO: Make fetches Asynchronous so they don't block the main thread?
 */
protocol ImageServicePublisher {
    func fetchImage(for imageType: ImageService.ImageType) -> AnyPublisher<UIImage, Never>
}

final class ImageService: ImageServicePublisher {
    
    enum ImageType {
        case category(URL)
        case meal(URL)
        
        var url: URL {
            switch self {
            case .category(let url): return url
            case .meal(let url): return url
            }
        }
    }
    
    enum ImageError: Error {
        case coreDataMissingData
    }
    
    var cache: [URL: UIImage] = [:]
    var coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    #warning("This method might benefit from some batch Update implementation. Maybe store images retreived, after some amount batch update?")
    /// Check if image is already in cache, return if so.
    /// Otherwise, create a fetch request, retrieve that image, and save it into the cache.
    ///
    /// 1) Check cache first
    ///     - Return Image
    ///
    /// 2) Check Core Data
    ///     - Store in Cache
    ///     - Return image
    ///
    /// 3) Perform API Fetch Request
    ///     - Store in Core Data
    ///     - Store in Cache
    ///     - Return Image
    public func fetchImage(for imageType: ImageType) -> AnyPublisher<UIImage, Never> {
        let imageURL = imageType.url
        // 1) Check cache for image
        if let image = cache[imageURL] {
            return Future<UIImage, Never> { promise in
                print("Used Cache for: \(imageURL)")
                return promise(.success(image))
            }
            .eraseToAnyPublisher()
        }
        
        // 2) Check Core Data for photoData, place image into cache and return image
        let coreDataResult = updateCacheUsingCoreData(for: imageType)
        switch coreDataResult {
        case .success(let result):
            return result
        case .failure(let error):
            print(error)
        }

        // 3) Fetch image if not in cache or Core Data, store in cache and Core Data
        let request = URLRequest(url: imageURL)
        
        let publisher = URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap({ [unowned self] (data, _) in
                guard let image = UIImage(data: data) else {
                    return UIImage()
                }
    
                // Store in cache
                print("Fetched, Then Stored in Cache: \(imageURL)")
                let compressedImage = compressImage(image)
                cache[imageURL] = compressedImage
                
                // Save photoData into Core Data
                saveIntoCoreData(compressedImage, for: imageType)
     
                coreDataStack.saveContext()
                
                return compressedImage
            })
            .replaceError(with: UIImage())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    // MARK: - Internal
    
    /// Reduces image quality to save space.
    private func compressImage(_ image: UIImage) -> UIImage {
        let compressedImage = image.jpegData(compressionQuality: 0.01)
        
        if let data = compressedImage, let lowResImage = UIImage(data: data) {
            return lowResImage
        } else {
            // Failed to compress
            return image
        }
    }
    
    // MARK: - Helper Methods
    
    /// Returns a fetch request that finds the CategoryMO with the given url
    private func imageIDCategoryMOFetchRequest(for url: URL) -> NSFetchRequest<CategoryMO> {
        let fetchRequest: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(CategoryMO.imageID), url])
        
        return fetchRequest
    }
    /// Returns a fetch request that finds the MealMO with the given url
    private func imageIDMealMOFetchRequest(for url: URL) -> NSFetchRequest<MealMO> {
        let fetchRequest: NSFetchRequest<MealMO> = MealMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(MealMO.imageID), url])
        
        return fetchRequest
    }

    /// Attempts to retrieve an Image from Core Data if available and saves it to cache. Return a Publisher containing that Image.
    private func updateCacheUsingCoreData(for imageType: ImageType) -> Result<AnyPublisher<UIImage, Never>, ImageError> {
        switch imageType {
        case .category(let url):
            print("Entered Core Data Category Fetch")
            let fetchRequest = imageIDCategoryMOFetchRequest(for: url)
            
            // Attempt to retrieve the image from Core Data
            if let result = try? coreDataStack.managedContext.fetch(fetchRequest),
               let existing = result.first,
               let imageData = existing.photoData,
               let image = UIImage(data: imageData) {
                // Place image into the cache
                cache[url] = image
                print("Pulling Image from CategoryMO")
                
                return .success(Future<UIImage, Never> { promise in
                    return promise(.success(image))
                }
                .eraseToAnyPublisher())
            }
        case .meal(let url):
            print("Entered Core Data Meal Fetch")
            let fetchRequest = imageIDMealMOFetchRequest(for: url)
   
            if let result = try? coreDataStack.managedContext.fetch(fetchRequest),
               let existing = result.first,
               let imageData = existing.photoData,
               let image = UIImage(data: imageData) {
                // Place image into the cache
                cache[url] = image
                print("Pulling Image from CategoryMO")
                
                return .success(Future<UIImage, Never> { promise in
                    return promise(.success(image))
                }
                .eraseToAnyPublisher())
            }
        }
        
        return .failure(ImageError.coreDataMissingData)
    }
    
    /// Saves the given compressed image into Core Data.
    private func saveIntoCoreData(_ compressedImage: UIImage, for imageType: ImageType) {
        switch imageType {
        case .category(let url):
            print("Fetched Category Image from API, Saving to Core Data")
            let fetchRequest = imageIDCategoryMOFetchRequest(for: url)
            
            if let result = try? coreDataStack.managedContext.fetch(fetchRequest),
               let existing = result.first {
                print("Successfully saved to Category Core Data")
                existing.photoData = compressedImage.pngData()
            }
            
        case .meal(let url):
            print("Fetched Meal Image from API, Saving to Core Data")
            let fetchRequest = imageIDMealMOFetchRequest(for: url)
            
            if let result = try? coreDataStack.managedContext.fetch(fetchRequest),
               let existing = result.first {
                print("Successfully saved to Meal Core Data")
                existing.photoData = compressedImage.pngData()
            }
        }
    }
}
