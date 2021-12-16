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
    // App-wide datasource accessed via viewModel
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
        
        let item = viewModel.appState.categories[indexPath.section].meals[indexPath.row]

        cell.mealLabel.text = item.name
        
        if let imageID = item.imageID {
            viewModel.fetchImage(from: imageID)
                .sink(receiveValue: { image in
                    print("Image ")
                    cell.mealImage.image = image
                })
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
