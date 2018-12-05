//
//  NewExpenseViewController.swift
//  EZFinance
//
//  Created by CS3714 on 12/4/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit

class NewExpenseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet var expenseNameTextfield: UITextField!
    @IBOutlet var expenseCostTextField: UITextField!
    @IBOutlet var expenseLocationTextField: UITextField!
    @IBOutlet var expenseCategoryPickerView: UIPickerView!
    @IBOutlet var expenseDatePicker: UIDatePicker!
    @IBOutlet var takeExpensePhotoButton: UIButton!
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var pickerCategories: [String] = [String]()
    var currentBudget: Double = 0
    var category = "Miscellaneous"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerCategories = ["Grocery", "Utilities", "Mortgage", "Health & Fitness", "Entertainment", "Gifts & Donations", "Transportation", "Miscellaneous", "Savings", "Rent"]
        self.expenseCategoryPickerView.delegate = self
        self.expenseCategoryPickerView.dataSource = self
        let numberOfRowToShow = Int(pickerCategories.count / 2)
        expenseCategoryPickerView.selectRow(numberOfRowToShow, inComponent: 0, animated: false)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerCategories[row]
    }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        category = pickerCategories[row] as String
    }
    
    
    @IBAction func keyboardDone(_ sender: UITextField) {
        
        sender.resignFirstResponder()
        
    }
    
    @IBAction func backgroundTouch(_ sender: UIControl) {
        
        view.endEditing(true)
        
    }

}
