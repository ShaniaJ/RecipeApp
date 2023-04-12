//
//  RecipeListTableViewController.swift
//  RecipeApp
//
//  Created by Shania on 4/9/23.
//


import UIKit

//FIXME:  The back button says back when accessing from veg & pesc recipes, but vegan for vegan recipes

//TODO:


class RecipeListTableViewController: UITableViewController, VeganRecipeMealsViewControllerDelegate, VegetarianRecipeMealsViewControllerDelegate, PescatarianRecipeMealsViewControllerDelegate {
    

    var dietType: String!  //Note: This would be something like "Pescatarian Recipes", titlecase with a space
    var mealtype: String!  //Note: This would be something like dinner, lowercase and no whitespace
    let testrecipes = ["chicken parmesan","lasagna","pizza","tortellini","stuffed shells","spaghetti and meatballs","chicken alfredo","baked ziti","beef stroganoff","chicken tetrazzini","enchiladas","nacho bar", "fajitas", "burritos","quesadillas","taco salad", "BLT","melts","philly cheese steak", "French dip","sloppy joes","hamburgers","loose meat","BBQ pulled pork","BBQ pulled chicken","grilled chicken","egg and tomato","burgers","panini","monte cristo","fried chicken","bratwurst","gyros","buffalo chicken sandwiches"]
    let testMins = ["20", "25", "30", "45", "1 hour"]
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return testrecipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "recipeCell",
            for: indexPath)
        
        let recipeTitlelabel = cell.viewWithTag(1) as! UILabel
        let minslabel = cell.viewWithTag(2) as! UILabel
        let servingSizelabel = cell.viewWithTag(3) as! UILabel
        
        for index in 0..<testrecipes.count {
            if indexPath.row == index {
                recipeTitlelabel.text = testrecipes.randomElement()!
                let minsSelected = testMins.randomElement()!
                let minsText = (minsSelected == "1 hour") ? "" : "mins"
                minslabel.text = "Ready in \(minsSelected) \(minsText)"
                servingSizelabel.text = "Serves \(Int.random(in: 1...4))"
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


    
    // MARK: - Navigation

    

    

}
