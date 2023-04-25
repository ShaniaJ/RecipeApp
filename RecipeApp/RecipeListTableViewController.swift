//
//  RecipeListTableViewController.swift
//  RecipeApp
//
//  Created by Shania on 4/9/23.
//


import UIKit

//FIXME:  The back button says back when accessing from veg & pesc recipes, but vegan for vegan recipes
//TODO: Ensure there are no duplicates
//TODO: Show all results
//TODO: Create loading screen



class RecipeListTableViewController: UITableViewController, VeganRecipeMealsViewControllerDelegate, VegetarianRecipeMealsViewControllerDelegate, PescatarianRecipeMealsViewControllerDelegate {
    

    var dietType: String!  //Note: This would be something like "Pescatarian Recipes", titlecase with a space
    var mealtype: String!  //Note: This would be something like dinner, lowercase and no whitespace
    var searchResults = [Recipe]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gatherSearchResults([dietType,mealtype])
    }
    

    
    // MARK: - Vegan/Vegetarian/Pescatarian Recipe Meals ViewController Delegates
    func veganRecipeMealsViewController(_ controller: VeganRecipeMealsViewController, didSelect meal: [String]) {
        retrieveDietAndMeal(meal)
        print("Recived diet : \(dietType ?? "none")")
        print("Recived meal : \(mealtype ?? "none") ")
    }
    
    func vegetarianRecipeMealsViewController(_ controller: VegetarianRecipeMealsViewController, didSelect meal: [String]) {
        retrieveDietAndMeal(meal)
        print("Recived diet : \(dietType ?? "none")")
        print("Recived meal : \(mealtype ?? "none") ")
    }
    
    func pescatarianRecipeMealsViewController(_ controller: PescatarianRecipeMealsViewController, didSelect meal: [String]) {
        retrieveDietAndMeal(meal)
        print("Recived diet : \(dietType ?? "none")")
        print("Recived meal : \(mealtype ?? "none") ")
    }
    
    
    func retrieveDietAndMeal(_ info:  [String]) {
        dietType = info[0]
        mealtype = info[1]
    }
    
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "recipeCell",
            for: indexPath)
        
        let recipeTitlelabel = cell.viewWithTag(1) as! UILabel
        let minslabel = cell.viewWithTag(2) as! UILabel
        let servingSizelabel = cell.viewWithTag(3) as! UILabel
        //let imageView = cell.viewWithTag(4) as! UIImageView
        
        for i in 0..<searchResults.count {
            if indexPath.row == i {
                recipeTitlelabel.text = searchResults[i].title
                minslabel.text = "Ready in \(searchResults[i].readyInMinutes) minutes"
                servingSizelabel.text = "Serves \(searchResults[i].servings)"
            }
        }
        
        return cell
    }
    
    
    
    // MARK: - Table View Delegate
    override func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath
    ) {
      tableView.deselectRow(at: indexPath, animated: true)
    }


    // MARK: - Helper Methods
    
    func formatDietType(_ diet: String) -> String {
        let diet = diet.components(separatedBy: " ").first!.lowercased()
        switch diet {
        case "vegan":
            return "vegan"
        case "vegetarian":
            return "vegetarian"
        case "pescatarian":
            return "pescatarian"
        default:
            break
        }
        return ""
    }
    
    func formatMealType(_ meal: String) -> String {
        switch meal {
        case "breakfast":
            return "breakfast"
        case "snacks":
            return "snack,fingerfood"
        case "starters":
            return "appetizer,salad,soup"
        case "sides":
            return "side+dish,salad"
        case "sauces":
            return "sauce,marinade"
        case "drinks":
            return "beverage,drink"
        case "dinner":
            return "main+course"
        case "dessert":
            return "dessert"
        default:
            break
        }
        return ""
    }
    
    func recipeUrl(searchParameters: [String]) -> URL {
        //note: searchParameters will consist of array with global diet and meal type variables respectively
        let diet = formatDietType(searchParameters[0])
        let meal = formatMealType(searchParameters[1])
        let urlString = String(
        format: "https://api.spoonacular.com/recipes/complexSearch?apiKey=7fa065a8ced64226855f1b8962e4a335&diet=%@&type=%@&instructionsRequired=true&addRecipeInformation=true&sort=random&number=100",
        diet,
        meal)
        let url = URL(string: urlString)
        return url!
    }

    func performRecipeListRequest(with url: URL) -> Data? {
      do {
       return try Data(contentsOf: url)
      } catch {
       print("Download Error: \(error.localizedDescription)")
       showNetworkError()
       return nil
      }
    }
    
    func parse(data: Data) -> [Recipe] {
      do {
        let decoder = JSONDecoder()
        let result = try decoder.decode(
          RecipesArray.self, from: data)
        return result.results
      } catch {
        print("JSON Error: \(error)")
        return []
      }
    }
    
    func showNetworkError() {
      let alert = UIAlertController(
        title: "Whoops...",
        message: "There was an error accessing the recipes." +
        " Please try again.",
        preferredStyle: .alert)
      
      let action = UIAlertAction(
        title: "OK", style: .default, handler: nil)
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    }


    func gatherSearchResults(_ parameters: [String]) {
        var results = [Recipe]()
        let queue = DispatchQueue.global()
        queue.async {
            if parameters[0] == "Vegan Recipes" {
                    let url = self.recipeUrl(searchParameters: parameters)
                    print("url is \(url)")
                    
                    if let data = self.performRecipeListRequest(with: url) {
                        results = self.parse(data: data)
                    }
            } else if parameters[0] == "Vegetarian Recipes" {
                    let url1 = self.recipeUrl(searchParameters: parameters)
                    let url2 = self.recipeUrl(searchParameters: ["Vegan Recipes",parameters[1]])
                    print("url1 is \(url1)")
                    print("url2 is \(url2)")
                    
                    if let data1 = self.performRecipeListRequest(with: url1) {
                        results = self.parse(data: data1)
                        if let data2 = self.performRecipeListRequest(with: url2) {
                            results += self.parse(data: data2)
                        }
                    }
            } else { //parameters[0] = "Pescatarian Recipes"
                    let url1 = self.recipeUrl(searchParameters: parameters)
                    let url2 = self.recipeUrl(searchParameters: ["Vegan Recipes",parameters[1]])
                    let url3 = self.recipeUrl(searchParameters: ["Vegetarian Recipes",parameters[1]])
                    print("url1 is \(url1)")
                    print("url2 is \(url2)")
                    print("url3 is \(url3)")
                    
                    if let data1 = self.performRecipeListRequest(with: url1) {
                        results = self.parse(data: data1)
                        if let data2 = self.performRecipeListRequest(with: url2) {
                            results += self.parse(data: data2)
                        }
                        if let data3 = self.performRecipeListRequest(with: url3) {
                            results += self.parse(data: data3)
                        }
                    }
            }
            self.searchResults = results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            return
        }
    }


    // MARK: - Navigation

    

    

}
