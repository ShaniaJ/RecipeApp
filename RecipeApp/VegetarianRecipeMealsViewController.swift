//
//  VegetarianRecipeMealsViewController.swift
//  RecipeApp
//
//  Created by Shania on 4/9/23.
//

import UIKit

//FIXME: The nav controllers title wont show up when running on my device


protocol VegetarianRecipeMealsViewControllerDelegate: AnyObject {
    func vegetarianRecipeMealsViewController(_ controller: VegetarianRecipeMealsViewController, didSelect meal: [String])
}

class VegetarianRecipeMealsViewController: UIViewController {

    weak var delegate: VegetarianRecipeMealsViewControllerDelegate?
    var button: UIButton!
    var dietTypeAndMeal: [String]!


    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        button = sender as? UIButton
        let meal = retrieveMealCategory(for: button!)
        let dietType: String = (self.navigationController?.navigationBar.topItem?.title!)!
        dietTypeAndMeal = [dietType, meal]
        performSegue(withIdentifier: "showVegetarianRecipes", sender: nil)
    }


    func retrieveMealCategory(for btn: UIButton) -> String {
        var mealCategory = btn.titleLabel?.text
        mealCategory = mealCategory?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        return mealCategory!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVegetarianRecipes" {
            let controller = segue.destination as! RecipeListTableViewController
            self.delegate = controller
            delegate?.vegetarianRecipeMealsViewController(self, didSelect: dietTypeAndMeal)
        }
    }

    

}
