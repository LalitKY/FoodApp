//
//  ViewController.swift
//  FoodyCookBookApp
//
//  Created by Lalit on 15/02/21.
//  Copyright © 2021 Test. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

enum RandomOrSearch {
    case random
    case search
}

//This is View Controller to showlist of Meals with Search Option
class ViewController: UIViewController {
    
    @IBOutlet var searchBarView: UISearchBar!
    private let networkManager = NetworkManager()
    @IBOutlet weak var mealListTable: UITableView!
    private let cellReuseIdentifier = "MealTVCID"
    private var mealItemsRandom: [MealItem] = []
    private var mealItemsSearch: [MealItem] = []
    private var randomOrSearchItems = RandomOrSearch.random

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingHUD(to_view: self.view)
        fetchRandomMeals()
        searchBarSetupUI()
    }
    
    private func searchBarSetupUI() {
        navigationItem.titleView = searchBarView
        searchBarView.searchTextField.clearButtonMode = .never
        searchBarView.showsCancelButton = true
    }
    
}

// MARK: Extension to load data from Api
fileprivate extension ViewController {
    
    func fetchRandomMeals() {
        networkManager.fetchRandomMeals { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.hideLoadingHUD(for_view: strongSelf.view)
            switch result {
            case .success(let mealResponse):
                strongSelf.mealItemsRandom =  mealResponse.meals ?? [MealItem]()
                strongSelf.mealListTable.reloadData()
            case .failure(let error):
                strongSelf.mealItemsRandom = [MealItem]()
                strongSelf.mealListTable.reloadData()
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchSearchResult(searchStr: String?) {
        networkManager.fetchSearchResult(query: searchStr ?? "") { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.hideLoadingHUD(for_view: strongSelf.view)
            switch result {
            case .success(let mealResponse):
                strongSelf.mealItemsSearch =  mealResponse.meals ?? [MealItem]()
                strongSelf.mealListTable.reloadData()
            case .failure(let error):
                strongSelf.mealItemsSearch = [MealItem]()
                strongSelf.mealListTable.reloadData()
                print(error.localizedDescription)
            }
        }
    }
   
}

// MARK: Extension for table view data source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch randomOrSearchItems {
        case RandomOrSearch.random:
            return mealItemsRandom.count
        default:
            return mealItemsSearch.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? MealTVC else {
            return UITableViewCell()
        }
        // set the text from the data model
        switch randomOrSearchItems {
        case RandomOrSearch.random:
            cell.renderData(item: mealItemsRandom[indexPath.row])
        default:
            cell.renderData(item: mealItemsSearch[indexPath.row])
        }
        
        return cell
    }
    
}

// MARK: Extension to UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == true {
            searchBarCancelButtonClicked(searchBar)
            return
        }
        randomOrSearchItems =  RandomOrSearch.search
        showLoadingHUD(to_view: self.view)
        fetchSearchResult(searchStr: searchBar.text)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        randomOrSearchItems =  RandomOrSearch.random
        mealListTable.reloadData()
        searchBar.resignFirstResponder()
    }
    
}

// MARK: Extension to Show and hide loader
extension ViewController {
    
    func showLoadingHUD(to_view: UIView) {
        let hud = MBProgressHUD.showAdded(to: to_view, animated: true)
        hud.label.text = "Loading..."
    }

    func hideLoadingHUD(for_view: UIView) {
        MBProgressHUD.hide(for: for_view, animated: true)
    }
        
}
