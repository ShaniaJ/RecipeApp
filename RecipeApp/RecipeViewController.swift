//
//  RecipeViewController.swift
//  RecipeApp
//
//  Created by Shania on 4/25/23.
//



import UIKit


class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RecipeListTableViewControllerDelegate {
    
   
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var directionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var minsAndServingSizeLabel: UILabel!
    @IBOutlet weak var ingredientsTable: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!

    var downloadTask: URLSessionDownloadTask?
    var previousScreenDietType: String!  //Note: This would be something like "Pescatarian Recipes", titlecase with a space
    var previousScreenMealType: String!  //Note: This would be something like "dinner", lowercase and no whitespace
    var recipeID: String!
    var currentRecipe = DetailedRecipe()
    var downloadedImg: UIImage!
    var recipeScore = -1.0

    
    struct Ingredient {
        let title: String
        let imgName: String
        let amount: String
    }
    
    let data: [Ingredient] = [
        Ingredient(title: "Milk", imgName: "Milk-Eggs-Other-Dairy",amount: "1 Cup"),
        Ingredient(title: "Flour", imgName: "Baking",amount: "1/2 Cup"),
        Ingredient(title: "Salmon", imgName: "Seafood",amount: "1 Whole"),
        Ingredient(title: "Cheddar Cheese", imgName: "Cheese",amount: "2 Cups"),
        Ingredient(title: "Eggs", imgName: "Milk-Eggs-Other-Dairy",amount: "4"),
        Ingredient(title: "Olive Oil", imgName: "Oil-Vinegar-Salad Dressing",amount: "1 Tbs")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        var myBrownColor = UIColor()
        myBrownColor = myBrownColor.generateRGBColor(184,136,73)
        
        //segmented control set-up
        let font = UIFont(name: "Didot Bold", size: 15)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: UIColor.white,
        ]
        segmentedControl.setTitleTextAttributes(attributes, for: .normal)
        
        //favorite button set-up
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        
        //table view set-up
        ingredientsTable.dataSource = self
        ingredientsTable.delegate = self
        tableHeightConstraint.constant = CGFloat(Double(data.count) * 81)
        directionsHeightConstraint.constant = tableHeightConstraint.constant

        directionsLabel.text = "Step 1\n\tPreheat the oven to 200 degrees F\n\nStep 2\n\tWhisk together the flour, pecans, granulated sugar, light brown sugar, baking powder, baking soda, and salt in a medium bowl.\n\nStep 3\n\tWhisk together the eggs, buttermilk, butter and vanilla extract and vanilla bean in a small bowl.\n\nStep 1\n\tPreheat the oven to 200 degrees F\n\nStep 2\n\tWhisk together the flour, pecans.\n\nStep 1\n\tgranulated sugar, light brown sugar, baking powder, baking soda, and salt in a medium bowl.\n\nStep 3\n\tWhisk together the eggs, buttermilk, butter and vanilla extract and vanilla bean in a small bowl.\n\nStep 1\n\tPreheat the oven to 200 degrees F\n\nStep 2\n\tWhisk together the flour, pecans, granulated sugar, light brown sugar, baking powder, baking soda, and salt in a medium bowl.\n\nStep 3\n\tWhisk together the eggs, buttermilk, butter and vanilla extract and vanilla bean in a small bowl."
        
        getRecipeInfo(for: recipeID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Hiding nav bar for this screen
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    //MARK: Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTable.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientTableViewCell
        let ingredient = data[indexPath.row]
        cell.ingredientImg.image = UIImage(named: ingredient.imgName)
        cell.ingredientName.text = ingredient.title
        cell.ingredientAmount.text = ingredient.amount
        return cell
    }
    
    //MARK: Recipe List Table View Controller Delegate
    func recipeListTableViewController(_ controller: RecipeListTableViewController, didSelectID ID: String) {
        recipeID = ID
    }
    
    func recipeListTableViewController(_ controller: RecipeListTableViewController, currentSearchCategories categories: [String]) {
        previousScreenDietType = categories[0]
        previousScreenMealType = categories[1]
    }
    
    
    
