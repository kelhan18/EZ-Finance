//
//  NewExpenseViewController.swift
//  EZFinance
//
//  Created by CS3714 on 12/4/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit

class NewExpenseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var expensePhotoPath: String = ""
    
    //    @IBOutlet var expenseNameTextfield: UITextField!
    
    @IBOutlet var expenseNameLabel: UILabel!
    @IBOutlet var expenseCostTextField: UITextField!
    @IBOutlet var expenseLocationTextField: UITextField!
    @IBOutlet var expenseCategoryPickerView: UIPickerView!
    @IBOutlet var expenseDatePicker: UIDatePicker!
    @IBOutlet var takeExpensePhotoButton: UIButton!
    
    @IBOutlet var speechToTextButton: UIButton!
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var pickerCategories: [String] = [String]()
    var currentBudget: Double = 0
    var category = "Miscellaneous"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerCategories = ["Grocery", "Utilities", "Mortgage", "Health & Fitness", "Entertainment", "Gifts & Donations", "Transportation", "Miscellaneous", "Savings", "Rent", "Travel", "Food", "Clothing"]
        pickerCategories.sort()
        self.expenseCategoryPickerView.delegate = self
        self.expenseCategoryPickerView.dataSource = self
        let numberOfRowToShow = Int(pickerCategories.count / 2)
        expenseCategoryPickerView.selectRow(numberOfRowToShow, inComponent: 0, animated: false)
    }
    
    
    
    @IBAction func speechToTextTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "Speech to Text", sender: self)
    }
    
    
    
    /*
     ---------------------------
     MARK: - Unwind Segue Method
     ---------------------------
     */
    @IBAction func unwindToNewExpense(segue : UIStoryboardSegue) {
        
        if segue.identifier != "AddStT-Save" {
            return
        }
        print("this works")
        let speechToTextViewController: SpeechToTextViewController = segue.source as! SpeechToTextViewController
        print(speechToTextViewController.givenTextView.text!)
        //Get the added fields
        let textviewText: String! = speechToTextViewController.givenTextView.text!
        
        // Input validation
        if textviewText.isEmpty {
            showAlertMessage(messageHeader: "Empty name from speech to text", messageBody: "Please enter an Expense Name!")
            return
        }
        
        expenseNameLabel.text = textviewText
        
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
    
    /*
     -----------------------------
     MARK: - Display Alert Message
     -----------------------------
     */
    func showAlertMessage(messageHeader header: String, messageBody body: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertController.Style.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
        
    }
    
}
