//
//  RecipeListTableViewController.swift
//  RecipeApp
//
//  Created by Shania on 4/9/23.
//


import UIKit

//FIXME: The back button says 'back' when accessing from veg & pesc recipes screen, but vegan for vegan recipes
//TODO: Ensure there are no duplicate recipes
//TODO: Show all results
//TODO: Create loading screen



class RecipeListTableViewController: UITableViewController, VeganRecipeMealsViewControllerDelegate, VegetarianRecipeMealsViewControllerDelegate, PescatarianRecipeMealsViewControllerDelegate {
    
    
    var dietType: String!  //Note: This would be something like "Pescatarian Recipes", titlecase with a space
    var mealtype: String!  //Note: This would be something like "dinner", lowercase and no whitespace
    var searchResults = [Recipe]()
    var downloadTask: URLSessionDownloadTask?

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gatherSearchResults([dietType,mealtype])
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        let imageView = cell.viewWithTag(4) as! UIImageView
        
        for i in 0..<searchResults.count {
            if indexPath.row == i {
                recipeTitlelabel.text = searchResults[i].title
                minslabel.text = "Ready in \(searchResults[i].readyInMinutes) minutes"
                servingSizelabel.text = "Serves \(searchResults[i].servings)"
                let imgUrl = URL(string: searchResults[i].imgUrl)
                if let imgUrl {
                    downloadTask = imageView.loadImage(url: imgUrl)
                }
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
            format: "https://api.spoonacular.com/recipes/complexSearch?apiKey=053be10d85bb42498c0223fb6593cbac&diet=%@&type=%@&instructionsRequired=true&addRecipeInformation=true&sort=random&number=100",
            diet,
            meal)
        let url = URL(string: urlString)
        return url!
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
    
    //*************************************************************************************************
    
    func gatherSearchResults(_ parameters: [String]) {
        if parameters[0] == "Vegan Recipes" {
            let url = self.recipeUrl(searchParameters: parameters)
            print("url is \(url)")
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) {data, response, error in
                if let error = error {
                    print("Failure! \(error.localizedDescription)")
                } else if let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 {
                    if let data = data {
                        self.searchResults = self.parse(data: data)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        return
                    }
                } else {
                    print("Failure! \(response!)")
                }
            }
            dataTask.resume()
        } else if parameters[0] == "Vegetarian Recipes" {
            let url1 = self.recipeUrl(searchParameters: parameters)
            let url2 = self.recipeUrl(searchParameters: ["Vegan Recipes",parameters[1]])
            print("url1 is \(url1)")
            print("url2 is \(url2)")
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url1) {data, response, error in
                if let error = error {
                    print("Failure! \(error.localizedDescription)")
                } else if let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 {
                    if let data = data {
                        self.searchResults = self.parse(data: data)
                        let dataTask2 = session.dataTask(with: url2) {data, response, error in
                            if let error = error {
                                print("Failure! \(error.localizedDescription)")
                            } else if let httpResponse = response as? HTTPURLResponse,
                                      httpResponse.statusCode == 200 {
                                if let data = data {
                                    self.searchResults += self.parse(data: data)
                                    DispatchQueue.main.async {
                                      self.tableView.reloadData()
                                    }
                                    return
                                }
                            } else {
                                print("Failure! \(response!)")
                            }
                        }
                        dataTask2.resume()
                        return
                    }
                } else {
                    print("Failure! \(response!)")
                }
            }
            dataTask.resume()
            
        } else { //parameters[0] = "Pescatarian Recipes"
            let url1 = self.recipeUrl(searchParameters: parameters)
            let url2 = self.recipeUrl(searchParameters: ["Vegan Recipes",parameters[1]])
            let url3 = self.recipeUrl(searchParameters: ["Vegetarian Recipes",parameters[1]])
            print("url1 is \(url1)")
            print("url2 is \(url2)")
            print("url3 is \(url3)")
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url1) {data, response, error in
                if let error = error {
                    print("Failure \(error.localizedDescription)")
                } else if let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 {
                    if let data = data {
                        self.searchResults = self.parse(data: data)
                        let dataTask2 = session.dataTask(with: url2) {data, response, error in
                            if let error = error {
                                print("Failure \(error.localizedDescription)")
                            } else if let httpResponse = response as? HTTPURLResponse,
                                      httpResponse.statusCode == 200 {
                                if let data = data {
                                    self.searchResults += self.parse(data: data)
                                    let dataTask3 = session.dataTask(with: url3) {data, response, error in
                                        if let error = error {
                                            print("Failure \(error.localizedDescription)")
                                        } else if let httpResponse = response as? HTTPURLResponse,
                                                  httpResponse.statusCode == 200 {
                                            if let data = data {
                                                self.searchResults += self.parse(data: data)
                                                DispatchQueue.main.async {
                                                    self.tableView.reloadData()
                                                }
                                                return
                                            }
                                        } else {
                                            print("Failure! \(response!)")
                                        }
                                    }
                                    dataTask3.resume()
                                    return
                                }
                            } else {
                                print("Failure! \(response!)")
                            }
                        }
                        dataTask2.resume()
                        return
                    }
                } else {
                    print("Failure! \(response!)")
                }
            }
            dataTask.resume()
        }
        
        //************************************************************************************************
        
        // MARK: - Navigation
        
        
        
        
        
    }
}

extension UIImageView {
  func loadImage(url: URL) -> URLSessionDownloadTask {
    let session = URLSession.shared
    let downloadTask = session.downloadTask(with: url) {
      [weak self] url, _, error in
      if error == nil, let url = url,
        let data = try? Data(contentsOf: url),
        let image = UIImage(data: data) {
        DispatchQueue.main.async {
          if let weakSelf = self {
            weakSelf.image = image
          }
        }
      }
    }
    downloadTask.resume()
    return downloadTask
  }
}



//var stateLock = NSLock()
//func setFullName(firstName: String, lastName: String) {
//    stateLock.lock()
//    self.firstName = firstName
//    self.lastName = lastName
//    stateLock.unlock()
//}
