//
//  StockSearchViewController.swift
//  EZFinance
//
//  Created by CS3714 on 12/5/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit

class StockSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // Instance variable holding the object reference of the TextField UI object created in the Storyboard
    @IBOutlet var stockSymbolTextField: UITextField!
    
    // dataToPass is the data object to pass to the downstream view controller
    var dataToPass = [String]()
    
    // This method is invoked when the Get Stock Quote button is tapped
    @IBAction func searchButtonTapped (_ sender: UIButton) {
        
        // Get the stock symbol entered by the user
        let stockSymbolObtained: String = stockSymbolTextField.text!
        
        /*********************
         Input Data Validation
         *********************/
        
        // Stock symbol cannot have spaces in the API URL: delete all spaces and new line characters
        let stockSymbolEntered: String = stockSymbolObtained.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if stockSymbolEntered.isEmpty {
            showAlertMessage(messageHeader: "No Stock Symbol Entered!", messageBody: "Please enter a Stock Symbol!")
            return
        }
        
        /*
         ------------------------------------------------------------------------------
         Obtain the stock quote JSON data from the IEX API for the entered stock symbol
         ------------------------------------------------------------------------------
         */
        
        /*
         https://api.iextrading.com/1.0/stock/AAPL/quote
         {
         --->   "symbol":"AAPL",
         --->   "companyName":"Apple Inc.",
         --->   "primaryExchange":"Nasdaq Global Select",
         "sector":"Technology",
         "calculationPrice":"close",
         "open":221.94,
         "openTime":1536327000325,
         "close":221.3,
         "closeTime":1536350400295,
         "high":225.37,
         "low":220.71,
         --->   "latestPrice":221.3,
         "latestSource":"Close",
         --->   "latestTime":"September 7, 2018",
         "latestUpdate":1536350400295,
         "latestVolume":37418383,
         "iexRealtimePrice":null,
         "iexRealtimeSize":null,
         "iexLastUpdated":null,
         "delayedPrice":221.3,
         "delayedPriceTime":1536350400295,
         "extendedPrice":221.25,
         "extendedChange":-0.05,
         "extendedChangePercent":-0.00023,
         "extendedPriceTime":1536353993508,
         "previousClose":223.1,
         --->   "change":-1.8,
         --->   "changePercent":-0.00807,
         "iexMarketPercent":null,
         "iexVolume":null,
         "avgTotalVolume":30579275,
         "iexBidPrice":null,
         "iexBidSize":null,
         "iexAskPrice":null,
         "iexAskSize":null,
         "marketCap":1068862623800,
         --->   "peRatio":21.36,
         --->   "week52High":229.67,
         --->   "week52Low":149.16,
         "ytdChange":0.2913694736007685
         }
         */
        
        // Set the API URL to obtain the JSON file containing the stock quote for the stock symbol entered
        let apiUrl = "https://api.iextrading.com/1.0/stock/\(stockSymbolEntered)/quote"
        
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
            showAlertMessage(messageHeader: "Symbol Unrecognized!", messageBody: "No company found for the stock symbol \(stockSymbolEntered) !")
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
                    showAlertMessage(messageHeader: "Symbol Unrecognized!", messageBody: "No company found for the stock symbol \(stockSymbolEntered) !")
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
                
                let companyLogoURL = "https://storage.googleapis.com/iex/api/logos/\(stockSymbolEntered).png"
                
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
                        latestStockPrice = String(latestPrice)
                    } else {
                        latestStockPrice = "None"
                    }
                }
                
                //*******************************
                // Obtain Latest Stock Price Time
                //*******************************
                
                var latestStockPriceTime = ""
                
                if dictionaryOfCompanyJsonData["latestTime"] is NSNull {
                    latestStockPriceTime = "None"
                } else {
                    if let latestTime = dictionaryOfCompanyJsonData["latestTime"] as! String? {
                        latestStockPriceTime = latestTime
                    } else {
                        latestStockPriceTime = "None"
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


                
                //***************************************************
                // Create an array containing all of the company data
                //***************************************************
                
                dataToPass = [stockSymbolEntered, companyName, companyLogoURL, companyExchange, latestStockPrice, latestStockPriceTime, changeInStockPrice, percentChangeInStockPrice, priceEarningsRatio, highestStockPriceIn52Weeks, lowestStockPriceIn52Weeks, highestStockPrice, lowestStockPrice]
                
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
                
                performSegue(withIdentifier: "Stock Searched View", sender: self)
                
            } catch let error as NSError {
                
                showAlertMessage(messageHeader: "JSON Data", messageBody: "Error in JSON Data Serialization: \(error.localizedDescription)")
                return
            }
            
        } else {
            showAlertMessage(messageHeader: "JSON Data", messageBody: "Unable to obtain the JSON data file!")
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
        
        if segue.identifier == "Stock Searched View" {
            
//            // Obtain the object reference of the destination view controller
            let stockSearchedViewController: StockSearchedViewController = segue.destination as! StockSearchedViewController
            
            // Pass the data object to the downstream view controller object
            stockSearchedViewController.dataPassed = dataToPass
        }
    }

}
