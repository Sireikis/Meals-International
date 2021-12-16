//
//  CategoriesViewController.swift
//  Meals International
//
//  Created by Ignas Sireikis on 11/26/21.
//

import Combine
import UIKit


/*
 // TODO: Need to add Persistence and Tests!
 
 // TODO: How can we handle errors when fetching a meal?
 -Multiple requests are made, so we could potentially be making multiple calls to show a UIAlert.
 
 // TODO: Create loading indicator instead of showing Mock?
 
 
 // TODO: The following cannot be done because fetchMeals is called 14 times no matter what. Once for each category.
 #warning("Put the reload data in a better place or implement collect!")
 -We receive ALL the categories and Meals for a category in a single batch, but the way we wrote the code means we need
 to fetch once for each category.
 */
class CategoriesViewController: UIViewController, UITableViewDelegate {
    
    var viewModel: CategoriesViewController.ViewModel!
    
    @IBOutlet var tableView: UITableView!
    
    private let tableViewDataSource = CategoriesDataSource()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = tableViewDataSource
        tableViewDataSource.viewModel = viewModel
        
        tableView.delegate = self
        
        fetchCategoriesAndMeals()
    }
    
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
                viewModel.appState.categories = categories
                fetchMeals()
            })
            .store(in: &subscriptions)
    }
    
    private func fetchMeals() {
        for (index, category) in viewModel.appState.categories.enumerated() {
            viewModel.fetchMeals(for: category)
//                .mapError { [unowned self] error -> TheMealsDBService.Error in
//                    switch error {
//                    case is URLError:
//                        showAlert("Network Error.", description: "Error Accessing Server.")
//                        return .network
//                    case is DecodingError:
//                        showAlert("Decoding Error.", description: "Error Parsing.")
//                        return .parsing
//                    default:
//                        showAlert("Unknown Error.", description: "")
//                        return error as? TheMealsDBService.Error ?? .unknown
//                    }
//                }
                //.delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
                .sink { completion in
                    print("Meals fetch Completion: \(completion)")
                } receiveValue: { [unowned self] meals in
                    viewModel.appState.categories[index].meals = meals
                    tableView.reloadData()
                }
                .store(in: &subscriptions)
        }
    }
    
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

extension CategoriesViewController {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderLabelView = UIView()
        sectionHeaderLabelView.backgroundColor = .white
        
        let sectionHeaderImageView = UIImageView()
   
        if let imageURL = viewModel.appState.categories[section].imageID {
            viewModel.fetchImage(from: imageURL)
                .sink { completion in
                    // Error handling here
                    print("Image header completion: \(completion)")
                } receiveValue: { image in
                    sectionHeaderImageView.image = image
                }
                .store(in: &subscriptions)
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
}
