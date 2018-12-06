//
//  MyStockViewController.swift
//  EZFinance
//
//  Created by CS3714 on 12/5/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit

class MyStockViewController: UIViewController {
    
    var dataPassed = [String]()
    
    @IBOutlet var stockNameLabel: UILabel!
    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var stockPriceLabel: UILabel!
    @IBOutlet var stockPriceLowLabel: UILabel!
    @IBOutlet var stockHighLabel: UILabel!
    @IBOutlet var amountInvestedLabel: UILabel!
    @IBOutlet var ftWeekLowLabel: UILabel!
    @IBOutlet var ftWeekHighLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var numStocksTextField: UITextField!
    @IBOutlet var priceChangeLabel: UILabel!
    @IBOutlet var marginLabel: UILabel!
    @IBOutlet var ownedLabel: UILabel!
    
    var currentPrice = ""
    var oldNumStocks = 0
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /*
     dataPassed[0] = Company Name
     dataPassed[1] = Number of Stocks
     dataPassed[2] = Amount Invested
     dataPassed[3] = Stock Symbol
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stockNameLabel.text! = dataPassed[3]
        companyNameLabel.text! = dataPassed[0]
        oldNumStocks = Int(dataPassed[1])!
        
        // Set the API URL to obtain the JSON file containing the stock quote for the stock symbol entered
        let apiUrl = "https://api.iextrading.com/1.0/stock/\(dataPassed[3])/quote"
        
        // Create a URL struct data structure from the API URL string
        let url = URL(string: apiUrl)
        
        /*
         We use the Data object constructor below to download the JSON data via HTTP in a single thread in this method.
         Downloading large amount of data via HTTP in a single thread would result in poor performance.
         For better performance, NSURLSession should be used.
         */
        
        let jsonData: Data?
        
        do {
            /*
             Try getting the JSON data from the URL and map it into virtual memory, if possible and safe.
             Option mappedIfSafe indicates that the file should be mapped into virtual memory, if possible and safe.
             */
            jsonData = try Data(contentsOf: url!, options: Data.ReadingOptions.mappedIfSafe)
            
        } catch {
            showAlertMessage(messageHeader: "Symbol Unrecognized!", messageBody: "No company found for the stock symbol \(dataPassed[3]) !")
            return
        }
        
