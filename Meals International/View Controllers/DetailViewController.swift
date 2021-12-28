//
//  DetailViewController.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/13/21.
//

import Combine
import UIKit


class DetailViewController: UIViewController {
    
    var viewModel: DetailViewController.ViewModel!
    
    @IBOutlet var mealImage: UIImageView!
    @IBOutlet var mealTitle: UILabel!
    @IBOutlet var mealSubtitle: UILabel!
    
    @IBOutlet var mealIngredients: UILabel!
    @IBOutlet var mealIngredientsBox: UIView!
    
    @IBOutlet var mealInstructions: UILabel!
    @IBOutlet var mealInstructionsBox: UIView!
    
    var meal: Meal!
    var indexPath: IndexPath!
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        fetchMealDetails()
    }
    
    // MARK: - View Setup
    
    /// Configures view appearance
    private func configureView() {
        configureImage()
        configureIngredientsBox()
        configureInstructionsBox()
    }
    
    private func configureImage() {
        mealImage.layer.cornerRadius = mealImage.frame.height / 3
        mealImage.clipsToBounds = true
    }
    
    private func configureIngredientsBox() {
        mealIngredientsBox.roundedBoxWithBorderAndShadow()
    }
    
    private func configureInstructionsBox() {
        mealInstructionsBox.roundedBoxWithBorderAndShadow()
    }
    
    // MARK: - API Calls
    
    // I need comments here
#warning("I should save MealDetails into core data here!")
#warning("I should also check if Core Data has Meal Details before this method is called!")
    private func fetchMealDetails() {
        viewModel.fetchMealDetails(for: meal)
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

                viewModel.update(mealDetails: mealDetails, at: indexPath)
                
                meal.mealDetails = mealDetails
                
                if let imageURL = meal.imageID {
#warning("Need to update this to pull from Core Data saved Binary images before we fetch. Also need error handling.")
                    viewModel.fetchImage(from: imageURL)
                        .sink { image in
                            mealImage.image = image
                        }
                        .store(in: &subscriptions)
                }
                reset()
            })
            .store(in: &subscriptions)
    }
    
    // MARK: - Internal
    
    /// Presents a UIAlert with the given title and description.
    private func showAlert(_ title: String, description: String? = nil) {
        alert(title: title, text: description)
            .sink(receiveValue: { _ in })
            .store(in: &subscriptions)
    }
    
    /// Updates UI with current meal Info
    private func reset() {
        setTitle()
        setSubtitle()
        setIngredients()
        setInstructions()
    }
    
// MARK: - Helper Functions
    
    private func setTitle() {
        if let mealDetails = meal.mealDetails {
            mealTitle.text = mealDetails.name
        }
    }
    
    private func setSubtitle() {
        if let mealDetails = meal.mealDetails {
            let area = mealDetails.area
            let category = mealDetails.category
            
            if area.lowercased() == "unknown" {
                mealSubtitle.text = ""
            } else {
                let subtitle = "\(area) - \(category)"
                mealSubtitle.text = subtitle
            }
        }
    }
    
    private func setIngredients() {
        if let mealDetails = meal.mealDetails {
            let ingredientsList = mealDetails.ingredients
            
            var parsedIngredients = ""
            for ingredientsList in ingredientsList {
                parsedIngredients += ingredientsList + "\n"
            }
            
            mealIngredients.text = parsedIngredients
        }
    }
    
    private func setInstructions() {
        if let mealDetails = meal.mealDetails {
            mealInstructions.text = mealDetails.instructions
        }
    }
}
