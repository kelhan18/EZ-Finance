//
//  ExpenseDetailsViewController.swift
//  EZFinance
//
//  Created by CS3714 on 12/4/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit

class ExpenseDetailsViewController: UIViewController {
    
    
    @IBOutlet var expenseNameLabel: UILabel!
    @IBOutlet var expenseCostLabel: UILabel!
    @IBOutlet var expenseLocationLabel: UILabel!
    @IBOutlet var expenseCategoryLabel: UILabel!
    @IBOutlet var expenseDateLabel: UILabel!
    
    @IBOutlet var viewPhotoButton: UIButton!
    
    
    var expenseDetails = [String]()
    var expenseName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expenseNameLabel.text = expenseName
        expenseCostLabel.text = expenseDetails[0]
        expenseCategoryLabel.text = expenseDetails[1]
        expenseLocationLabel.text = expenseDetails[2]
        expenseDateLabel.text = expenseDetails[3]
        
    }
    
    @IBAction func viewPhoto(_ sender: UIButton) {
        
        performSegue(withIdentifier: "Show Expense Photo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "Show Expense Photo" {
            // Obtain the object reference of the destination view controller
            let expensePhotoViewController: ExpensePhotoViewController = segue.destination as! ExpensePhotoViewController
            
            expensePhotoViewController.photoPath = expenseDetails[4]
        }
        
    }
    
}
