//
//  CategoriesDataSource.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Combine
import Foundation
import UIKit


class CategoriesDataSource: NSObject, UITableViewDataSource {

    var viewModel: CategoriesViewController.ViewModel!
    
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Rows and Sections
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.appState.categories[section].meals.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.appState.categories.count
    }
    
    // MARK: - Cells, Headers, and Footers
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Meal", for: indexPath
        ) as? MealCell else {
            fatalError("Unable to deque MealCell.")
        }
        
        let meal = viewModel.appState.categories[indexPath.section].meals[indexPath.row]

        cell.mealLabel.text = meal.name
        cell.mealImageActivityStatus.startAnimating()
        // Prevents a MealCell from being assigned the wrong image and then switching into the right one,
        // creating the popping visual bug.
        cell.mealImage.image = UIImage()
        
#warning("Need error handling, some stock image shown instead? Maybe handled by ImageService?")
#warning("I might be better off actually making the ImageService capable of failing, so that I can respond to the failure condition.")
        if let imageURL = meal.imageID {
            viewModel.fetchImage(imageType: .meal(imageURL))
                .sink { completion in
                    // Error handling here
                    print("MealCell Image completion: \(completion)")
                } receiveValue: { image in
                    print("CategoriesDataSource - Fetch MealCell Image")
                    cell.mealImage.image = image
                 
                    if image != UIImage() {
                        cell.mealImageActivityStatus.stopAnimating()
                    }
                    
                }
                .store(in: &subscriptions)
        }
        
        return cell
    }
    
    // Auto-generates a footer using the description--without the overlay that viewForFooterInSection forces.
    // This only works when tableView's style is set to Grouped.
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return viewModel.appState.categories[section].description
    }
}