        if let jsonDataFromApiUrl = jsonData {
            
            // The JSON data is successfully obtained from the API
            
            do {
                /*
                 JSONSerialization class is used to convert JSON and Foundation objects (e.g., NSDictionary) into each other.
                 JSONSerialization class method jsonObject returns an NSDictionary object from the given JSON data.
                 */
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl,
                                                                          options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                
                // Typecast the returned NSDictionary as Dictionary<String, AnyObject>
                let dictionaryOfCompanyJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                
                /*
                 VALID SYMBOL:
                 https://api.iextrading.com/1.0/stock/AAPL/quote
                 {
                 See above
                 }
                 
                 INVALID SYMBOL:
                 https://api.iextrading.com/1.0/stock/INVALID/company
                 {
                 Unknown symbol
                 }
                 */
                
                //********************
                // Obtain Company Name
                //********************
                
                var companyName = ""
                
                if (dictionaryOfCompanyJsonData["companyName"]?.isEqual(to: ""))! {
                    showAlertMessage(messageHeader: "Symbol Unrecognized!", messageBody: "No company found for the stock symbol \(dataPassed[3]) !")
                    return
                }
                
                if let nameOfCompany = dictionaryOfCompanyJsonData["companyName"] as! String? {
                    companyName = nameOfCompany
                } else {
                    companyName = "Unable to obtain!"
                }
                
                //************************
                // Define Company Logo URL
                //************************
                
                let companyLogoURL = "https://storage.googleapis.com/iex/api/logos/\(dataPassed[3]).png"
                
                //************************
                // Obtain Company Exchange
                //************************
                
                var companyExchange = ""
                
                if dictionaryOfCompanyJsonData["primaryExchange"] is NSNull {
                    companyExchange = "None"
                } else {
                    if let primaryExchange = dictionaryOfCompanyJsonData["primaryExchange"] as! String? {
                        companyExchange = primaryExchange
                    } else {
                        companyExchange = "None"
                    }
                }
                
                //**************************
                // Obtain Latest Stock Price
                //**************************
                
                var latestStockPrice = ""
                
                if dictionaryOfCompanyJsonData["latestPrice"] is NSNull {
                    latestStockPrice = "None"
                } else {
                    if let latestPrice = dictionaryOfCompanyJsonData["latestPrice"] as! Double? {
                        latestStockPrice = "$" + String(latestPrice)
                    } else {
                        latestStockPrice = "None"
                    }
                }
                
                //*******************************
                // Obtain Latest Stock Price Time
                //*******************************
                
                var latestStockPriceTime = ""
                let numStocks = Double(dataPassed[1])!
                let invested = Double(dataPassed[2])!
                var margin = ""
                
                if dictionaryOfCompanyJsonData["latestPrice"] is NSNull {
                    latestStockPrice = "None"
                } else {
                    if let latestPrice = dictionaryOfCompanyJsonData["latestPrice"] as! Double? {
                        latestStockPrice = String(latestPrice)
                        let currentVal = latestPrice * numStocks
                        let diff = currentVal - invested
                        margin = String(Double(round(1000 * diff) / 1000))
                    } else {
                        latestStockPrice = "None"
                        margin = "N/A"
                    }
                }
                
                //*****************************
                // Obtain Change in Stock Price
                //*****************************
                
                var changeInStockPrice = ""
                
                if dictionaryOfCompanyJsonData["change"] is NSNull {
                    changeInStockPrice = "None"
                } else {
                    if let change = dictionaryOfCompanyJsonData["change"] as! Double? {
                        changeInStockPrice = "$" + String(change)
                    } else {
                        changeInStockPrice = "None"
                    }
                }
                
                //*************************************
                // Obtain Percent Change in Stock Price
                //*************************************
                
                var percentChangeInStockPrice = ""
                
                if dictionaryOfCompanyJsonData["changePercent"] is NSNull {
                    percentChangeInStockPrice = "None"
                } else {
                    if let changePercent = dictionaryOfCompanyJsonData["changePercent"] as! Double? {
                        percentChangeInStockPrice = String(100 * changePercent) + "%"
                    } else {
                        percentChangeInStockPrice = "None"
                    }
                }
                
                //*********************************
                // Obtain Price/Earnings (PE) Ratio
                //*********************************
                
                var priceEarningsRatio = ""
                
                if dictionaryOfCompanyJsonData["peRatio"] is NSNull {
                    priceEarningsRatio = "None"
                } else {
                    if let peRatio = dictionaryOfCompanyJsonData["peRatio"] as! Double? {
                        priceEarningsRatio = String(peRatio)
                    } else {
                        priceEarningsRatio = "None"
                    }
                }
                
                //************************************************
                // Obtain Highest Stock Price in the Last 52 Weeks
                //************************************************
                
                var highestStockPriceIn52Weeks = ""
                
                if dictionaryOfCompanyJsonData["week52High"] is NSNull {
                    highestStockPriceIn52Weeks = "None"
                } else {
                    if let week52High = dictionaryOfCompanyJsonData["week52High"] as! Double? {
                        highestStockPriceIn52Weeks = "$" + String(week52High)
                    } else {
                        highestStockPriceIn52Weeks = "None"
                    }
                }
                
                //***********************************************
                // Obtain Lowest Stock Price in the Last 52 Weeks
                //***********************************************
                
                var lowestStockPriceIn52Weeks = ""
                
                if dictionaryOfCompanyJsonData["week52Low"] is NSNull {
                    lowestStockPriceIn52Weeks = "None"
                } else {
                    if let week52Low = dictionaryOfCompanyJsonData["week52Low"] as! Double? {
                        lowestStockPriceIn52Weeks = "$" + String(week52Low)
                    } else {
                        lowestStockPriceIn52Weeks = "None"
                    }
                }
                
                var lowestStockPrice = ""
                
                if dictionaryOfCompanyJsonData["low"] is NSNull {
                    lowestStockPrice = "None"
                } else {
                    if let low = dictionaryOfCompanyJsonData["low"] as! Double? {
                        lowestStockPrice = "$" + String(low)
                    } else {
                        lowestStockPrice = "None"
                    }
                }
                
                var highestStockPrice = ""
                
                if dictionaryOfCompanyJsonData["high"] is NSNull {
                    highestStockPrice = "None"
                } else {
                    if let high = dictionaryOfCompanyJsonData["high"] as! Double? {
                        highestStockPrice = "$" + String(high)
                    } else {
                        highestStockPrice = "None"
                    }
                }
                
                currentPrice = latestStockPrice
                stockPriceLabel.text! = "Stock Price: \(latestStockPrice)"
                stockPriceLowLabel.text! = "Stock Price Low: \(lowestStockPrice)"
                stockHighLabel.text! = "Stock Price High: \(highestStockPrice)"
                ftWeekLowLabel.text! = "52 Week Low: \(lowestStockPriceIn52Weeks)"
                ftWeekHighLabel.text! = "52 Week High: \(highestStockPriceIn52Weeks)"
                //                percentChangeLabel.text! = "Stock Percent Change: \(percentChangeInStockPrice)"
                priceChangeLabel.text! = "Stock Price Change: \(changeInStockPrice)"
                marginLabel.text! = "Profit Margin: \(margin)"
                ownedLabel.text! = "Stocks Owned: \(numStocks)"
                amountInvestedLabel.text! = "Amount Invested: \(round(Double(dataPassed[2])! * 1000) / 1000)"
                
            } catch let error as NSError {
                
                showAlertMessage(messageHeader: "JSON Data", messageBody: "Error in JSON Data Serialization: \(error.localizedDescription)")
                return
            }
            
        } else {
            showAlertMessage(messageHeader: "JSON Data", messageBody: "Unable to obtain the JSON data file!")
        }
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
        
