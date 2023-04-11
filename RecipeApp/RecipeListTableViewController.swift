//
//  RecipeListTableViewController.swift
//  RecipeApp
//
//  Created by Shania on 4/9/23.
//

import UIKit

class RecipeListTableViewController: UITableViewController, VeganRecipeMealsViewControllerDelegate, VegetarianRecipeMealsViewControllerDelegate, PescatarianRecipeMealsViewControllerDelegate {
    
    @IBOutlet weak var recipeImg: UIImage!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var cookingTimeLabel: UILabel!
    @IBOutlet weak var servingSizeLabel: UILabel!
    
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    // MARK: - Table View Delegate
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    

    
    //MARK: - Bugs
/** 1. The back button says back when accessing from veg & pesc recipes, but vegan for vegan recipes
*/
    

}
