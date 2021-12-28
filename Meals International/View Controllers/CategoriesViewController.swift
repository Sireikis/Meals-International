//
//  CategoriesViewController.swift
//  Meals International
//
//  Created by Ignas Sireikis on 11/26/21.
//

import Combine
import CoreData
import UIKit


/*
 // TODO: Need to add Tests!
 
 // TODO: How can we handle errors when fetching a meal?
 -Multiple requests are made, so we could potentially be making multiple calls to show a UIAlert.
 
 // TODO: Create loading indicator instead of showing Mock?
 
 // TODO: The following cannot be done because fetchMeals is called 14 times no matter what. Once for each category.
 #warning("Put the reload data in a better place or implement collect!")
 -We receive ALL the categories and Meals for a category in a single batch, but the way we wrote the code means we need
 to fetch once for each category.
 
 // TODO: Should Core Data checks be done here or in a view Model? Or in something separate?
 
 // TODO: FetchMeals isn't handling errors.
 
 // TODO: Current image fetching code needs error handling (some default image?) and should pull from saved images.
 */
class CategoriesViewController: UIViewController {
    
    var viewModel: CategoriesViewController.ViewModel!
    
    @IBOutlet var tableView: UITableView!
    
    private let tableViewDataSource = CategoriesDataSource()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = tableViewDataSource
        tableViewDataSource.viewModel = viewModel
        
        tableView.delegate = self
        
        fetchCategoriesAndMealsIfNeeded()
    }
    
    // MARK: - API Calls
    
    /// Checks if Core Data has any CategoryMO data, if it does it loads it and updates appState.
    /// If there is no Core Data, performs a fetch request and saves that data.
    private func fetchCategoriesAndMealsIfNeeded() {
        if viewModel.coreDataHasData() {
            viewModel.updateAppState()
        } else {
            print("CategoriesViewController - No Core Data. Fetched Categories and Meals.")
            fetchCategoriesAndMeals()
        }
    }
    
    /// Calls the API for Category data that will be used to update the current appState.
    /// After the call succeeds, calls the API to fetch all Meals.
    /// If an error is encountered, a UIAlert is presented.
    private func fetchCategoriesAndMeals() {
        viewModel.fetchCategories()
            .mapError { [unowned self] error -> TheMealsDBService.MealsError in
                switch error {
                case is URLError:
                    showAlert("Network Error.", description: "Error Accessing Server.")
                    return .network
                case is DecodingError:
                    showAlert("Decoding Error.", description: "Error Parsing.")
                    return .parsing
                default:
                    showAlert("Unknown Error.", description: "")
                    return error as? TheMealsDBService.MealsError ?? .unknown
                }
            }
            .replaceError(with: [Category.mockCategory])
            .sink(receiveValue: { [unowned self] categories in
                print("CategoriesViewController - fetchCategoriesAndMeals: Fetching Categories")
                viewModel.appState.categories = categories
                
                fetchMeals()
            })
            .store(in: &subscriptions)
    }
    
    /// Calls the API for Meal data for every Category and updates the current appState.
    /// Saves the current appState data into Core Data then reloads the tableView.
    private func fetchMeals() {
        for (index, category) in viewModel.appState.categories.enumerated() {
            viewModel.fetchMeals(for: category)
                .sink { completion in
                    print("Meals fetch Completion: \(completion)")
                } receiveValue: { [unowned self] meals in
                    print("CategoriesViewController - fetchMeals: Fetching Meals")

                    viewModel.updateModel(meals: meals, at: index)
             
                    viewModel.saveCategoryMO(at: index)
                    viewModel.saveMealMO(meals: meals, at: index)
                    
                    tableView.reloadData()
                }
                .store(in: &subscriptions)
        }
    }
    
    // MARK: - Internal
    
    /// Presents a UIAlert with the given title and description.
    private func showAlert(_ title: String, description: String? = nil) {
        alert(title: title, text: description)
            .sink(receiveValue: { _ in })
            .store(in: &subscriptions)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showMealDetails":
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            let row = indexPath.row
            let section = indexPath.section
      
            let meal = viewModel.appState.categories[section].meals[row]
            
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.meal = meal
            detailViewController.indexPath = indexPath
            detailViewController.viewModel = .init(container: viewModel.container)
            
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}

// MARK: - TableViewController Delegate Methods

extension CategoriesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderLabelView = UIView()
        sectionHeaderLabelView.backgroundColor = .white
        
        let sectionHeaderImageView = UIImageView()
        
        let category = viewModel.appState.categories[section]
   
#warning("Need error handling, some stock image shown instead? Maybe handled by ImageService?")
        if let imageURL = category.imageID {
            viewModel.fetchImage(imageType: .category(imageURL))
                .sink { completion in
                    // Error handling here
                    print("Image header completion: \(completion)")
                } receiveValue: { image in
                    print("Fetched Section Header Image")
                    sectionHeaderImageView.image = image
                }
                .store(in: &subscriptions)
        } else {
            print("No image")
            //sectionHeaderImageView.image = UIImage()
        }
        
        sectionHeaderImageView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        sectionHeaderLabelView.addSubview(sectionHeaderImageView)
        
        let sectionHeaderLabel = UILabel()
        sectionHeaderLabel.text = viewModel.appState.categories[section].name
        sectionHeaderLabel.textColor = .black
        sectionHeaderLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        sectionHeaderLabel.frame = CGRect(x: 53, y: 5, width: 250, height: 44)
        sectionHeaderLabelView.addSubview(sectionHeaderLabel)
        
        return sectionHeaderLabelView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
