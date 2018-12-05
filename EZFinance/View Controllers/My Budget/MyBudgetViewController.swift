//
//  MyBudgetViewController.swift
//  EZFinance
//
//  Created by CS3714 on 12/4/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//
import LocalAuthentication
import UIKit

class MyBudgetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet var budgetAmount: UILabel!
    @IBOutlet var expensesTableView: UITableView!
    @IBOutlet var optionsSegmentedControl: UISegmentedControl!
    
    
    // Define MintCream color: #F5FFFA  245,255,250
    let MINT_CREAM = UIColor(red: 245.0/255.0, green: 255.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    // Define OldLace color: #FDF5E6   253,245,230
    let OLD_LACE = UIColor(red: 253.0/255.0, green: 245.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    var expenses = [String]()
    var expenseDataToPass = [String]()
    var expenseNameToPass: String = ""
    var optionType = ""
    var currentBudget: Double = 0
    var totalExpense: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Authenticate { (success) in
            print(success)
        }
        
        optionsSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
        expenses = applicationDelegate.dict_Expense_ExpenseData.allKeys as! [String]
        expenses.sort { $0 < $1 }
        
        let budgetamount = applicationDelegate.myBudget["budget"]! as! String
        let totalExpenseFromDict = applicationDelegate.myBudget["totalExpense"]! as! String
        budgetAmount.text = "$\(budgetamount)"
        currentBudget = Double(budgetamount) ?? 0
        totalExpense = Double(totalExpenseFromDict) ?? 0
    }
    
    //Function called in viewDidLoad(). Determine if user is properly authenticated
    func Authenticate(completion: @escaping ((Bool) -> ())){
        //Create a context
        let authenticationContext = LAContext()
        var error:NSError?
        
        //Check if device have Biometric sensor
        let isValidSensor : Bool = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        //If it has biometric sensor, check to see if authentication passes
        if isValidSensor {
            authenticationContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Touch / Face ID authentication",
                reply: { [unowned self] (success, error) -> Void in
                    
                    if(success) {
                        //Touch/Face ID success, return true
                        completion(true)
                    } else {
                        //Touch/Face ID fail, return false and error message
                        if error != nil {
                            self.showAlertMessage(messageHeader: "Error", messageBody: "Encountered Error")
                        }
                        completion(false)
                    }
            })
        } else {
            self.showAlertMessage(messageHeader: "Error", messageBody: "Encountered Error")
        }
    }
    
    
    /*
     ---------------------------
     MARK: - Unwind Segue Method
     ---------------------------
     */
    @IBAction func unwindToMyBudget_Deposit(segue : UIStoryboardSegue) {
        
        if segue.identifier != "AddDeposit-Save" {
            return
        }
        
        let depositViewController: DepositViewController = segue.source as! DepositViewController
        
        //Get the added fields
        let depositAmount: String! = depositViewController.depositAmountTextField.text!
        
        let characterset = CharacterSet(charactersIn: "0123456789.")
        if depositAmount.rangeOfCharacter(from: characterset.inverted) != nil {
            showAlertMessage(messageHeader: "Deposit must be a number", messageBody: "Please enter a valid positive number!")
            return
        }
        
        // Input validation
        if depositAmount.isEmpty {
            showAlertMessage(messageHeader: "Empty Deposit", messageBody: "Please enter a positive deposit!")
            return
        } else if Double(depositAmount)! <= 0 {
            showAlertMessage(messageHeader: "Negative Amount", messageBody: "Please enter a positive deposit!")
            return
        }
        print(depositAmount)
        currentBudget = currentBudget + Double(depositAmount)!
        
        let fixedString = String(format: "%.2f", currentBudget)
        
        budgetAmount.text = "$\(fixedString)"

        applicationDelegate.myBudget.setObject(fixedString, forKey: (("budget" as NSCopying) as! String as NSCopying))

        expenses = applicationDelegate.dict_Expense_ExpenseData.allKeys as! [String]
        expenses.sort { $0 < $1 }
        expensesTableView.reloadData()
    }

    /*
     ---------------------------
     MARK: - Unwind Segue Method
     ---------------------------
     */
    @IBAction func unwindToMyBudget_NewExpense(segue : UIStoryboardSegue) {
        
        if segue.identifier != "AddExpense-Save" {
            return
        }
        
        let newExpenseViewController: NewExpenseViewController = segue.source as! NewExpenseViewController
        
        let expenseName = newExpenseViewController.expenseNameTextfield.text!
        let expenseCost = newExpenseViewController.expenseCostTextField.text!
        let expenseLocation = newExpenseViewController.expenseLocationTextField.text!
        let expenseCategory = newExpenseViewController.category
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm-dd-yyyy"
        let exenseDateObtained: String = dateFormatter.string(from: newExpenseViewController.expenseDatePicker.date)
        //Get the added fields

        let characterset = CharacterSet(charactersIn: "0123456789.")
        if expenseCost.rangeOfCharacter(from: characterset.inverted) != nil {
            showAlertMessage(messageHeader: "Expense Cost must be a number", messageBody: "Please enter a valid positive number!")
            return
        }
        
        if expenseName.isEmpty {
            showAlertMessage(messageHeader: "Empty Expense Name", messageBody: "Please enter an Expense Name!")
            return
        } else if expenseCost.isEmpty || Int(expenseCost)! <= 0{
            showAlertMessage(messageHeader: "Empty Expense Cost", messageBody: "Please enter an Expense Cost!")
            return
        } else if expenseLocation.isEmpty {
            showAlertMessage(messageHeader: "Empty Expense Location", messageBody: "Please enter an Expense Location!")
            return
        }
        
        let expenseData: [String] = [expenseCost, expenseCategory, expenseLocation, exenseDateObtained, "photo.png"]
        
        applicationDelegate.dict_Expense_ExpenseData.setValue(expenseData, forKey: (expenseName as NSCopying) as! String)
        
        currentBudget = currentBudget - Double(expenseCost)!
        totalExpense = totalExpense + Double(expenseCost)!
        
        let fixedString1 = String(format: "%.2f", totalExpense)
        let fixedString2 = String(format: "%.2f", currentBudget)
        budgetAmount.text = "$\(fixedString2)"
        print(applicationDelegate.myBudget)
        applicationDelegate.myBudget.setObject(fixedString2, forKey: (("budget" as NSCopying) as! String as NSCopying))
        applicationDelegate.myBudget.setObject(fixedString1, forKey: (("totalExpense" as NSCopying) as! String as NSCopying))
        print(applicationDelegate.myBudget)
        expenses = applicationDelegate.dict_Expense_ExpenseData.allKeys as! [String]
        expenses.sort { $0 < $1 }
        expensesTableView.reloadData()
    }
    
    
    // Informs the table view delegate that the specified row is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNumber = (indexPath as NSIndexPath).row
        // Obtain the video id of the selected Video
        let expenseName = expenses[rowNumber]
        let expenseDataObtained: [String] = applicationDelegate.dict_Expense_ExpenseData["\(expenseName)"]! as! [String]
        expenseDataToPass = expenseDataObtained
        expenseNameToPass = expenseName
        
        performSegue(withIdentifier: "Expense Details", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: BudgetTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Expense Cell", for: indexPath) as! BudgetTableViewCell
        let rowNumber = (indexPath as NSIndexPath).row
        let expenseName = expenses[rowNumber]
        let expenseDataObtained: [String] = applicationDelegate.dict_Expense_ExpenseData["\(expenseName)"]! as! [String]
        
        cell.expenseTitleLabel!.text = expenseName
        cell.expenseCostLabel!.text = "$\(expenseDataObtained[0])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = MINT_CREAM
        } else {
            cell.backgroundColor = OLD_LACE
        }
    }
    
    @IBAction func performOption(_ sender: UISegmentedControl) {
        
        
        switch sender.selectedSegmentIndex {
        case 0:
            optionType = "Deposit"
        case 1:
            optionType = "New Expense"
        case 2:
            optionType = "Statistics"
        default:
            return
        }
        
        if optionType == "Deposit" {
            performSegue(withIdentifier: "Deposit Money", sender: self)
        } else if optionType == "New Expense" {
            performSegue(withIdentifier: "New Expense", sender: self)
        } else if optionType == "Statistics" {
            performSegue(withIdentifier: "Statistics", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        optionsSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "New Expense" {
            // Obtain the object reference of the destination view controller
            let newExpenseViewController: NewExpenseViewController = segue.destination as! NewExpenseViewController
            
            newExpenseViewController.currentBudget = currentBudget
            
        } else if segue.identifier == "Expense Details" {
            // Obtain the object reference of the destination view controller
            let expenseDetailsViewController: ExpenseDetailsViewController = segue.destination as! ExpenseDetailsViewController
            
            expenseDetailsViewController.expenseDetails = expenseDataToPass
            expenseDetailsViewController.expenseName = expenseNameToPass
        } else if segue.identifier == "Statistics" {
            // Obtain the object reference of the destination view controller
            let statisticsViewController: StatisticsViewController = segue.destination as! StatisticsViewController
            
            statisticsViewController.totalExpense = totalExpense
        }
        
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
