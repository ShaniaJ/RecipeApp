//
//  ViewController.swift
//  RecipeApp
//
//  Created by Shania on 4/5/23.
//

import UIKit

//FIXME: The welcome back animation only activates when you completely kill the app and then restart, not upon every time you open it from sleeping (putting it in viewDidAppear didn't work)

//TODO: Implement one time welcome screen that asks the user their name and then navigate to this screen (will be my userDefaults requirement hopefully?)


class HomeViewController: UIViewController {

    @IBOutlet weak var veganRecipeButton: UIButton!
    @IBOutlet weak var factsLabel: UILabel!
    @IBOutlet weak var welcomeBackLabel: UILabel!
    @IBOutlet weak var brownButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    let factsToBeDisplayed = climateChangeFacts
    var factsDisplayedALready = [String]()
    var currentFact : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //slide in animation for welcome back label
        UIView.animate(withDuration: 0.90) {
              self.welcomeBackLabel.center.x += (self.view.bounds.width)
        }
        
        //Transparent animation for name label
        UIView.animate(withDuration: 1.6) {
            self.nameLabel.alpha = 0.1
            self.nameLabel.alpha = 1.0
        }
        
        //Creating shadow effect for fact button
        brownButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        brownButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        brownButton.layer.shadowOpacity = 1.0
        brownButton.layer.shadowRadius = 10.0
        brownButton.layer.masksToBounds = false
        
        //other setup
        currentFact = factsToBeDisplayed.randomElement()!
        factsLabel.text = currentFact
        displayFacts()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //initially move welcome back label off screen for animation
        welcomeBackLabel.center.x -= (view.bounds.width)
        
        //Hiding nav bar exclusively for home screen
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Hiding nav bar exclusively for home screen
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    func toggleButtonOpacity(for btn: UIButton) {
        btn.alpha = 0.8
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            btn.alpha = 0.9
        }
    }
    

    //MARK: - Buttons

    @IBAction func veganButtonClicked(_ sender: Any) {
        toggleButtonOpacity(for: sender as! UIButton)
    }
    
    @IBAction func vegetarianButtonClicked(_ sender: Any) {
        toggleButtonOpacity(for: sender as! UIButton)
    }
    
    @IBAction func pescButtonClicked(_ sender: Any) {
        toggleButtonOpacity(for: sender as! UIButton)
    }
    
    
    //MARK: - Labels
    
    func displayFacts() {
        //randomly traversing through climate facts with a 4 second delay display
        DispatchQueue.global(qos: .background).async {
            for _ in 0..<(self.factsToBeDisplayed.count-1) {
                sleep(4)
                self.factsDisplayedALready.append(self.currentFact)
                        DispatchQueue.main.sync {
                            while (self.factsDisplayedALready.contains(self.currentFact)) {
                                self.currentFact = self.factsToBeDisplayed.randomElement()!
                            }
                            //animating the transition between facts to make the new one fade in
                            UIView.animate(withDuration: 1.3) {
                                self.factsLabel.alpha = 0.3
                                self.factsLabel.alpha = 1.0
                            }
                            self.factsLabel.text = self.currentFact
                        }
            }
        }
    }
    
    
    
  
    
}

