//
//  TopNewsInfoViewController.swift
//  News
//
//  Created by Keller Han on 10/9/18.
//  Copyright © 2018 Keller Han. All rights reserved.
//

import UIKit


class EconomicNewsInfoViewController: UIViewController {
    
    var newsDataPassed: Wrapper!
    
    
    @IBOutlet var titleNavigationItem: UINavigationItem!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var publishedAtLabel: UILabel!
    
    @IBAction func readMoreTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Economic News Website", sender: self)
    }
    
    //Populate the appropriate fields using newsDataPassed from upstream view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleNavigationItem.title = newsDataPassed.sourceName
        authorLabel.text = newsDataPassed.author
        
        //If url string invalid, display imageUnavailable. Else, display the image of the url
        let url = URL(string: newsDataPassed.urlToImage)
        if (url == nil) {
            thumbnailImageView.image = UIImage(named: "imageUnavailable.png")
        }
        else {
            let data = try? Data(contentsOf: url!)
            thumbnailImageView.image = UIImage(data: data!)
        }
        
        titleLabel.text = newsDataPassed.title
        descriptionTextView.text = newsDataPassed.descrip
        
        //Format date correctly as specified in specs
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let getDate = date.date(from: newsDataPassed!.publishedAt)
        date.dateFormat = "yyyy-MM-dd 'at' HH:mm:ss"

        publishedAtLabel.text = date.string(from: getDate!)
        
        // Do any additional setup after loading the view.
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
            economicNewsWebsiteViewController.newsDataPassed = newsDataPassed
        }
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
