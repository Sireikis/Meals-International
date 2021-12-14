//
//  DetailViewController.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/13/21.
//

import UIKit
import Combine

/*
 Correct meal is passed to viewController, which passes to viewModel.
 */

/*
 // TODO: Refactor image loading
 // TODO: Refactor components creation in TheMealsDBService
 */
class DetailViewController: UIViewController {
    
    private var viewModel = ViewModel()
    
    @IBOutlet var mealImage: UIImageView!
    @IBOutlet var mealTitle: UILabel!
    
    var meal: Meal!
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
        configureImage()
        
        fetchMealDetails()
    }
    
    private func configureImage() {
        //mealImage.backgroundColor = .blue
//        mealImage.layer.borderWidth = 1
//        mealImage.layer.borderColor = UIColor.black.cgColor
        mealImage.layer.cornerRadius = mealImage.frame.height / 2
        mealImage.clipsToBounds = true
    }
    
    /// Links ViewModel's model data to dataSource
    private func setupDataSource() {
        viewModel.meal = meal
        
        viewModel.$meal
            .sink(receiveCompletion: { completion in
                print("DetailView Assign Completion: \(completion)")
            }, receiveValue: { [unowned self] meal in
                print("Controller Meal Received")
                self.meal = meal
                reset()
            })
            .store(in: &subscriptions)
    }
    
    private func fetchMealDetails() {
        viewModel.fetchMealDetails(for: viewModel.meal)
            .mapError { [unowned self] error -> TheMealsDBService.MealsError in
                switch error {
                case is URLError:
                    showAlert("Network Error.", description: "Error Accessing Server.")
                    return .network
                case is DecodingError:
                    print(error)
                    showAlert("Decoding Error.", description: "Error Parsing.")
                    return .parsing
                default:
                    showAlert("Unknown Error.", description: "")
                    return error as? TheMealsDBService.MealsError ?? .unknown
                }
            }
            .replaceError(with: MealDetails.mockMealDetails)
            .sink(receiveValue: { [unowned self] mealDetails in
                viewModel.meal.mealDetails = mealDetails
                if let imageURL = mealDetails.imageID {
                    viewModel.fetchImage(from: imageURL)
                        .sink { image in
                            mealImage.image = image
                        }
                        .store(in: &subscriptions)
                }
            })
            .store(in: &subscriptions)
    }
    
    private func showAlert(_ title: String, description: String? = nil) {
        alert(title: title, text: description)
            .sink(receiveValue: { _ in })
            .store(in: &subscriptions)
    }
    
    /// Updates UI with current meal Info
    private func reset() {
        mealTitle.text = meal.name
    }
}
