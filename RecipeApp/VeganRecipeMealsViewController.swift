//
//  VeganRecipeMealsViewController.swift
//  RecipeApp
//
//  Created by Shania on 4/8/23.
//

import UIKit


protocol VeganRecipeMealsViewControllerDelegate: AnyObject {
    func veganRecipeMealsViewController(_ controller: VeganRecipeMealsViewController, didSelect meal: [String])
}

class VeganRecipeMealsViewController: UIViewController {

    weak var delegate: VeganRecipeMealsViewControllerDelegate?
    var button: UIButton!
    var dietTypeAndMeal: [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

        self.title = "Vegan Recipes"
     
    }


    @IBAction func buttonPressed(_ sender: Any) {
        button = sender as? UIButton
        let meal = retrieveMealCategory(for: button!)
        let dietType: String = (self.navigationController?.navigationBar.topItem?.title!)!
        dietTypeAndMeal = [dietType, meal]
 
        performSegue(withIdentifier: "showVeganRecipes", sender: nil)
    }


    func retrieveMealCategory(for btn: UIButton) -> String {
        var mealCategory = btn.titleLabel?.text
        mealCategory = mealCategory?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        return mealCategory!
    }
    
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showVeganRecipes" {
                let controller = segue.destination as! RecipeListTableViewController
                self.delegate = controller
                delegate?.veganRecipeMealsViewController(self, didSelect: dietTypeAndMeal)
            }
        }
    


}
