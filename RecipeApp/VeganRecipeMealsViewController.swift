//
//  VeganRecipeMealsViewController.swift
//  RecipeApp
//
//  Created by Shania on 4/8/23.
//

import UIKit

//FIXME: The nav controllers title wont show up when running on my device
//FIXME: Fix the constraints



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
        
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        self.navigationController?.navigationBar.tintColor = .black
//
//        self.title = "Vegan Recipes"
//        *self.navigationController?.navigationBar.topItem?.title = "Vegan Recipes"
//        self.parent?.title = "Vegan Recipes"
//        self.tabBarController?.navigationItem.title = "Vegan Recipes"
//        self.navigationItem.title = "Vegan Recipes"
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.isToolbarHidden = false
          
     
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