        let oldInvested = dataPassed[2]
        var newNumStocks = Int()
        var newInvested = Double()
        
        if (sender.tag == 1) {
            // Add
            
            //print(stockPriceLabel.text!)
            
            newNumStocks = Int(numStocks)! + Int(oldNumStocks)
            newInvested = Double(oldInvested)! + (Double(numStocks)! * Double(currentPrice)!)
            
            let data = [compName, String(newNumStocks), String(newInvested)]
            
            applicationDelegate.dict_MyStocks.removeObject(forKey: stockSymbolEntered as NSCopying)
            
            applicationDelegate.dict_MyStocks.setObject(data, forKey: stockSymbolEntered as NSCopying)
            
            oldNumStocks = newNumStocks
            
        } else {
            // Remove
            
            if (Double(oldNumStocks) < Double(numStocks)!) {
                showAlertMessage(messageHeader: "Cannot sell more stocks than you own!", messageBody: "Please enter a proper amount!")
                return
            }
            
            newNumStocks = Int(oldNumStocks) - Int(numStocks)!
            newInvested = Double(oldInvested)! - (Double(numStocks)! * Double(currentPrice)!)
            
            let data = [compName, String(newNumStocks), String(newInvested)]
            
            applicationDelegate.dict_MyStocks.removeObject(forKey: stockSymbolEntered as NSCopying)
            
            applicationDelegate.dict_MyStocks.setObject(data, forKey: stockSymbolEntered as NSCopying)
            
            oldNumStocks = newNumStocks
        }
        
        ownedLabel.text! = "Stocks Owned: \(newNumStocks)"
        amountInvestedLabel.text! = "Amount Invested: \(round(newInvested * 1000) / 1000)"
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
