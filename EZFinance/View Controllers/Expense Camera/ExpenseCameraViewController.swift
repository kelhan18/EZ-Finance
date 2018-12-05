//
//  ExpenseCameraViewController.swift
//  EZFinance
//
//  Created by CS3714 on 12/4/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit

class ExpenseCameraViewController: UIViewController {

    @IBOutlet var createNewExpenseButton: UIButton!
    @IBOutlet var takePictureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func newExpense(_ sender: UIButton) {
        performSegue(withIdentifier: "New Expense", sender: self)
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
        performSegue(withIdentifier: "Take Picture", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "New Expense" {
            
            let newExpenseViewController: NewExpenseViewController = segue.destination as! NewExpenseViewController
            

            
        } else if segue.identifier == "Expense Details" {
            
        }
        
    }
}
