//
//  MyStocksTableViewCell.swift
//  EZFinance
//
//  Created by CS3714 on 12/5/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit

class MyStocksTableViewCell: UITableViewCell {
    
    @IBOutlet var stockNameLabel: UILabel!
    @IBOutlet var changeLabel: UILabel!
    @IBOutlet var marginLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
