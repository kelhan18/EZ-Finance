//
//  StatisticsViewController.swift
//  EZFinance
//
//  Created by CS3714 on 12/4/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var totalExpenseLabel: UILabel!
    @IBOutlet var categoryTableView: UITableView!
    
    var totalExpense: Double = 0.0
    var categories: [String] = [String]()
    
    var categorySelected: String = ""
    
    // Define MintCream color: #F5FFFA  245,255,250
    let MINT_CREAM = UIColor(red: 245.0/255.0, green: 255.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    // Define OldLace color: #FDF5E6   253,245,230
    let OLD_LACE = UIColor(red: 253.0/255.0, green: 245.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fixedString = String(format: "%.2f", totalExpense)
        totalExpenseLabel.text = "$\(fixedString)"
        
        categories = ["Grocery", "Utilities", "Mortgage", "Health & Fitness", "Entertainment", "Gifts & Donations", "Transportation", "Miscellaneous", "Savings", "Rent", "Travel", "Food", "Clothing"]
        categories.sort()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = MINT_CREAM
        } else {
            cell.backgroundColor = OLD_LACE
        }
    }
    
    // Informs the table view delegate that the specified row is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNumber = (indexPath as NSIndexPath).row
        // Obtain the video id of the selected Video
        let categoryName = categories[rowNumber]
        categorySelected = categoryName
        
        performSegue(withIdentifier: "View Selected Category", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Expense Category Cell", for: indexPath) as! CategoryTableViewCell
        let rowNumber = (indexPath as NSIndexPath).row
        let categoryName = categories[rowNumber]
        
        cell.categoryLabel!.text = categoryName
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "View Selected Category" {
            // Obtain the object reference of the destination view controller
            let expenseByCategoryTableViewController: ExpenseByCategoryTableViewController = segue.destination as! ExpenseByCategoryTableViewController
            
            expenseByCategoryTableViewController.categoryName = categorySelected
            
        }
        
    }
    
    
}
