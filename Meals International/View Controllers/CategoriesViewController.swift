//
//  CategoriesViewController.swift
//  Meals International
//
//  Created by Ignas Sireikis on 11/26/21.
//

import UIKit
import Combine

/*
 // TODO: Need to add Persistence and Tests!
 
 // TODO: How can we handle errors when fetching a meal?
 -Multiple requests are made, so we could potentially be making multiple calls to show a UIAlert.
 
 // TODO: Create loading indicator instead of showing Mock?
 
 // TODO: Currently the fetchImage API call is made everytime a new header is visible.
 -I need to store that info somewhere and make sure I'm pulling from the first before I make a call.
 
 */
class CategoriesViewController: UIViewController, UITableViewDelegate {
    
    private var viewModel = ViewModel()
    
    @IBOutlet var tableView: UITableView!
    
    let tableViewDataSource = CategoriesDataSource()
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = tableViewDataSource
        tableViewDataSource.categories = viewModel.categories
        
        tableView.delegate = self
        
        setupDataSource()
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
                viewModel.categories = categories
                fetchMeals()
            })
            .store(in: &subscriptions)
    }
    
    private func fetchMeals() {
        for (index, category) in viewModel.categories.enumerated() {
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
                .sink { completion in
                    print("Meals fetch Completion: \(completion)")
                } receiveValue: { [unowned self] meals in
                    viewModel.categories[index].meals = meals
                }
                .store(in: &subscriptions)
        }
    }
    
    /// Links ViewModel's model data to dataSource
    private func setupDataSource() {
        viewModel.$categories
            .sink(receiveCompletion: { completion in
                print("Assign Completion: \(completion)")
            }, receiveValue: { [unowned self] categories in
                print("Controller Categories Received")
                self.tableViewDataSource.categories = categories
                self.tableView.reloadData()
            })
            .store(in: &subscriptions)
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
      
            let meal = viewModel.categories[section].meals[row]
            
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.meal = meal
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}

// MARK: - TableViewController Delegate Methods

extension CategoriesViewController {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderLabelView = UIView()
        sectionHeaderLabelView.backgroundColor = UIColor.white
        
        let sectionHeaderImageView = UIImageView()
        
        // TODO: This api call shouldnt be here. I should pull from a persistent store
        // Being called everytime we see a new header. Is called multiple times for the same
        // one if we scroll up and down.
        if let imageURL = tableViewDataSource.categories[section].imageID {
            viewModel.fetchImage(from: imageURL)
                //.receive(on: DispatchQueue.main)
                .sink { completion in
                    // Error handling here
                    print("Image header completion: \(completion)")
                } receiveValue: { image in
                    sectionHeaderImageView.image = image
                }
                .store(in: &subscriptions)
        }
        
        sectionHeaderImageView.frame = CGRect(x: 3, y: 10, width: 30, height: 30)
        sectionHeaderLabelView.addSubview(sectionHeaderImageView)
        
        let sectionHeaderLabel = UILabel()
        sectionHeaderLabel.text = tableViewDataSource.categories[section].name
        sectionHeaderLabel.textColor = .black
        sectionHeaderLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        sectionHeaderLabel.frame = CGRect(x: 43, y: 5, width: 250, height: 40)
        sectionHeaderLabelView.addSubview(sectionHeaderLabel)
        
        return sectionHeaderLabelView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
}
