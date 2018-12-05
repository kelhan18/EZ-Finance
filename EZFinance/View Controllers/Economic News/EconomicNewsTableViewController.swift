//
//  TopNewsTableViewController.swift
//  News
//
//  Created by Keller Han on 10/9/18.
//  Copyright © 2018 Keller Han. All rights reserved.
//

import UIKit

//Wrapper class to store the data from API call. Allows easier passing of data to downstream view controllers

class Wrapper: NSObject {
    var source = ""
    var sourceName = ""
    var author = ""
    var title = ""
    var descrip = ""
    var url = ""
    var urlToImage = ""
    var publishedAt = ""
    var content = ""
}

class EconomicNewsTableViewController: UITableViewController {
    
    @IBOutlet var economicNewsTableView: UITableView!
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let tableViewRowHeight: CGFloat = 102.0
    
    // Alternate table view rows have a background color of MintCream or OldLace for clarity of display
    
    // Define MintCream color: #F5FFFA  245,255,250
    let MINT_CREAM = UIColor(red: 245.0/255.0, green: 255.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    
    // Define OldLace color: #FDF5E6   253,245,230
    let OLD_LACE = UIColor(red: 253.0/255.0, green: 245.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    //---------- Create and Initialize the Arrays -----------------------
    
    var newsInfo = [Wrapper]()
    var newsDataObtained : Wrapper!
    //newsDataToPass is the data object to pass to the downstream view controller
    var newsDataToPass = [String]()
    /*
     -----------------------------
     MARK: - Display Alert Message
     -----------------------------
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        //Connect to News API on load
        self.connectApi()
    }
    
    //Called when view is successfully loaded
    //Makes a URLRequest to the api with personal key
    //Stores news data in a dictionary, and then loops through that dictionay to retrieve the fields of interest from the api.
    //Stores that data in a wrapper class and appends it to our dictionary of newsInfo
    func connectApi() {
        //API Key: e043e9af6caf45c29e56cb5af967a854
        
        //Financial Times (requires subscription)
        //let urlString : String = "https://newsapi.org/v2/top-headlines?sources=financial-times&apiKey=e043e9af6caf45c29e56cb5af967a854"
        
        //Financial Post
        let urlString : String = "https://newsapi.org/v2/top-headlines?sources=financial-post&apiKey=e043e9af6caf45c29e56cb5af967a854"
        let url : URL = URL(string: urlString)!
        let request : URLRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                return
            }
            
            self.newsInfo = [Wrapper]()
            
            do {
                let jsonDict: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                
                let articles =  jsonDict["articles"] as! [[String: AnyObject]]
                
                for item in articles {
                    let source = item["source"] as? [String : AnyObject]
                    let sourceName = source!["name"] as? String
                    let author = item["author"] as? String
                    let title = item["title"] as? String
                    let description = item["description"] as? String
                    let url = item["url"] as? String
                    let urlToImage = item["urlToImage"] as? String
                    let publishedAt = item["publishedAt"] as? String
                    let content = item["content"] as? String
                    
                    let wrapper = Wrapper()
                    
                    wrapper.sourceName = sourceName ?? ""
                    wrapper.author = author ?? ""
                    wrapper.title = title ?? ""
                    wrapper.descrip = description ?? ""
                    wrapper.url = url ?? ""
                    wrapper.urlToImage = urlToImage ?? ""
                    wrapper.publishedAt = publishedAt ?? ""
                    wrapper.content = content ?? ""
                    self.newsInfo.append(wrapper)
                }
                DispatchQueue.main.async {
                    self.economicNewsTableView.reloadData()
                }
            }
            }.resume()
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
    
    //----------------------------------------
    // Return Number of Sections in Table View
    //----------------------------------------
    
    // We have only one section in the table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    //---------------------------------
    // Return Number of Rows in Section
    //---------------------------------
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsInfo.count
    }
    
    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Obtain the object reference of a reusable table view cell object instantiated under the identifier
        // video Cell, which was specified in the storyboard
        let cell: EconomicNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Economic News Cell") as! EconomicNewsTableViewCell
        
        //If url string is invalid, display imageUnavilable.png. Else, display the image of the url
        let url = URL(string: newsInfo[indexPath.item].urlToImage)
        if (url == nil) {
            cell.thumbnailImageView.image = UIImage(named: "imageUnavailable.png")
        }
        else {
            let data = try? Data(contentsOf: url!)
            cell.thumbnailImageView.image = UIImage(data: data!)
            
        }
        
        // Set Title
        cell.newsTitleLabel.text = newsInfo[indexPath.item].title
        
        return cell
    }
    
    //-------------------------------
    // Allow Editing of Rows
    //-------------------------------
    
    // We allow each row (Video) of the table view to be editable, i.e., deletable
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /*
     -----------------------------------
     MARK: - Table View Delegate Methods
     -----------------------------------
     */
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
    
    //--------------------------------
    // News Media Row Selected
    //--------------------------------
    
    // This is the method invoked when the user taps the row and displays that News Media Outlet's website
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowNumber = (indexPath as NSIndexPath).row
        
        // Obtain the stock symbol of the selected Company
        let selectedNewsID = newsInfo[rowNumber]
        
        // Obtain the list of data values of the selected Company as AnyObject
        newsDataObtained = selectedNewsID
        
        performSegue(withIdentifier: "Economic News Info", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let rowNumber = (indexPath as NSIndexPath).row
        
        // Obtain the stock symbol of the selected Company
        let selectedNewsID = newsInfo[rowNumber]
        
        // Obtain the list of data values of the selected Company as AnyObject
        newsDataObtained = selectedNewsID
        
        performSegue(withIdentifier: "Economic News Website", sender: self)
    }
    
    
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "Economic News Website" {
            
            // Obtain the object reference of the destination view controller
            let economicNewsWebsiteViewController: EconomicNewsWebsiteViewController = segue.destination as! EconomicNewsWebsiteViewController
            
            // Pass the data object to the downstream view controller object
            economicNewsWebsiteViewController.newsDataPassed = newsDataObtained
        }
        else if segue.identifier == "Economic News Info" {
            
            // Obtain the object reference of the destination view controller
            let economicNewsInfoViewController: EconomicNewsInfoViewController = segue.destination as! EconomicNewsInfoViewController
            
            // Pass the data object to the downstream view controller object
            economicNewsInfoViewController.newsDataPassed = newsDataObtained
        }
    }
    
}