    //MARK: Table View Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
    //MARK: Segmented Control
    
    @IBAction func segmentedControlToggled(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 { //ingredients selected
            tableHeightConstraint.constant = CGFloat(Double(data.count) * 81)
            directionsHeightConstraint.constant = tableHeightConstraint.constant
            directionsLabel.alpha = 0
            ingredientsTable.alpha = 1
        } else { //directions selected
            directionsHeightConstraint.constant = CGFloat(80 * 10)
            tableHeightConstraint.constant = directionsHeightConstraint.constant
            ingredientsTable.alpha = 0
            directionsLabel.alpha = 1
        }
    }
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        if favoriteButton.currentImage == UIImage(systemName: "heart") {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    
    //MARK: - API Calls
    
    func recipeUrl(ID: String) -> URL {
        let urlString = String(
            format:"https://api.spoonacular.com/recipes/%@/information?apiKey=f6cf877f8db046999cbd145430156c8d&includeNutrition=false",
            ID)
        let url = URL(string: urlString)
        return url!
    }

    func parse(data: Data) -> DetailedRecipe {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(
                DetailedRecipe.self, from: data)
            return result
        } catch {
            print("JSON Error: \(error)")
            return DetailedRecipe()
        }
    }

    func showNetworkError() {
        let alert = UIAlertController(
            title: "Whoops...",
            message: "There was an error accessing the recipe." +
            " Please try again.",
            preferredStyle: .alert)

        let action = UIAlertAction(
            title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func getRecipeInfo(for ID: String) {
        let url = self.recipeUrl(ID: recipeID)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) {data, response, error in
            if let error = error {
                print("Failure! \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 {
                if let data = data {
                    self.currentRecipe = self.parse(data: data)
                    DispatchQueue.main.async {
                        self.titleLabel.text = self.currentRecipe.title
                        self.minsAndServingSizeLabel.text = "\(self.currentRecipe.readyInMinutes) Mins | Serves \(self.currentRecipe.servings) | "
                        self.summaryLabel.text = self.formatSummary(summary: self.currentRecipe.summary)
                        self.ratingLabel.text = self.recipeScore != -1.0 ? String(self.recipeScore) : "4.5"
 
    
                        let imgUrl = URL(string: self.currentRecipe.imgUrl)
                        if let imgUrl {
                            self.downloadTask = self.recipeImg.loadImage(url: imgUrl)
                        }
                       
                        //self.tableView.reloadData()
                    }
                    return
                }
            } else {
                print("Failure! \(response!)")
            }
        }
        dataTask.resume()
    }

    
    func formatSummary(summary: String) -> String {
        //access spoonacular score to generate star rating
        let startIndex = summary.range(of: "spoonacular score")?.lowerBound
        if let startIndex {
            let startStr = String(summary[startIndex..<summary.endIndex])
            let endIndex = startStr.range(of: "%")!.lowerBound
            let scoreSentence = String(startStr[startStr.startIndex...endIndex])
            var tempScore = String(scoreSentence.suffix(3))
            tempScore.removeLast()
            generateStarRating(Score:Double(tempScore) ?? 101.0)
        }
        
        //clean string
        var sentences = summary.components(separatedBy: ".")
        sentences.removeSubrange(7...sentences.count-1)
        var cleanedStr = ""
        
        for sentence in sentences {
            var s = sentence.replacingOccurrences(of: "<b>", with: "")
            s = s.replacingOccurrences(of: "</b>", with: "")
            s = "\(s)."
            cleanedStr += s
        }
        
        return cleanedStr
    }
    
    
    func generateStarRating(Score: Double) {
        switch Score {
        case 0...25:
            recipeScore = 1.0
        case 26...50:
            recipeScore = 2.0
        case 51...75:
            recipeScore = 3.0
        case 76...80:
            recipeScore = 4.0
        case 81...85:
            recipeScore = 4.2
        case 86...90:
            recipeScore = 4.6
        case 91...95:
            recipeScore = 4.8
        case 96...100:
            recipeScore = 5
        default:
            break
        }
    }
        

}

