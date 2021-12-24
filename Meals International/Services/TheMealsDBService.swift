//
//  TheMealsDBService.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Combine
import Foundation


/*
 // TODO: Re-evaluate error handling after publisher changes
 */
public protocol TheMealsDBServiceDataPublisher {
    func categories() -> AnyPublisher<[Category], Error>
    func filterMeals(for category: Category) -> AnyPublisher<[Meal], Error>
    func lookUp(meal: Meal) -> AnyPublisher<MealDetails, Error>
}

public final class TheMealsDBService: TheMealsDBServiceDataPublisher {
    
    private static let decoder = JSONDecoder()
    
    /// Returns a publisher for the categories endpoint of TheMealsDB
    public func categories() -> AnyPublisher<[Category], Error> {
        URLSession.shared
            .dataTaskPublisher(for: TheMealsDBEndPoint.categories.url)
            .retry(1)
            .map(\.data)
            .decode(type: CategoriesResponse.self, decoder: Self.decoder)
            .map(\.categories)
            .map({ $0.sorted { $0.name < $1.name } })
            .mapError { error -> TheMealsDBService.MealsError in
                switch error {
                case is URLError:
                    return .network
                case is DecodingError:
                    return .parsing
                default:
                    return error as? TheMealsDBService.MealsError ?? .unknown
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Returns a publisher for the filter endpoint of TheMealsDB
    public func filterMeals(for category: Category) -> AnyPublisher<[Meal], Error> {
        URLSession.shared
            .dataTaskPublisher(for: TheMealsDBEndPoint.filter(name: category.name).url)
            .retry(1)
            .map(\.data)
            .decode(type: FilterResponse.self, decoder: Self.decoder)
            .map(\.meals)
            .map({ $0.sorted { $0.name < $1.name } })
            .mapError { error -> TheMealsDBService.MealsError in
                switch error {
                case is URLError:
                    return .network
                case is DecodingError:
                    return .parsing
                default:
                    return error as? TheMealsDBService.MealsError ?? .unknown
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Returns a publisher for the lookUp endpoint of TheMealsDB
    public func lookUp(meal: Meal) -> AnyPublisher<MealDetails, Error> {
        URLSession.shared
            .dataTaskPublisher(for: TheMealsDBEndPoint.lookUp(id: meal.id).url)
            .retry(1)
            .map(\.data)
            .decode(type: LookUpResponse.self, decoder: Self.decoder)
            .map(\.mealDetails[0])
            .mapError { error -> TheMealsDBService.MealsError in
                switch error {
                case is URLError:
                    return .network
                case is DecodingError:
                    return .parsing
                default:
                    return error as? TheMealsDBService.MealsError ?? .unknown
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension TheMealsDBService {
    /// Creates URLs for TheMealsDB endpoints
    private enum TheMealsDBEndPoint {
        
        private enum EndPoint: String {
            
            case categories = "categories.php"
            case filter = "filter.php"
            case lookUp = "lookup.php"
        }
        
        private static let baseURL = URL(string: "https://www.themealdb.com/api/json/v1/\(apiKey)/")!
        private static let apiKey = "1"
        
        /// Returns a list of all Categories
        case categories
        /// Returns a list of all meals in the given Category
        case filter(name: String)
        /// Returns details about a specific meal
        case lookUp(id: String)

        /// Returns URL for a given TheMealsDB endpoint
        public var url: URL {
            switch self {
            case .categories:
                return createURL(for: .categories, parameters: [:])
            case .filter(let name):
                return createURL(for: .filter, parameters: ["c" : name])
            case .lookUp(let id):
                return createURL(for: .lookUp, parameters: ["i" : id])
            }
        }
        
        private func createURL(for endPoint: EndPoint, parameters: [String: String]) -> URL {
            var components = URLComponents(string: TheMealsDBEndPoint.baseURL.absoluteString + endPoint.rawValue)!
            components.setQueryItems(with: parameters)
            
            return components.url!
        }
    }
}

extension TheMealsDBService {
    
    public enum MealsError: Error, CustomStringConvertible {
        
        case network
        case parsing
        case unknown
        
        public var description: String {
            switch self {
            case .network:
                return "Request to API Server failed."
            case .parsing:
                return "Failed parsing response from server."
            case .unknown:
                return "An unknown error occurred."
            }
        }
    }
}

extension TheMealsDBService {
    
    private struct CategoriesResponse: Decodable {

        let categories: [Category]
    }
    
    private struct FilterResponse: Decodable {
        
        let meals: [Meal]
    }
    
    private struct LookUpResponse: Decodable {
        
        let mealDetails: [MealDetails]
        
        enum CodingKeys: String, CodingKey {
            case mealDetails = "meals"
        }
    }
}
