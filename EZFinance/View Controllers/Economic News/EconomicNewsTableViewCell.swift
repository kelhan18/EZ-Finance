//
//  TopNewsTableViewCell.swift
//  News
//
//  Created by Keller Han on 10/9/18.
//  Copyright © 2018 Keller Han. All rights reserved.
//

import UIKit

class EconomicNewsTableViewCell: UITableViewCell {
    
    @IBOutlet var thumbnailImageView: UIImageView!
    
    @IBOutlet var newsTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
