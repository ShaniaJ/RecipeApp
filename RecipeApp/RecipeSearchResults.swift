//
//  RecipeSearchResults.swift
//  RecipeApp
//
//  Created by Shania on 4/24/23.
//

import Foundation
import UIKit

class RecipesArray: Codable {
    var results = [Recipe]()
    var number = 0
    
}

class Recipe: Codable, CustomStringConvertible {
    var title: String = ""
    var readyInMinutes: Int = 0
    var servings: Int = 0
    var id: Int = 0
    var image: String? = ""
    
    var imgUrl: String {
        return image ?? "https://media-cldnry.s-nbcnews.com/image/upload/rockcms/2022-03/plant-based-food-mc-220323-02-273c7b.jpg"
    }
    
    var description: String {
      return "\nResult - Title: \(title), Ready in \(readyInMinutes) mins, imageURL: \(imgUrl)"
    }
}


class DetailedRecipe: Codable, CustomStringConvertible {
    var title: String = ""
    var readyInMinutes: Int = 0
    var servings: Int = 0
    var id: Int = 0
    var image: String? = ""
    var summary: String = ""
//    var extendedIngredients: Array = [["": ""]]
//    var analyzedInstructions: Array = [["": ""]]
    
    var imgUrl: String {
        return image ?? "https://media-cldnry.s-nbcnews.com/image/upload/rockcms/2022-03/plant-based-food-mc-220323-02-273c7b.jpg"
    }
    
    var description: String {
      return "\nResult - Title: \(title), Ready in \(readyInMinutes) mins, imageURL: \(imgUrl)"
    }
}
