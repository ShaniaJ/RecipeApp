//
//  InitialFirstNameViewController.swift
//  RecipeApp
//
//  Created by Shania on 4/12/23.
//

import UIKit


protocol InitialFirstNameViewControllerDelegate: AnyObject {
    func initialFirstNameViewController(_ controller: InitialFirstNameViewController, didAcquireName name: String)
}



class InitialFirstNameViewController: UIViewController {

    weak var delegate: InitialFirstNameViewControllerDelegate?
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    var firstName: String!
    var isFirstTime: Bool!
    var buttonClickedBefore: Bool!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var myColor = UIColor()
        myColor = myColor.generateRGBColor(227,240,199)
        nameTextField.layer.borderColor = myColor.cgColor
        nameTextField.layer.borderWidth = 1.7
        nameTextField.layer.cornerRadius = 5
        
        isFirstTime = UserDefaults.standard.bool(forKey: "isFirstTime")
        buttonClickedBefore = UserDefaults.standard.bool(forKey: "buttonClickedBefore")
        
        if !(UserDefaults.standard.bool(forKey: "isFirstTime")) && buttonClickedBefore {
            performSegue(withIdentifier: "segueToHomeScreen", sender: nil)
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //hiding nav bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @IBAction func nextButtonClicked() {
        UserDefaults.standard.set(true, forKey: "buttonClickedBefore")
        UserDefaults.standard.set(true, forKey: "isFirstTime")
        if nameTextField.text != nil && nameTextField.text != "" {
            firstName = nameTextField.text!
            isFirstTime = UserDefaults.standard.bool(forKey: "isFirstTime")
            performSegue(withIdentifier: "segueToHomeScreen", sender: nil)
        } 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if isFirstTime {
            isFirstTime = false
            self.delegate = segue.destination as! HomeViewController
            delegate?.initialFirstNameViewController(self, didAcquireName: firstName)
        }
        
    }


}


extension UIColor {
    func generateRGBColor(_ r: Int,_ g: Int,_ b: Int) -> UIColor {
        let redValue : CGFloat = CGFloat(r)/255.0
        let greenValue : CGFloat = CGFloat(g)/255.0
        let blueValue : CGFloat = CGFloat(b)/255.0
        let color = UIColor(red: redValue, green:greenValue, blue: blueValue, alpha: 1.0)
        
        return color
    }
}
