//
//  StockSearchedViewController.swift
//  EZFinance
//
//  Created by CS3714 on 12/5/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit

class StockSearchedViewController: UIViewController {
    
    var dataPassed = [String]()

    @IBOutlet var stockNameLabel: UILabel!
    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var stockPriceLabel: UILabel!
    @IBOutlet var stockPriceLowLabel: UILabel!
    @IBOutlet var stockHighLabel: UILabel!
    @IBOutlet var percentChangeLabel: UILabel!
    @IBOutlet var ftWeekLowLabel: UILabel!
    @IBOutlet var ftWeekHighLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var numStocksTextField: UITextField!
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /*
     dataPassed[0] = Stock Symbol
     dataPassed[1] = Company Name
     dataPassed[2] = Company Logo URL
     dataPassed[3] = Company Exchange
     dataPassed[4] = Latest Stock Price
     dataPassed[5] = Latest Stock Price Time
     dataPassed[6] = Change in Stock Price
     dataPassed[7] = Percent Change in Stock Price
     dataPassed[8] = Price / Earnings Ratio
     dataPassed[9] = Highest Stock Price in the Last 52 Weeks
     dataPassed[10] = Lowest Stock Price in the Last 52 Weeks
     dataPassed[11] = Highest Stock Price Today
     dataPassed[12] = Lowest Stock Price Today
     */

    override func viewDidLoad() {
        super.viewDidLoad()

        stockNameLabel.text! = dataPassed[0]
        companyNameLabel.text! = dataPassed[1]
        stockPriceLabel.text! = "Stock Price: \(dataPassed[4])"
        stockPriceLowLabel.text! = "Stock Price Low: \(dataPassed[12])"
        stockHighLabel.text! = "Stock Price High: \(dataPassed[11])"
        ftWeekLowLabel.text! = "52 Week Low: \(dataPassed[10])"
        ftWeekHighLabel.text! = "52 Week High: \(dataPassed[9])"
        percentChangeLabel.text! = "Stock Percent Change: \(dataPassed[7])"
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        // Get the stock symbol entered by the user on the AddCompanyViewController's UI
        let stockSymbol: String = stockNameLabel.text!
        let compName: String = companyNameLabel.text!
        let numStocks = numStocksTextField.text!
        
        /*********************
         Input Data Validation
         *********************/
        
        // Stock symbol cannot have spaces in the API URL: delete all spaces and new line characters
        let stockSymbolEntered: String = stockSymbol.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if numStocks.isEmpty {
            showAlertMessage(messageHeader: "No Amount Specified", messageBody: "Please enter amount of stocks!")
            return
        }
        
        print(dataPassed[4])
        
        let invested = Double(numStocks)! * Double(dataPassed[4])!
        
        let data = [String(compName), String(numStocks), String(invested)]
        
        applicationDelegate.dict_MyStocks.setObject(data, forKey: stockSymbolEntered as NSCopying)
        
        // TODO send to table view
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
