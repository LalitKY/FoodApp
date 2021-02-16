//
//  FavouriteVC.swift
//  FoodyCookBookApp
//
//  Created by Lalit Kant on 16/02/21.
//  Copyright © 2021 Test. All rights reserved.
//

import UIKit

/// this calls show list of Favourited items
class FavouriteVC: UIViewController {

    @IBOutlet weak var favMealListTable: UITableView!
    let cellReuseIdentifier = "MealTVCID"

    var favMealList: [MealItem] = FavSingleton.sharedInstance.favItems
    
    override func viewDidLoad() {
        self.title = "Favourited Meals"
        super.viewDidLoad()
    }

}

// MARK: Extension to UITableViewDataSource
extension FavouriteVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return favMealList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? MealTVC else {
            return UITableViewCell()
        }
        cell.renderData(item: favMealList[indexPath.row])
        cell.hideFavIcon()
        return cell
    }
    
}
