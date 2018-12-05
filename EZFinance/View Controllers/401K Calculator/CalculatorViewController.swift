//
//  401kCalculatorViewController.swift
//  EZFinance
//
//  Created by Keller Han on 12/3/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    
    @IBOutlet var percentToContributeTextField: UITextField!
    @IBOutlet var annualSalaryTextField: UITextField!
    @IBOutlet var annualSalaryIncreaseTextField: UITextField!
    @IBOutlet var currentAgeTextField: UITextField!
    @IBOutlet var ageOfRetirementTextField: UITextField!
    @IBOutlet var currentBalanceTextField: UITextField!
    @IBOutlet var annualRateOfReturnTextField: UITextField!
    @IBOutlet var employerMatchPercentageTextField: UITextField!
    @IBOutlet var employerMatchMaxPercentageTextField: UITextField!
    
    @IBAction func calculateButtonPressed(_ sender: Any) {
        // Perform the segue
        if Double(self.percentToContributeTextField.text!) != nil {
            percentToContribute = percentToContributeTextField.text!
        }
        else {
            showAlertMessage(messageHeader: "Unrecognized Input", messageBody: "Please enter a valid % to Contribute! (Numbers Only, Ex: 10 for 10%")
        }
        if Double(self.annualSalaryTextField.text!) != nil {
            annualSalary = annualSalaryTextField.text!
        }
        else {
            showAlertMessage(messageHeader: "Unrecognized Input", messageBody: "Please enter a valid Annual Salary! (Numbers Only, Ex: 100000 for $100k")
        }
        if Double(self.annualSalaryIncreaseTextField.text!) != nil {
            annualSalaryIncrease = annualSalaryIncreaseTextField.text!
        }
        else {
            showAlertMessage(messageHeader: "Unrecognized Input", messageBody: "Please enter a valid Annual Salary Increase! (Numbers Only, Ex: 3 for 3%")
        }
        if Double(self.currentAgeTextField.text!) != nil {
            currentAge = currentAgeTextField.text!
        }
        else {
            showAlertMessage(messageHeader: "Unrecognized Input", messageBody: "Please enter a valid Current Age!")
        }
        if Double(self.ageOfRetirementTextField.text!) != nil {
            ageOfRetirement = ageOfRetirementTextField.text!
        }
        else {
            showAlertMessage(messageHeader: "Unrecognized Input", messageBody: "Please enter a valid Age of Retirement!")
        }
        if Double(self.currentBalanceTextField.text!) != nil {
            currentBalance = currentBalanceTextField.text!
        }
        else {
            showAlertMessage(messageHeader: "Unrecognized Input", messageBody: "Please enter a valid Current Balance! (Numbers Only, Ex: 10000 for $10k")
        }
        if Double(self.annualRateOfReturnTextField.text!) != nil {
            annualRateOfReturn = annualRateOfReturnTextField.text!
        }
        else {
            showAlertMessage(messageHeader: "Unrecognized Input", messageBody: "Please enter a valid ARR! (Numbers Only, Ex: 7 for 7%")
        }
        if Double(self.employerMatchPercentageTextField.text!) != nil {
            employerMatchPercentage = employerMatchPercentageTextField.text!
        }
        else {
            showAlertMessage(messageHeader: "Unrecognized Input", messageBody: "Please enter a valid Employer Match %! (Numbers Only, Ex: 50 for 50%")
        }
        if Double(self.employerMatchMaxPercentageTextField.text!) != nil {
            employerMatchMaxPercentage = employerMatchMaxPercentageTextField.text!
        }
        else {
            showAlertMessage(messageHeader: "Unrecognized Input", messageBody: "Please enter a valid Employer Match Max %! (Numbers Only, Ex: 6 for 6%")
        }
        
        infoToPass = [percentToContribute, annualSalary, annualSalaryIncrease, currentAge, ageOfRetirement, currentBalance, annualRateOfReturn, employerMatchPercentage, employerMatchMaxPercentage]
        performSegue(withIdentifier: "Show 401k Results", sender: self)
    }
    
    var percentToContribute : String = ""
    var annualSalary : String = ""
    var annualSalaryIncrease : String = ""
    var currentAge : String = ""
    var ageOfRetirement : String = ""
    var currentBalance : String = ""
    var annualRateOfReturn : String = ""
    var employerMatchPercentage : String = ""
    var employerMatchMaxPercentage : String = ""
    
    var infoToPass = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //if let amount = Double(self.amountTextField.text!) {
        
        
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
    
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "Show 401k Results" {
            
            // Obtain the object reference of the destination view controller
            let calculatorResultsViewController: CalculatorResultsViewController = segue.destination as! CalculatorResultsViewController
            
            // Pass the data object to the downstream view controller object
            calculatorResultsViewController.infoPassed = infoToPass
            
        }
    }
    
    /*
     ------------------------
     MARK: - IBAction Methods
     ------------------------
     */
    @IBAction func keyboardDone(_ sender: UITextField) {
        
        // When the Text Field resigns as first responder, the keyboard is automatically removed.
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTouch(_ sender: UIControl) {
        /*
         "This method looks at the current view and its subview hierarchy for the text field that is
         currently the first responder. If it finds one, it asks that text field to resign as first responder.
         If the force parameter is set to true, the text field is never even asked; it is forced to resign." [Apple]
         
         When the Text Field resigns as first responder, the keyboard is automatically removed.
         */
        view.endEditing(true)
    }
    
}
