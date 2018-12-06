//
//  MyStocksTableViewController.swift
//  EZFinance
//
//  Created by CS3714 on 12/5/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit

class MyStocksTableViewController: UITableViewController {
    
    // Instance variable holding the object reference of the UITableView UI object created in the Storyboard
    @IBOutlet var companyTableView: UITableView!
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let tableViewRowHeight: CGFloat = 70.0
    
    // Alternate table view rows have a background color of MintCream or OldLace for clarity of display
    
    // Define MintCream color: #F5FFFA  245,255,250
    let MINT_CREAM = UIColor(red: 245.0/255.0, green: 255.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    
    // Define OldLace color: #FDF5E6   253,245,230
    let OLD_LACE = UIColor(red: 253.0/255.0, green: 245.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    //---------- Create and Initialize the Arrays -----------------------
    
    var stockSymbols = [String]()
    
    // companyDataToPass is the data object to pass to the downstream view controller
    var dataToPass = [String]()
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Set up the Edit button on the left of the navigation bar to enable editing of the table view rows
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        /*
         allKeys returns a new array containing the dictionary’s keys as of type AnyObject.
         Therefore, typecast the AnyObject type keys to be of type String.
         The keys in the array are *unordered*; therefore, they need to be sorted.
         */
        stockSymbols = applicationDelegate.dict_MyStocks.allKeys as! [String]
        
        // Sort the stock symbols within itself in alphabetical order
        stockSymbols.sort { $0 < $1 }
    }
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidAppear(_ animated: Bool) {
        /*
         allKeys returns a new array containing the dictionary’s keys as of type AnyObject.
         Therefore, typecast the AnyObject type keys to be of type String.
         The keys in the array are *unordered*; therefore, they need to be sorted.
         */
        stockSymbols = applicationDelegate.dict_MyStocks.allKeys as! [String]
        
        // Sort the stock symbols within itself in alphabetical order
        stockSymbols.sort { $0 < $1 }
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
     --------------------------------------
     MARK: - Table View Data Source Methods
     --------------------------------------
     */
    
    //----------------------------------------
    // Return Number of Sections in Table View
    //----------------------------------------
    
    // We have only one section in the table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    //---------------------------------
    // Return Number of Rows in Section
    //---------------------------------
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stockSymbols.count
    }
    
    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowNumber = (indexPath as NSIndexPath).row
        
        // Obtain the object reference of a reusable table view cell object instantiated under the identifier
        // Company Cell, which was specified in the storyboard
        let cell: MyStocksTableViewCell = tableView.dequeueReusableCell(withIdentifier: "My Stock Cell") as! MyStocksTableViewCell
        
        // Obtain the stock symbol of the given company
        let givenStockSymbol = stockSymbols[rowNumber]
        
        // Obtain the list of data values of the given company as AnyObject
        let companyDataObtained: AnyObject? = applicationDelegate.dict_MyStocks[givenStockSymbol] as AnyObject
        
        // Typecast the AnyObject to Swift array of String objects
        var companyData = companyDataObtained! as! [String]
        
        /*
         companyData[0] = Company Name
         companyData[1] = Number of Stocks
         companyData[2] = Amount Invested
         */
        
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
        let apiUrl = "https://api.iextrading.com/1.0/stock/\(givenStockSymbol)/quote"
        
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
            showAlertMessage(messageHeader: "Symbol Unrecognized!", messageBody: "No company found for the stock symbol \(givenStockSymbol) !")
            cell.stockNameLabel.text! = givenStockSymbol
            cell.changeLabel.text! = "N/A"
            cell.marginLabel.text! = "N/A"
            return cell
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
                
                //**************************
                // Obtain Latest Stock Price
                //**************************
                
                var latestStockPrice = ""
                
                let numStocks = Double(companyData[1])!
                let invested = Double(companyData[2])!
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
                        changeInStockPrice = String(change)
                    } else {
                        changeInStockPrice = "N/A"
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
                        percentChangeInStockPrice = "N/A"
                    }
                }
                
                cell.stockNameLabel.text! = givenStockSymbol
                cell.changeLabel.text! = "\(changeInStockPrice)"
                cell.marginLabel.text! = "\(margin)"
                if Double(margin)! > 0.0 {
                    cell.marginLabel.textColor = UIColor(red: 0, green: 0.8784, blue: 0.2196, alpha: 1.0)
                } else {
                    cell.marginLabel.textColor = UIColor(red: 1, green: 0, blue: 0.0157, alpha: 1.0)
                }
                
                if Double(changeInStockPrice)! > 0.0 {
                    cell.changeLabel.textColor = UIColor(red: 0, green: 0.8784, blue: 0.2196, alpha: 1.0)
                } else {
                    cell.changeLabel.textColor = UIColor(red: 1, green: 0, blue: 0.0157, alpha: 1.0)
                }
                
            } catch let error as NSError {
                
                showAlertMessage(messageHeader: "JSON Data", messageBody: "Error in JSON Data Serialization: \(error.localizedDescription)")
            }
            
        } else {
            showAlertMessage(messageHeader: "JSON Data", messageBody: "Unable to obtain the JSON data file!")
        }
        
        return cell
    }
    
    //-------------------------------
    // Allow Editing of Rows (Cities)
    //-------------------------------
    
    // We allow each row (Company) of the table view to be editable, i.e., deletable
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    //---------------------
    // Delete Button Tapped
    //---------------------
    
    // This is the method invoked when the user taps the Delete button in the Edit mode
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {   // Handle the Delete action
            
            let rowNumber = (indexPath as NSIndexPath).row
            
            // Obtain the stock symbol of the selected Company
            let selectedStockSymbol = stockSymbols[rowNumber]
            
            applicationDelegate.dict_MyStocks.removeObject(forKey: selectedStockSymbol)
            
            stockSymbols = applicationDelegate.dict_MyStocks.allKeys as! [String]
            
            // Sort the stock symbols within itself in alphabetical order
            stockSymbols.sort { $0 < $1 }
            
            // Reload the Table View
            companyTableView.reloadData()
        }
    }
    
    /*
     -----------------------------------
     MARK: - Table View Delegate Methods
     -----------------------------------
     */
    
    // Asks the table view delegate to return the height of a given row.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableViewRowHeight
    }
    
    /*
     Informs the table view delegate that the table view is about to display a cell for a particular row.
     Just before the cell is displayed, we change the cell's background color as MINT_CREAM for even-numbered rows
     and OLD_LACE for odd-numbered rows to improve the table view's readability.
     */
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        /*
         The remainder operator (RowNumber % 2) computes how many multiples of 2 will fit inside RowNumber
         and returns the value, either 0 or 1, that is left over (known as the remainder).
         Remainder 0 implies even-numbered rows; Remainder 1 implies odd-numbered rows.
         */
        if indexPath.row % 2 == 0 {
            // Set even-numbered row's background color to MintCream, #F5FFFA 245,255,250
            cell.backgroundColor = MINT_CREAM
            
        } else {
            // Set odd-numbered row's background color to OldLace, #FDF5E6 253,245,230
            cell.backgroundColor = OLD_LACE
        }
    }
    
    //---------------------------
    // Company (Row) Selected
    //---------------------------
    
    // Tapping a row (Company) displays data about the selected Company
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNumber = (indexPath as NSIndexPath).row
        
        // Obtain the stock symbol of the selected Company
        let selectedStockSymbol = stockSymbols[rowNumber]
        
        // Obtain the list of data values of the given company as AnyObject
        let companyDataObtained: AnyObject? = applicationDelegate.dict_MyStocks[selectedStockSymbol] as AnyObject
        
        // Typecast the AnyObject to Swift array of String objects
        var companyData = companyDataObtained! as! [String]
        
        companyData.append(selectedStockSymbol)
        
        dataToPass = companyData
        
        performSegue(withIdentifier: "Show Stock Info", sender: self)
    }
    
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "Show Stock Info" {
            
            // Obtain the object reference of the destination view controller
            let myStockViewController: MyStockViewController = segue.destination as! MyStockViewController
            
            // Pass the data object to the downstream view controller object
            myStockViewController.dataPassed = dataToPass
            
        }
    }
}
