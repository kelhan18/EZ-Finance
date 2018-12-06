//
//  ExpensePhotoViewController.swift
//  EZFinance
//
//  Created by CS3714 on 12/4/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit

class ExpensePhotoViewController: UIViewController {
    
    
    @IBOutlet var photoImageView: UIImageView!
    
    var photoPath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageURL = URL(fileURLWithPath: photoPath)
        
        let image = UIImage(contentsOfFile: photoPath)
        
        photoImageView.image = image
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
