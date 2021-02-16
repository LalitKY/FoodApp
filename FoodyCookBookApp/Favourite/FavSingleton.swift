//
//  FavSingleton.swift
//  FoodyCookBookApp
//
//  Created by Lalit Kant on 16/02/21.
//  Copyright © 2021 Test. All rights reserved.
//

import Foundation

//Singleton to kep Fav Meal item available unlil user is in the app.
// Due to time constrint I didn't use DB
class FavSingleton {
    
    static let sharedInstance = FavSingleton()
    var favItems: [MealItem] = []
    
    func favAndUnFavData(item: MealItem) {
        if favItems.isEmpty == true {
            favItems.append(item)
        } else {
            updateArrayIfFavItemPresent(item: item)
        }
    }
    
    private func updateArrayIfFavItemPresent(item: MealItem) {
        if favItems.filter({$0.idMeal == item.idMeal}).count == 0 {
            favItems.append(item)
        } else {
            if let index = favItems.firstIndex(where: {$0.idMeal == item.idMeal}) {
                favItems.remove(at: index)
            }
        }
    }
    
    func checkIfItsFavItem(item: MealItem) -> Bool {
        if favItems.filter({$0.idMeal == item.idMeal}).count == 0 {
            return false
        } else {
            return true
        }
    }
    
}
