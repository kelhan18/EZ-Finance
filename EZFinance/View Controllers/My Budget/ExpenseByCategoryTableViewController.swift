//
//  ExpenseByCategoryTableViewController.swift
//  EZFinance
//
//  Created by CS3714 on 12/4/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit

class ExpenseByCategoryTableViewController: UITableViewController {

    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var expensesTableView: UITableView!
    
    // Define MintCream color: #F5FFFA  245,255,250
    let MINT_CREAM = UIColor(red: 245.0/255.0, green: 255.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    // Define OldLace color: #FDF5E6   253,245,230
    let OLD_LACE = UIColor(red: 253.0/255.0, green: 245.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    var categoryName: String = ""
    var expenses = [String]()
    var expenseDataToPass = [String]()
    var expenseNameToPass: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        expenses = applicationDelegate.dict_Expense_ExpenseData.allKeys as! [String]
        getExpenseByCategory()
        expenses.sort { $0 < $1 }
    }

    func getExpenseByCategory() {
    
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return expenses.count
    }
    
    // Informs the table view delegate that the specified row is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNumber = (indexPath as NSIndexPath).row
        // Obtain the video id of the selected Video
        let expenseName = expenses[rowNumber]
        let expenseDataObtained: [String] = applicationDelegate.dict_Expense_ExpenseData["\(expenseName)"]! as! [String]
        expenseDataToPass = expenseDataObtained
        expenseNameToPass = expenseName
        
        performSegue(withIdentifier: "Expense Details", sender: self)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ExpenseByCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Expense Cell", for: indexPath) as! ExpenseByCategoryTableViewCell
        let rowNumber = (indexPath as NSIndexPath).row
        let expenseName = expenses[rowNumber]
        let expenseDataObtained: [String] = applicationDelegate.dict_Expense_ExpenseData["\(expenseName)"]! as! [String]
        
        cell.expenseNameLabel!.text = expenseName
        cell.expenseCostLabel!.text = "$\(expenseDataObtained[0])"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = MINT_CREAM
        } else {
            cell.backgroundColor = OLD_LACE
        }
    }

    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Expense Details" {
            // Obtain the object reference of the destination view controller
            let expenseDetailsViewController: ExpenseDetailsViewController = segue.destination as! ExpenseDetailsViewController
     
            expenseDetailsViewController.expenseDetails = expenseDataToPass
            expenseDetailsViewController.expenseName = expenseNameToPass
     }
    }

}

