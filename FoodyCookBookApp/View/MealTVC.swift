//
//  MealTVC.swift
//  FoodyCookBookApp
//
//  Created by Lalit Kant on 16/02/21.
//  Copyright © 2021 Test. All rights reserved.
//

import UIKit

class MealTVC: UITableViewCell {

    @IBOutlet private weak var favButton: UIButton!
    @IBOutlet private weak var mealThumbImg: UIImageView!
    @IBOutlet private weak var mealTitle: UILabel!
    private var mealItem: MealItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }
    
    func renderData(item: MealItem) {
        mealItem = item
        mealTitle.text = item.strMeal ?? ""
        guard let imgStr  = item.strMealThumb else {
            return
        }
        mealThumbImg.sd_setImage(with: URL.init(string: imgStr), placeholderImage: UIImage.init(named: "placeholder"))
        loadfavIcon()
    }

    private func loadfavIcon() {
        if FavSingleton.sharedInstance.checkIfItsFavItem(item: mealItem) {
            favButton.setImage(UIImage.init(named: "un_fav"), for: .normal)
        } else {
            favButton.setImage(UIImage.init(named: "fav"), for: .normal)
        }
    }
    
    @IBAction func favItem(_ sender: Any) {
        FavSingleton.sharedInstance.favAndUnFavData(item: mealItem)
        loadfavIcon()
    }
    
    func hideFavIcon() {
        favButton.isHidden = true
    }
    
}
