//
//  TopNewsWebsiteViewController.swift
//  News
//
//  Created by Keller Han on 10/9/18.
//  Copyright © 2018 Keller Han. All rights reserved.
//

import UIKit
import WebKit

class EconomicNewsWebsiteViewController: UIViewController {
    
    var newsDataPassed: Wrapper!
    
    @IBOutlet var websiteWebView: WKWebView!
    
    @IBOutlet var titleNavigationItem: UINavigationItem!
    
    //Populate the appropriate fields using newsDataPassed from upstream view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Title
        titleNavigationItem.title = newsDataPassed.sourceName
        
        //Declare website URL
        let websiteUrl = URL(string: newsDataPassed.url)
        
        // Obtain the URLRequest structure instance from the given videoUrl
        let request = URLRequest(url: websiteUrl!)
        
        // Ask the web view object to display the web page for the requested URL
        websiteWebView.load(request)
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
