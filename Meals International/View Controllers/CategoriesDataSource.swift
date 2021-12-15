//
//  CategoriesDataSource.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Combine
import Foundation
import UIKit

/*
 // TODO: So many API calls being made through the fetch image method below. Need persistence!
 */
class CategoriesDataSource: NSObject, UITableViewDataSource {
    
    var viewModel: CategoriesViewController.ViewModel!
    
    // Populated and managed by CategoriesViewController
    // TODO: Is the above correct? It should be managed by ViewModel
    var categories: [Category]!
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Rows and Sections
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].meals.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    // MARK: - Cells, Headers, and Footers
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Meal", for: indexPath
        ) as? MealCell else {
            fatalError("Unable to deque MealCell.")
        }
        
        let item = categories[indexPath.section].meals[indexPath.row]

        cell.mealLabel.text = item.name
        
        if let imageID = item.imageID {
            viewModel.fetchImage(from: imageID)
                //.delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
                .sink(receiveValue: { image in
                    print("Image ")
                    cell.mealImage.image = image
                    //tableView.reloadRows(at: [indexPath], with: .automatic)
                })
                .store(in: &subscriptions)
        }
        
        return cell
    }
    
    // Auto-generates a footer using the description--without the overlay that viewForFooterInSection forces.
    // This only works when tableView's style is set to Grouped.
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return categories[section].description
    }
}
