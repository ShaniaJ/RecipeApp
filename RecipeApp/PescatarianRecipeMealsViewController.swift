//
//  PescatarianRecipeMealsViewController.swift
//  RecipeApp
//
//  Created by Shania on 4/9/23.
//

import UIKit

//FIXME: The nav controllers title wont show up when running on my device
//FIXME: Fix the constraints

//TODO:


protocol PescatarianRecipeMealsViewControllerDelegate: AnyObject {
    func pescatarianRecipeMealsViewController(_ controller: PescatarianRecipeMealsViewController, didSelect meal: [String])
}



class PescatarianRecipeMealsViewController: UIViewController {

    weak var delegate: PescatarianRecipeMealsViewControllerDelegate?
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

        performSegue(withIdentifier: "showPescatarianRecipes", sender: nil)
    }


    func retrieveMealCategory(for btn: UIButton) -> String {
        var mealCategory = btn.titleLabel?.text
        mealCategory = mealCategory?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        return mealCategory!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPescatarianRecipes" {
            let controller = segue.destination as! RecipeListTableViewController
            self.delegate = controller
            
            delegate?.pescatarianRecipeMealsViewController(self, didSelect: dietTypeAndMeal)

        }
    }
    
    

}
