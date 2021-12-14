//
//  CategoriesDataSource.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/10/21.
//

import Foundation
import UIKit


class CategoriesDataSource: NSObject, UITableViewDataSource {
    
    // Populated and managed by CategoriesViewController
    // TODO: Is this correct? It should be managed by ViewModel
    var categories: [Category]!
    
    // MARK: - Rows and Sections
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].meals.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    // MARK: - Cells, Headers, and Footers
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Meal", for: indexPath)
        
        let item = categories[indexPath.section].meals[indexPath.row]
        
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.text = item.name
        cell.contentConfiguration = cellConfig
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return categories[section].description
    }
}
